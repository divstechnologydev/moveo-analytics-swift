//
//  MoveoOne.swift
//  Moveo (iOS)
//
//  Created by Vladimir Jeftovic on 15.11.23..
//

import Foundation


final class MoveoOne: @unchecked Sendable {
    static let instance: MoveoOne = MoveoOne()
    
    private var buffer: [MoveoOneEntity] = [MoveoOneEntity]()
    private var token: String
    private var userId: String
    
    private var logging = false
    private var flushInterval: Int = 10
    private var maxThreashold: Int = 500
    private var flushTimer: Timer? = nil
    private var started: Bool = false
    private var context: String = ""
    
    private var customPush = false
    
    private let formatter = DateFormatter()
    
    
    init() {
        token = ""
        userId = ""
        formatter.dateFormat = "SSS"
    }
    
    func initialize(token: String) {
        self.token = token
    }
    
    func identify(userId: String) {
        self.userId = userId
    }
    
    func getToken() -> String {
        return self.token
    }
    
    func setLogging(enabled: Bool) {
        self.logging = enabled
    }
    
    func setFlushInterval(interval: Int) {
        self.flushInterval = interval
    }
    
    func isCustomFlush() -> Bool {
        return self.customPush
    }
    
    func start(context: String) {
        if !self.started {
            self.flushOrRecord(isStopOrStart: true)
            self.started = true
            let innerContext: String = context + UUID().uuidString
            self.context = innerContext
            self.verifyContext(context: innerContext)
            self.addEventToBuffer(context: innerContext, type: "start", prop: [:], userId: self.userId)
            self.flushOrRecord(isStopOrStart: false)
        } else {
            print("TAG-DOUBLE already started \(context)")
        }
    }
    
    func stop(context: String, addPrefix: Bool = false) {
        if self.started {
            self.started = false
            self.verifyContext(context: context)
            if addPrefix {
                self.addEventToBuffer(context: context, type: "stop", prop: ["session_type": "test"], userId: self.userId)
            } else {
                self.addEventToBuffer(context: context, type: "stop", prop: [:], userId: self.userId)
            }
            self.flushOrRecord(isStopOrStart: true)
        } else {
            print("TAG-DOUBLE not started for \(context)")
        }
    }
    
    func stop() {
        if self.started {
            self.started = false
            self.verifyContext(context: context)
            self.addEventToBuffer(context: self.context, type: "stop", prop: [:], userId: self.userId)
            self.flushOrRecord(isStopOrStart: true)
        } else {
            print("TAG-DOUBLE not started for \(self.context)")
        }
    }
    
    func track(context: String, properties: [String: String]) {
        if !self.started {
            self.start(context: context)
        }
        self.verifyContext(context: context)
        self.verifyProps(props: properties)
        self.addEventToBuffer(context: context, type: "track", prop: properties, userId: self.userId)
        self.flushOrRecord(isStopOrStart: false)
    }
    
    func tick(properties: [String: String]) {
        if self.started || self.context == "" {
            self.verifyContext(context: context)
            self.start(context: context)
        }
        self.verifyProps(props: properties)
        self.addEventToBuffer(context: self.context, type: "track", prop: properties, userId: self.userId)
    }
    
    
    func flushOrRecord(isStopOrStart: Bool) {
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
    
    func addEventToBuffer(context: String, type: String, prop: [String: String], userId: String) {
        let now = Date.now
        self.buffer.append(MoveoOneEntity(c: context, type: type, userId: userId, t: Int(now.timeIntervalSince1970)*1000 + (Int(formatter.string(from: now)) ?? 0), prop: prop))
    }
    
    func flush() {
        if !customPush {
            self.clearFlushTimeout()
            if self.buffer.count > 0 {
                let dataToSend = buffer.map { originalEntity in
                    return MoveoOneEntity(c: originalEntity.c,
                                          type: originalEntity.type,
                                          userId: originalEntity.userId,
                                          t: originalEntity.t,
                                          prop: originalEntity.prop)
                }
                
                let actor = sendDataActor()
                Task {
                    await actor.sendDataToServer(dataToSend: dataToSend)
                }
                self.buffer.removeAll()
                
            }
        }
    }
    
    func customFlush() -> [MoveoOneEntity] {
        if customPush {
            if self.buffer.count > 0 {
                let dataToSend = buffer.map { originalEntity in
                    return MoveoOneEntity(c: originalEntity.c,
                                          type: originalEntity.type,
                                          userId: originalEntity.userId,
                                          t: originalEntity.t,
                                          prop: originalEntity.prop)
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
    
    actor sendDataActor {
        func sendDataToServer(dataToSend: [MoveoOneEntity]) async {
            let result = await MoveoOneService.shared.storeAnalyticsEvent(payload: MoveoOneAnalyticsRequest(events: dataToSend))
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func setFlushTimeout() {
        flushTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(flushInterval), repeats: false) { timer in
            print("flushing from timer")
            self.flush()
        }
    }
    
    func clearFlushTimeout() {
        self.flushTimer?.invalidate()
        self.flushTimer = nil
    }
    
    
    func verifyContext(context: String) {
        
    }
    
    func verifyProps(props: [String: String]) {
        
    }
}
