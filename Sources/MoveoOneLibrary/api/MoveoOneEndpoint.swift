//
//  MoveoOneEndpoint.swift
//  Moveo (iOS)
//
//  Created by Vladimir Jeftovic on 16.11.23..
//

import Foundation

protocol MoveoOneEndpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: [String: Any]? { get }
    var queryParameters: [URLQueryItem]? { get }
    var urlParameter: String? { get }
    var files: [[String: Any]]? { get }
    var environment: Constants.Environment { get }
    var link: String? { get }
}

extension MoveoOneEndpoint {
    var scheme: String {
        return "https"
    }
    
    var environment: Constants.Environment {
//        #if DEBUG
            return .development
//        #else
//            return .production
//        #endif
    }

    var host: String {
        return "moveo-one-api-web-app.azurewebsites.net"
    }
}
