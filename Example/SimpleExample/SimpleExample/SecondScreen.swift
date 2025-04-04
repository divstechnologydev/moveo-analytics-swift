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
