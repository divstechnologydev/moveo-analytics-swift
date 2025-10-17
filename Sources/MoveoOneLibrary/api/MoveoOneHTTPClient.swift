//
//  MoveoOneHTTPClient.swift
//  Moveo (iOS)
//
//  Created by Vladimir Jeftovic on 16.11.23..
//

import Foundation
import Gzip
import MultipartFormDataKit

@available(iOS 15.0, *)
protocol MoveoOneHTTPClient {
    func sendRequest<T: Decodable>(endpoint: MoveoOneEndpoint, responseModel: T.Type) async -> Result<T, MoveoOneRequestError>
    func sendPredictionRequest<T: Decodable>(endpoint: MoveoOneEndpoint, responseModel: T.Type) async -> Result<T, MoveoOneRequestError>
}

extension MoveoOneHTTPClient {
    func sendRequest<T: Decodable>(
        endpoint: MoveoOneEndpoint,
        responseModel: T.Type
    ) async -> Result<T, MoveoOneRequestError> {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        
        if let queryParameters = endpoint.queryParameters {
            urlComponents.queryItems = queryParameters
        }
        
        if let urlParameter = endpoint.urlParameter {
            urlComponents.path.append("/\(urlParameter)")
        }
        
        
        guard let url = urlComponents.url else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        
        if let files = endpoint.files {
            var partParams = [MultipartFormData.PartParam]()
            
            for (index, file) in files.enumerated() {
                if let data = try? JSONSerialization.data(withJSONObject: file, options: []), let compressedData: Data = try? data.gzipped() {
                    partParams.append((
                        name: "files",
                        filename: "file\(index).gz",
                        mimeType: nil,
                        data: compressedData
                    ))
                }
            }
            let multipartFormData = try! MultipartFormData.Builder.build(
                with:partParams,
                willSeparateBy: RandomBoundaryGenerator.generate()
            )
            request.setValue(multipartFormData.contentType, forHTTPHeaderField: "Content-Type")
            request.httpBody = multipartFormData.body
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            
            MoveoOne.instance.log(msg: request.cURLMoveoOne())
            
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
                        
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                    return .failure(.decode)
                }
                return .success(decodedResponse)
            case 400:
                return .failure(.badRequest)
            case 401:
                return .failure(.unauthorized)
            default:
                return .failure(.unexpectedStatusCode)
            }
        } catch {
            return .failure(.unknown)
        }
    }
    
    func sendPredictionRequest<T: Decodable>(
        endpoint: MoveoOneEndpoint,
        responseModel: T.Type
    ) async -> Result<T, MoveoOneRequestError> {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        
        if let queryParameters = endpoint.queryParameters {
            urlComponents.queryItems = queryParameters
        }
        
        if let urlParameter = endpoint.urlParameter {
            urlComponents.path.append("/\(urlParameter)")
        }
        
        guard let url = urlComponents.url else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        // Set timeout for prediction requests (400ms)
        request.timeoutInterval = 0.4
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            
            MoveoOne.instance.log(msg: request.cURLMoveoOne())
            
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            
            // Handle different response status codes for prediction requests
            switch response.statusCode {
            case 200...299:
                // First try to decode as Dolphin API response format
                if let dolphinResponse = try? JSONDecoder().decode(DolphinPredictionResponse.self, from: data) {
                    // Transform Dolphin response to MoveoOnePredictionResponse
                    let transformedResponse = MoveoOnePredictionResponse(
                        success: true,
                        status: "success",
                        prediction_probability: dolphinResponse.prediction_probability,
                        prediction_binary: dolphinResponse.prediction_binary,
                        message: nil
                    )
                    return .success(transformedResponse as! T)
                } else {
                    // If it's not in Dolphin format, try the original response model
                    guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                        return .failure(.decode)
                    }
                    return .success(decodedResponse)
                }
            case 202:
                // Model is loading or validating
                var pendingMessage = "Model is loading, please try again"
                
                // Try to extract message from response
                if let dolphinResponse = try? JSONDecoder().decode(DolphinPredictionResponse.self, from: data) {
                    pendingMessage = dolphinResponse.message ?? pendingMessage
                }
                
                let errorResponse = MoveoOnePredictionResponse(
                    success: false,
                    status: "pending",
                    message: pendingMessage
                )
                return .success(errorResponse as! T)
            case 404:
                var errorMessage = "Model not found or not accessible"
                if let dolphinResponse = try? JSONDecoder().decode(DolphinPredictionResponse.self, from: data) {
                    errorMessage = dolphinResponse.detail ?? dolphinResponse.message ?? errorMessage
                }
                
                let errorResponse = MoveoOnePredictionResponse(
                    success: false,
                    status: "not_found",
                    message: errorMessage
                )
                return .success(errorResponse as! T)
            case 409:
                var errorMessage = "Conditional event not found"
                if let dolphinResponse = try? JSONDecoder().decode(DolphinPredictionResponse.self, from: data) {
                    errorMessage = dolphinResponse.detail ?? dolphinResponse.message ?? errorMessage
                }
                
                let errorResponse = MoveoOnePredictionResponse(
                    success: false,
                    status: "conflict",
                    message: errorMessage
                )
                return .success(errorResponse as! T)
            case 422:
                var errorMessage = "Invalid prediction data"
                var errorStatus = "invalid_data"
                
                if let dolphinResponse = try? JSONDecoder().decode(DolphinPredictionResponse.self, from: data) {
                    errorMessage = dolphinResponse.detail ?? dolphinResponse.message ?? errorMessage
                    
                    // Check for TargetAlreadyReachedError specifically
                    if let detail = dolphinResponse.detail, detail.contains("Completion target already reached") {
                        errorStatus = "target_already_reached"
                        errorMessage = "Completion target already reached - prediction not applicable"
                    } else if let message = dolphinResponse.message, message.contains("Completion target already reached") {
                        errorStatus = "target_already_reached"
                        errorMessage = "Completion target already reached - prediction not applicable"
                    }
                }
                
                let errorResponse = MoveoOnePredictionResponse(
                    success: false,
                    status: errorStatus,
                    message: errorMessage
                )
                return .success(errorResponse as! T)
            case 500:
                var errorMessage = "Server error processing prediction request"
                if let dolphinResponse = try? JSONDecoder().decode(DolphinPredictionResponse.self, from: data) {
                    errorMessage = dolphinResponse.detail ?? dolphinResponse.message ?? errorMessage
                }
                
                let errorResponse = MoveoOnePredictionResponse(
                    success: false,
                    status: "server_error",
                    message: errorMessage
                )
                return .success(errorResponse as! T)
            case 400:
                return .failure(.badRequest)
            case 401:
                var errorMessage = "Authentication token is invalid or expired"
                if let dolphinResponse = try? JSONDecoder().decode(DolphinPredictionResponse.self, from: data) {
                    errorMessage = dolphinResponse.detail ?? dolphinResponse.message ?? errorMessage
                }
                
                let errorResponse = MoveoOnePredictionResponse(
                    success: false,
                    status: "unauthorized",
                    message: errorMessage
                )
                return .success(errorResponse as! T)
            case 403:
                var errorMessage = "Access denied to this model"
                if let dolphinResponse = try? JSONDecoder().decode(DolphinPredictionResponse.self, from: data) {
                    errorMessage = dolphinResponse.detail ?? dolphinResponse.message ?? errorMessage
                }
                
                let errorResponse = MoveoOnePredictionResponse(
                    success: false,
                    status: "forbidden",
                    message: errorMessage
                )
                return .success(errorResponse as! T)
            default:
                var errorMessage = "Unexpected server response"
                if let dolphinResponse = try? JSONDecoder().decode(DolphinPredictionResponse.self, from: data) {
                    errorMessage = dolphinResponse.detail ?? dolphinResponse.message ?? errorMessage
                }
                
                let errorResponse = MoveoOnePredictionResponse(
                    success: false,
                    status: "server_error",
                    message: errorMessage
                )
                return .success(errorResponse as! T)
            }
        } catch let urlError as URLError where urlError.code == .timedOut {
            let errorResponse = MoveoOnePredictionResponse(
                success: false,
                status: "timeout",
                message: "Request timed out after 400 milliseconds"
            )
            return .success(errorResponse as! T)
        } catch {
            let errorResponse = MoveoOnePredictionResponse(
                success: false,
                status: "network_error",
                message: "Network error - please check your connection"
            )
            return .success(errorResponse as! T)
        }
    }
}

extension URLRequest {
    public func cURLMoveoOne(pretty: Bool = false) -> String {
        let newLine = pretty ? "\\\n" : ""
        let method = (pretty ? "--request " : "-X ") + "\(self.httpMethod ?? "GET") \(newLine)"
        let url: String = (pretty ? "--url " : "") + "\'\(self.url?.absoluteString ?? "")\' \(newLine)"
        
        var cURL = "curl "
        var header = ""
        var data: String = ""
        
        if let httpHeaders = self.allHTTPHeaderFields, httpHeaders.keys.count > 0 {
            for (key,value) in httpHeaders {
                header += (pretty ? "--header " : "-H ") + "\'\(key): \(value)\' \(newLine)"
            }
        }
        
        if let bodyData = self.httpBody, let bodyString = String(data: bodyData, encoding: .utf8),  !bodyString.isEmpty {
            data = "--data '\(bodyString)'"
        }
        
        cURL += method + url + header + data
        
        return cURL
    }
}
