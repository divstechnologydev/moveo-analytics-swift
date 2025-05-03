//
//  ContentView.swift
//  SimpleExample
//
//  Created by Pavle Rogan on 21.3.25..
//

import SwiftUI

import SwiftUI
import MoveoOneLibrary

struct ContentView: View {
    private let SEMANTIC_GROUP = "content_view"
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
                .onAppear {
                    MoveoOne.instance.tick(
                        moveoOneData: MoveoOneData(
                            semanticGroup: SEMANTIC_GROUP,
                            id: "globe_image",
                            type: .image,
                            action: .appear,
                            value: "globe",
                            metadata: [:]
                        )
                    )
                }
                .onDisappear {
                    MoveoOne.instance.tick(
                        moveoOneData: MoveoOneData(
                            semanticGroup: SEMANTIC_GROUP,
                            id: "globe_image",
                            type: .image,
                            action: .disappear,
                            value: "globe",
                            metadata: [:]
                        )
                    )
                }
            Text("Hello, world!")
                .onAppear {
                    MoveoOne.instance.tick(
                        moveoOneData: MoveoOneData(
                            semanticGroup: SEMANTIC_GROUP,
                            id: "hello_text",
                            type: .text,
                            action: .appear,
                            value: "Hello, world!",
                            metadata: [:]
                        )
                    )
                }
                .onDisappear {
                    MoveoOne.instance.tick(
                        moveoOneData: MoveoOneData(
                            semanticGroup: SEMANTIC_GROUP,
                            id: "hello_text",
                            type: .text,
                            action: .disappear,
                            value: "Hello, world!",
                            metadata: [:]
                        )
                    )
                }
        }
        .padding()
        .onAppear {
            MoveoOne.instance.tick(
                moveoOneData: MoveoOneData(
                    semanticGroup: SEMANTIC_GROUP,
                    id: "screen",
                    type: .custom,
                    action: .appear,
                    value: "ContentView Screen",
                    metadata: [:]
                )
            )
        }
        .onDisappear {
            MoveoOne.instance.tick(
                moveoOneData: MoveoOneData(
                    semanticGroup: SEMANTIC_GROUP,
                    id: "screen",
                    type: .custom,
                    action: .disappear,
                    value: "ContentView Screen",
                    metadata: [:]
                )
            )
        }
    }
}

#Preview {
    ContentView()
}
