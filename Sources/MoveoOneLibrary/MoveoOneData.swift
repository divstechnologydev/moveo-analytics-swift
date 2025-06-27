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
    var userId: String
    var t: Int
    var prop: [String: String]
    var meta: [String: String]
    var sId: String
    var additionalMeta: [String: String]?

    
    init(c: String, type: Constants.MoveoOneEventType, userId: String, t: Int, prop: [String : String], meta: [String: String], sId: String, additionalMeta: [String: String]? = nil) {
        self.c = c
        self.type = type.rawValue
        self.userId = userId
        self.t = t
        self.prop = prop
        self.meta = meta
        self.sId = sId
        self.additionalMeta = additionalMeta
    }
    
    init(c: String, type: String, userId: String, t: Int, prop: [String : String], meta: [String: String], sId: String, additionalMeta: [String: String]? = nil) {
        self.c = c
        self.type = type
        self.userId = userId
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


struct BuzzFeedbackModel: Encodable {
    let sessionId: String
    let numberOfDrinks: Double
    
    init(sessionId: String, numberOfDrinks: Double) {
        self.sessionId = sessionId
        self.numberOfDrinks = numberOfDrinks
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

