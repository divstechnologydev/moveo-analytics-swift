//
//  SecondScreen.swift
//  SimpleExample
//
//  Created by Pavle Rogan on 4.4.25..
//

import SwiftUI

struct SecondScreen: View {
    var body: some View {
        VStack {
            Text("This is second screen")
                .font(.largeTitle)
                .padding()
                .onAppear {
                    MoveoOne.instance.tick(
                        moveoOneData: MoveoOneData(
                            semanticGroup: "second_screen",
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
    }
}

struct SecondScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SecondScreen()
        }
    }
}
