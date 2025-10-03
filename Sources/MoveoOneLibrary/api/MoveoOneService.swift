//
//  MoveoOneService.swift
//  Moveo (iOS)
//
//  Created by Vladimir Jeftovic on 16.11.23..
//

import Foundation

 @available(iOS 15.0, macOS 12.0, *)
protocol MoveoOneServicable {
     func storeAnalyticsEvent(payload: MoveoOneAnalyticsRequest) async -> Result<SaveDataResponse, MoveoOneRequestError>
     func storeAnalyticsSyncEvent(payload: MoveoOneAnalyticsRequest) async -> Result<MoveoOneAnalyticsResponse, MoveoOneRequestError>
     func predict(modelId: String, payload: MoveoOnePredictionRequest) async -> Result<MoveoOnePredictionResponse, MoveoOneRequestError>
 }

@available(iOS 15.0, macOS 12.0, *)
struct MoveoOneService: MoveoOneHTTPClient, MoveoOneServicable {
    static let shared = MoveoOneService()
    
    func storeAnalyticsEvent(payload: MoveoOneAnalyticsRequest) async -> Result<SaveDataResponse, MoveoOneRequestError> {
        return await sendRequest(endpoint: MoveoOneEnpoints.analyticsEvent(parameters: payload.dictionary ?? [String: Any] ()), responseModel: SaveDataResponse.self)
    }
    
    func storeAnalyticsSyncEvent(payload: MoveoOneAnalyticsRequest) async -> Result<MoveoOneAnalyticsResponse, MoveoOneRequestError> {
        return await sendRequest(endpoint: MoveoOneEnpoints.analyticsSyncEvent(parameters: payload.dictionary ?? [String: Any] ()), responseModel: MoveoOneAnalyticsResponse.self)
    }
    
    func predict(modelId: String, payload: MoveoOnePredictionRequest) async -> Result<MoveoOnePredictionResponse, MoveoOneRequestError> {
        return await sendPredictionRequest(endpoint: MoveoOneEnpoints.predict(modelId: modelId, parameters: payload.dictionary ?? [String: Any]()), responseModel: MoveoOnePredictionResponse.self)
    }
}
