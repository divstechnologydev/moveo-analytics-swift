//
//  SecondScreen.swift
//  SimpleExample
//
//  Created by Pavle Rogan on 4.4.25..
//

import SwiftUI

import SwiftUI
import MoveoOneLibrary

struct SecondScreen: View {
    private let SEMANTIC_GROUP = "second_screen"
    var body: some View {
        VStack {
            Text("This is second screen")
                .font(.largeTitle)
                .padding()
                .onAppear {
                    MoveoOne.instance.tick(
                        moveoOneData: MoveoOneData(
                            semanticGroup: SEMANTIC_GROUP,
                            id: "second_screen_title_text",
                            type: .text,
                            action: .appear,
                            value: "This is second screen",
                            metadata: [:]
                        )
                    )
                }
                .onDisappear {
                    MoveoOne.instance.tick(
                        moveoOneData: MoveoOneData(
                            semanticGroup: SEMANTIC_GROUP,
                            id: "second_screen_title_text",
                            type: .text,
                            action: .disappear,
                            value: "This is second screen",
                            metadata: [:]
                        )
                    )
                }
        }
        .onAppear {
            MoveoOne.instance.tick(
                moveoOneData: MoveoOneData(
                    semanticGroup: SEMANTIC_GROUP,
                    id: "second_screen_view",
                    type: .custom,
                    action: .appear,
                    value: "Second Screen View",
                    metadata: [:]
                )
            )
        }
        .onDisappear {
            MoveoOne.instance.tick(
                moveoOneData: MoveoOneData(
                    semanticGroup: SEMANTIC_GROUP,
                    id: "second_screen_view",
                    type: .custom,
                    action: .disappear,
                    value: "Second Screen View",
                    metadata: [:]
                )
            )
        }
        .navigationBarTitle("Second Screen", displayMode: .inline)
    }
}

struct SecondScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SecondScreen()
        }
    }
}
