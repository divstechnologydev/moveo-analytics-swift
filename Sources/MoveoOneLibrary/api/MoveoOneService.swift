//
//  MoveoOneService.swift
//  Moveo (iOS)
//
//  Created by Vladimir Jeftovic on 16.11.23..
//

import Foundation

protocol MoveoOneServicable {
    func storeAnalyticsEvent(payload: MoveoOneAnalyticsRequest) async -> Result<SaveDataResponse, MoveoOneRequestError>
    func storeAnalyticsSyncEvent(payload: MoveoOneAnalyticsRequest) async -> Result<MoveoOneAnalyticsResponse, MoveoOneRequestError>
}

struct MoveoOneService: MoveoOneHTTPClient, MoveoOneServicable {
    static var shared = MoveoOneService()
    
    func storeAnalyticsEvent(payload: MoveoOneAnalyticsRequest) async -> Result<SaveDataResponse, MoveoOneRequestError> {
        return await sendRequest(endpoint: MoveoOneEnpoints.analyticsEvent(parameters: payload.dictionary ?? [String: Any] ()), responseModel: SaveDataResponse.self)
    }
    
    func storeAnalyticsSyncEvent(payload: MoveoOneAnalyticsRequest) async -> Result<MoveoOneAnalyticsResponse, MoveoOneRequestError> {
        return await sendRequest(endpoint: MoveoOneEnpoints.analyticsSyncEvent(parameters: payload.dictionary ?? [String: Any] ()), responseModel: MoveoOneAnalyticsResponse.self)
    }
}
