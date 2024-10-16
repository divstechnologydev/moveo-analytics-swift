//
//  MoveoOneHTTPClient.swift
//  Moveo (iOS)
//
//  Created by Vladimir Jeftovic on 16.11.23..
//

import Foundation
import Gzip
import MultipartFormDataKit

protocol MoveoOneHTTPClient {
    func sendRequest<T: Decodable>(endpoint: MoveoOneEndpoint, responseModel: T.Type) async -> Result<T, MoveoOneRequestError>
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
