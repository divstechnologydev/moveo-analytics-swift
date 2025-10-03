//
//  MoveoOneEnpoints.swift
//  Moveo (iOS)
//
//  Created by Vladimir Jeftovic on 16.11.23..
//

import Foundation

enum MoveoOneEnpoints {
    case analyticsEvent(parameters: [String: Any])
    case analyticsSyncEvent(parameters: [String: Any])
    case predict(modelId: String, parameters: [String: Any])
}

extension MoveoOneEnpoints: MoveoOneEndpoint {
    var path: String {
        switch self {
        case .predict:
            return pathValue // Dolphin service has different URL structure
        default:
            return "/api/" + pathValue
        }
    }
    
    var pathValue: String {
        switch self {
        case .analyticsEvent:
            return "analytic/event"
        case .analyticsSyncEvent:
            return "analytic/event-sync"
        case .predict(let modelId, _):
            return "/api/models/\(modelId)/predict"

        }
    }

    var method: RequestMethod {
        switch self {
        case .analyticsEvent, .analyticsSyncEvent, .predict:
            return .post
        }
    }

    var header: [String: String]? {
        switch self {
        default:
            return [
                "Authorization": "\(MoveoOne.instance.getToken())",
                "Content-Type": "application/json;charset=utf-8"
            ]
        }
    }
    
    var body: [String: Any]? {
        switch self {
        case .analyticsEvent(let parameters), .analyticsSyncEvent(let parameters), .predict(_, let parameters):
            return parameters
        default:
            return nil
        }
    }
    
    var host: String {
        switch self {
        case .predict:
            return "dolphin-dev-978019819001.europe-west1.run.app"
        default:
            return "api.moveo.one"
        }
    }
    
    var queryParameters: [URLQueryItem]? {
        switch self {
        default:
            return nil
        }
    }
    
    var urlParameter: String? {
        switch(self) {
        default:
            return nil
        }
    }
    
    var files: [[String: Any]]? {
        switch(self) {
        default:
            return nil
        }
    }
    
    var link: String? {
        switch(self) {
        default:
            return nil
        }
    }
    
    var isDev: Bool {
        return environment == .development
    }
}
