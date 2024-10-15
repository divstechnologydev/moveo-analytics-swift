//
//  Extensions.swift
//  MoveoOneLibrary
//
//  Created by Vladimir Jeftovic on 15.10.24..
//

import Foundation
import SwiftUI

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
    var array: [[String: Any]]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [[String: Any]] }
    }
}

extension Character {
    var isEmoji: Bool {
        return unicodeScalars.first?.properties.isEmojiPresentation ?? false
    }
}
