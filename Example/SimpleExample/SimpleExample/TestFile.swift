//
//  TestFile.swift
//  SimpleExample
//
//  Created by Pavle Rogan on 3.4.25..
//

import SwiftUI
import MoveoOne

struct TestView: View {
    let SEMANTIC_GROUP = "example_app"

    var body: some View {
        VStack {
            Text("Sample Text")
                .onAppear {
                    MoveoOne.instance.tick(
                        moveoOneData: MoveoOneData(
                            semanticGroup: SEMANTIC_GROUP,
                            id: "sample_text",
                            type: .text,
                            action: .view,
                            value: "Sample Text",
                            metadata: [:]
                        )
                    )
                }
            
            Button("Sample Button") {
                MoveoOne.instance.tick(
                    moveoOneData: MoveoOneData(
                        semanticGroup: SEMANTIC_GROUP,
                        id: "sample_button",
                        type: .button,
                        action: .click,
                        value: "Sample Button",
                        metadata: [:]
                    )
                )
            }
        }
    }
}
import SwiftUI
import MoveoOne

struct TestView: View {
    let SEMANTIC_GROUP = "example_app"

    var body: some View {
        VStack {
            Text("Sample Text")
                .onAppear {
                    MoveoOne.instance.tick(
                        moveoOneData: MoveoOneData(
                            semanticGroup: SEMANTIC_GROUP,
                            id: "sample_text",
                            type: .text,
                            action: .view,
                            value: "Sample Text",
                            metadata: [:]
                        )
                    )
                }
            
            Button("Sample Button") {
                MoveoOne.instance.tick(
                    moveoOneData: MoveoOneData(
                        semanticGroup: SEMANTIC_GROUP,
                        id: "sample_button",
                        type: .button,
                        action: .click,
                        value: "Sample Button",
                        metadata: [:]
                    )
                )
            }
        }
    }
}
