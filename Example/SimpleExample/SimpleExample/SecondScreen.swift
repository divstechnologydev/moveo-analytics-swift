//
//  SecondScreen.swift
//  SimpleExample
//
//  Created by Pavle Rogan on 4.4.25..
//

import SwiftUI
import MoveoOneLibrary

struct SecondScreen: View {
    let SEMANTIC_GROUP = "second_screen"

    var body: some View {
        VStack {
            Text("This is second screen")
                .font(.largeTitle)
                .padding()
                .onAppear {
                    MoveoOne.instance.tick(
                        moveoOneData: MoveoOneData(
                            semanticGroup: SEMANTIC_GROUP,
                            id: "second_screen_text",
                            type: .text,
                            action: .view,
                            value: "This is second screen",
                            metadata: [:]
                        )
                    )
                }
        }
        .navigationBarTitle("Second Screen", displayMode: .inline)
        .onAppear {
            MoveoOne.instance.tick(
                moveoOneData: MoveoOneData(
                    semanticGroup: SEMANTIC_GROUP,
                    id: "second_screen",
                    type: .screen,
                    action: .appear,
                    value: "Second Screen",
                    metadata: [:]
                )
            )
        }
        .onDisappear {
            MoveoOne.instance.tick(
                moveoOneData: MoveoOneData(
                    semanticGroup: SEMANTIC_GROUP,
                    id: "second_screen",
                    type: .screen,
                    action: .disappear,
                    value: "Second Screen",
                    metadata: [:]
                )
            )
        }
    }
}

struct SecondScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SecondScreen()
        }
    }
}
