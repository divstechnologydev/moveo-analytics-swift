//
//  MoveoOneData.swift
//  Moveo (iOS)
//
//  Created by Vladimir Jeftovic on 15.11.23..
//

import Foundation


public struct MoveoOneData {
    public let semanticGroup: String
    public let id: String
    public let type: Constants.MoveoOneType
    public let action: Constants.MoveoOneAction
    public let value: Any
    public let metadata: [String: String]?
    
    public init(semanticGroup: String, id: String, type: Constants.MoveoOneType, action: Constants.MoveoOneAction, value: Any, metadata: [String : String]?) {
        self.semanticGroup = semanticGroup
        self.id = id
        self.type = type
        self.action = action
        self.value = value
        self.metadata = metadata
    }
}

struct MoveoOneEntity: Codable {
    var c: String //context
    var type: String
    var t: Int
    var prop: [String: String]
    var meta: [String: String]
    var sId: String
    var additionalMeta: [String: String]?

    
    init(c: String, type: Constants.MoveoOneEventType, t: Int, prop: [String : String], meta: [String: String], sId: String, additionalMeta: [String: String]? = nil) {
        self.c = c
        self.type = type.rawValue
        self.t = t
        self.prop = prop
        self.meta = meta
        self.sId = sId
        self.additionalMeta = additionalMeta
    }
    
    init(c: String, type: String, t: Int, prop: [String : String], meta: [String: String], sId: String, additionalMeta: [String: String]? = nil) {
        self.c = c
        self.type = type
        self.t = t
        self.prop = prop
        self.meta = meta
        self.sId = sId
        self.additionalMeta = additionalMeta
    }
}

struct MoveoOneAnalyticsRequest: Codable {
    var events: [MoveoOneEntity]
}

struct MoveoOneAnalyticsResponse: Codable {
    var predictions: [MoveoOnePrediction]
}

struct Dp: Codable {
    var x: Double
    var y: Double
}

struct MoveoOnePrediction: Codable {
    var sessionId: String
    var impairmentLevel: Double?
    var trainingCompleted: Bool
    var errorCode: String?
}

public struct MoveoOnePredictionResponse: Codable {
    public let success: Bool
    public let status: String
    public let prediction_probability: Double?
    public let prediction_binary: Bool?
    public let message: String?
    
    public init(success: Bool, status: String, prediction_probability: Double? = nil, prediction_binary: Bool? = nil, message: String? = nil) {
        self.success = success
        self.status = status
        self.prediction_probability = prediction_probability
        self.prediction_binary = prediction_binary
        self.message = message
    }
}

struct MoveoOnePredictionRequest: Codable {
    let events: [MoveoOneEntity]
    let session_id: String
}

// Temporary struct to capture Dolphin API response format
struct DolphinPredictionResponse: Codable {
    let model_id: String?
    let prediction_probability: Double?
    let prediction_binary: Bool?
    let message: String?
    let detail: String?
}


struct BuzzFeedbackModel: Encodable {
    let sessionId: String
    let numberOfDrinks: Double
    
    init(sessionId: String, numberOfDrinks: Double) {
        self.sessionId = sessionId
        self.numberOfDrinks = numberOfDrinks
    }
}

// Latency tracking models
struct MoveoOneLatencyRequest: Codable {
    let model_id: String
    let session_id: String
    let client: String
    let total_execution_time_ms: Int
    let latency_data: [String: Any]
    
    init(model_id: String, session_id: String, client: String, total_execution_time_ms: Int, latency_data: [String: Any]) {
        self.model_id = model_id
        self.session_id = session_id
        self.client = client
        self.total_execution_time_ms = total_execution_time_ms
        self.latency_data = latency_data
    }
}

struct MoveoOneLatencyResponse: Codable {
    let success: Bool
    let message: String?
    
    init(success: Bool, message: String? = nil) {
        self.success = success
        self.message = message
    }
}


extension Dp {
    func asDictionary() throws -> [String: Any] {
      let data = try JSONEncoder().encode(self)
      guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
        throw NSError()
      }
      return dictionary
    }
}

extension MoveoOneAnalyticsRequest {
    func asDictionary() throws -> [String: Any] {
      let data = try JSONEncoder().encode(self)
      guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
        throw NSError()
      }
      return dictionary
    }
}

extension MoveoOnePrediction {
    func asDictionary() throws -> [String: Any] {
      let data = try JSONEncoder().encode(self)
      guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
        throw NSError()
      }
      return dictionary
    }
}

extension MoveoOneAnalyticsResponse {
    func asDictionary() throws -> [String: Any] {
      let data = try JSONEncoder().encode(self)
      guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
        throw NSError()
      }
      return dictionary
    }
}

extension MoveoOnePredictionRequest {
    func asDictionary() throws -> [String: Any] {
      let data = try JSONEncoder().encode(self)
      guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
        throw NSError()
      }
      return dictionary
    }
}

extension MoveoOneLatencyRequest {
    func asDictionary() throws -> [String: Any] {
      let data = try JSONEncoder().encode(self)
      guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
        throw NSError()
      }
      return dictionary
    }
}

