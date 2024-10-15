//
//  MoveoOneRequestError.swift
//  Moveo (iOS)
//
//  Created by Vladimir Jeftovic on 16.11.23..
//

enum MoveoOneRequestError: Error {
    case decode
    case invalidURL
    case badRequest
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unknown
    
    var customMessage: String {
        switch self {
        case .decode:
            return "Decode error"
        case .unauthorized:
            return "Session expired"
        case .badRequest:
            return "Bad request"
        default:
            return "Unknown error"
        }
    }
}
