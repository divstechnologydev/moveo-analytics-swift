//
//  MoveoOne.swift
//  Moveo (iOS)
//
//  Created by Vladimir Jeftovic on 15.11.23..
//

import Foundation


public final class MoveoOne: @unchecked Sendable {
    public static let instance: MoveoOne = MoveoOne()
    
    private var buffer: [MoveoOneEntity] = [MoveoOneEntity]()
    private var token: String
    
    private var logging = false
    private var flushInterval: Int = 10
    private var maxThreashold: Int = 500
    private var flushTimer: Timer? = nil
    private var started: Bool = false
    private var context: String = ""
    private var sessionId: String = ""
    
    private var customPush = false
    
    private let formatter = DateFormatter()
    
    
    private init() {
        token = ""
        formatter.dateFormat = "SSS"
    }
    
    public func initialize(token: String) {
        self.token = token
    }
    
    public func getToken() -> String {
        return self.token
    }
    
    public func setLogging(enabled: Bool) {
        self.logging = enabled
    }
    
    public func setFlushInterval(interval: Int) {
        self.flushInterval = interval
    }
    
    public func isCustomFlush() -> Bool {
        return self.customPush
    }
    
    public func start(context: String, metadata: [String: String]?) {
        log(msg: "start")
        if !self.started {
            self.flushOrRecord(isStopOrStart: true)
            self.started = true
            self.context = context
            self.verifyContext(context: context)
            self.sessionId = "sid_" + UUID().uuidString
            
            var updatedMetadata = metadata ?? [:]
            updatedMetadata["lib_version"] = Constants.libVersion
            
            self.addEventToBuffer(context: self.context, type: Constants.MoveoOneEventType.start_session, prop: [:], sessionId: self.sessionId, meta: updatedMetadata)
            self.flushOrRecord(isStopOrStart: false)
        }
    }
    
    public func track(context: String, moveoOneData: MoveoOneData) {
        log(msg: "track")
        var properties: [String: String] = [:]
        properties["sg"] = moveoOneData.semanticGroup
        properties["eID"] = moveoOneData.id
        //properties["eA"] = moveoOneData.action.rawValue
        properties["eA"] = moveoOneData.action.normalized.rawValue
        properties["eT"] = moveoOneData.type.rawValue
        if let stringValue = moveoOneData.value as? String {
            properties["eV"] = stringValue
        } else if let stringArray = moveoOneData.value as? [String] {
            properties["eV"] = stringArray.joined(separator: ",")
        } else if let intValue = moveoOneData.value as? Int {
            properties["eV"] = String(intValue)
        } else if let doubleValue = moveoOneData.value as? Double {
            properties["eV"] = String(doubleValue)
        } else {
            properties["eV"] = "-"
        }

        track(context: context, properties: properties, metadata: moveoOneData.metadata ?? [:])
    }
    
    public func tick (moveoOneData: MoveoOneData) {
        log(msg: "tick")
        var properties: [String: String] = [:]
        properties["sg"] = moveoOneData.semanticGroup
        properties["eID"] = moveoOneData.id
        //properties["eA"] = moveoOneData.action.rawValue
        properties["eA"] = moveoOneData.action.normalized.rawValue

        properties["eT"] = moveoOneData.type.rawValue
        if let stringValue = moveoOneData.value as? String {
            properties["eV"] = stringValue
        } else if let stringArray = moveoOneData.value as? [String] {
            properties["eV"] = stringArray.joined(separator: ",")
        } else if let intValue = moveoOneData.value as? Int {
            properties["eV"] = String(intValue)
        } else if let doubleValue = moveoOneData.value as? Double {
            properties["eV"] = String(doubleValue)
        } else {
            properties["eV"] = "-"
        }
        
        tick(properties: properties, metadata: moveoOneData.metadata ?? [:])
    }
    
    public func updateSessionMetadata(metadata: [String: String]) {
        log(msg: "update session metadata")
        if self.started {
            self.addEventToBuffer(context: self.context, type: Constants.MoveoOneEventType.update_metadata, prop: [:], sessionId: self.sessionId, meta: metadata)
            self.flushOrRecord(isStopOrStart: false)
        }
    }
    
    public func updateAdditionalMetadata(additionalMeta: [String: String]) {
        log(msg: "update additional metadata")
        if self.started {
            self.addEventToBufferWithAdditionalMeta(context: self.context, type: Constants.MoveoOneEventType.update_metadata, prop: [:], sessionId: self.sessionId, meta: [:], additionalMeta: additionalMeta)
            self.flushOrRecord(isStopOrStart: false)
        }
    }
    
    private func track(context: String, properties: [String: String], metadata: [String: String]) {
        if !self.started {
            self.start(context: context, metadata: metadata)
        }
        self.verifyContext(context: context)
        self.verifyProps(props: properties)
        self.addEventToBuffer(context: context, type: Constants.MoveoOneEventType.track, prop: properties, sessionId: self.sessionId, meta: metadata)
        self.flushOrRecord(isStopOrStart: false)
    }
    
    private func tick(properties: [String: String], metadata: [String: String]) {
        if self.context == "" {
            self.verifyContext(context: context)
            self.start(context: context, metadata: metadata)
        }
        self.verifyProps(props: properties)
        self.addEventToBuffer(context: self.context, type: Constants.MoveoOneEventType.track, prop: properties, sessionId: self.sessionId, meta: metadata)
        self.flushOrRecord(isStopOrStart: false)
    }
    
    
    private func flushOrRecord(isStopOrStart: Bool) {
        if !customPush {
            if buffer.count >= maxThreashold || isStopOrStart {
                flush()
            } else {
                if flushTimer == nil {
                    setFlushTimeout()
                }
            }
        }
    }
    
    private func addEventToBuffer(context: String, type: Constants.MoveoOneEventType, prop: [String: String], sessionId: String, meta: [String: String]) {
        let now = Date.now
        self.buffer.append(
            MoveoOneEntity(
                c: context,
                type: type,
                t: Int(now.timeIntervalSince1970)*1000 + (Int(formatter.string(from: now)) ?? 0),
                prop: prop,
                meta: meta,
                sId: sessionId
            )
        )
    }
    
    private func addEventToBufferWithAdditionalMeta(context: String, type: Constants.MoveoOneEventType, prop: [String: String], sessionId: String, meta: [String: String], additionalMeta: [String: String]) {
        let now = Date.now
        self.buffer.append(
            MoveoOneEntity(
                c: context,
                type: type,
                t: Int(now.timeIntervalSince1970)*1000 + (Int(formatter.string(from: now)) ?? 0),
                prop: prop,
                meta: meta,
                sId: sessionId,
                additionalMeta: additionalMeta
            )
        )
    }
    
    private func flush() {
        if !customPush {
            log(msg: "flush")
            self.clearFlushTimeout()
            if self.buffer.count > 0 {
                let dataToSend = buffer.map { originalEntity in
                    return MoveoOneEntity(
                        c: originalEntity.c,
                        type: originalEntity.type,
                        t: originalEntity.t,
                        prop: originalEntity.prop,
                        meta: originalEntity.meta,
                        sId: originalEntity.sId,
                        additionalMeta: originalEntity.additionalMeta
                    )
                }
                
                let actor = sendDataActor()
                Task {
                    await actor.sendDataToServer(dataToSend: dataToSend)
                }
                self.buffer.removeAll()
                
            }
        }
    }
    
    private func customFlush() -> [MoveoOneEntity] {
        if customPush {
            if self.buffer.count > 0 {
                let dataToSend = buffer.map { originalEntity in
                    return MoveoOneEntity(
                        c: originalEntity.c,
                        type: originalEntity.type,
                        t: originalEntity.t,
                        prop: originalEntity.prop,
                        meta: originalEntity.meta,
                        sId: originalEntity.sId,
                        additionalMeta: originalEntity.additionalMeta
                    )
                }
                self.buffer.removeAll()
                return dataToSend
            } else {
                return []
            }
        } else {
            return []
        }
    }
    
    private actor sendDataActor {
        func sendDataToServer(dataToSend: [MoveoOneEntity]) async {
            let result = await MoveoOneService.shared.storeAnalyticsEvent(payload: MoveoOneAnalyticsRequest(events: dataToSend))
            switch result {
            case .success(let response):
                MoveoOne.instance.log(msg: response)
            case .failure(let error):
                MoveoOne.instance.log(msg: error)
            }
        }
    }
    
    
    private func setFlushTimeout() {
        log(msg: "setting flush timeout")
        flushTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(flushInterval), repeats: false) { timer in
            self.flush()
        }
    }
    
    private func clearFlushTimeout() {
        self.flushTimer?.invalidate()
        self.flushTimer = nil
    }
    
    
    private func verifyContext(context: String) {
        
    }
    
    private func verifyProps(props: [String: String]) {
        
    }
    
    public func log(msg: Any) {
        if self.logging {
            print("MoveoOne -> ", msg)
        }
    }
    
    public func isStarted() -> Bool {
        return self.started
    }
    
    public func getContext() -> String {
        return self.context
    }
}
