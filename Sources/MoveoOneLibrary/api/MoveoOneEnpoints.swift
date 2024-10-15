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
}

extension MoveoOneEnpoints: MoveoOneEndpoint {
    var path: String {
        "/api/" + pathValue
    }
    
    var pathValue: String {
        switch self {
        case .analyticsEvent:
            return "analytic/event"
        case .analyticsSyncEvent:
            return "analytic/event-sync"
        
        }
    }

    var method: RequestMethod {
        switch self {
        case .analyticsEvent, .analyticsSyncEvent:
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
        case .analyticsEvent(let parameters), .analyticsSyncEvent(let parameters):
            return parameters
        default:
            return nil
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
