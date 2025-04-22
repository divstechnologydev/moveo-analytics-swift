import SwiftUI

import SwiftUI
import MoveoOneLibrary

struct MainContentView: View {
    private let SEMANTIC_GROUP = "main_screen"
    @State private var inputText: String = ""
    @State private var navigateToSecondScreen = false  // New state variable for navigation
    
    var body: some View {
        NavigationView {  // Embed in a NavigationView
            ScrollView {
                VStack {
                    Text("Generic App")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color(red: 0.1, green: 0.2, blue: 0.36))
                        .padding(.top, 60)
                        .padding(.bottom, 40)
                        .onAppear {
                            MoveoOne.instance.tick(
                                moveoOneData: MoveoOneData(
                                    semanticGroup: SEMANTIC_GROUP,
                                    id: "main_title_text",
                                    type: .text,
                                    action: .appear,
                                    value: "Generic App",
                                    metadata: [:]
                                )
                            )
                        }
                        .onDisappear {
                            MoveoOne.instance.tick(
                                moveoOneData: MoveoOneData(
                                    semanticGroup: SEMANTIC_GROUP,
                                    id: "main_title_text",
                                    type: .text,
                                    action: .disappear,
                                    value: "Generic App",
                                    metadata: [:]
                                )
                            )
                        }
                    
                    // Content Container
                    VStack {
                        Text("This is a generic SwiftUI app made for demo purposes.")
                            .font(.system(size: 16))
                            .foregroundColor(Color(red: 0.29, green: 0.33, blue: 0.41))
                            .lineSpacing(6)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 30)
                            .onAppear {
                                MoveoOne.instance.tick(
                                    moveoOneData: MoveoOneData(
                                        semanticGroup: SEMANTIC_GROUP,
                                        id: "main_paragraph_text",
                                        type: .text,
                                        action: .appear,
                                        value: "This is a generic SwiftUI app made for demo purposes.",
                                        metadata: [:]
                                    )
                                )
                            }
                            .onDisappear {
                                MoveoOne.instance.tick(
                                    moveoOneData: MoveoOneData(
                                        semanticGroup: SEMANTIC_GROUP,
                                        id: "main_paragraph_text",
                                        type: .text,
                                        action: .disappear,
                                        value: "This is a generic SwiftUI app made for demo purposes.",
                                        metadata: [:]
                                    )
                                )
                            }
                        
                        // Buttons
                        VStack(spacing: 16) {
                            Button("Button One") {
                                MoveoOne.instance.tick(
                                    moveoOneData: MoveoOneData(
                                        semanticGroup: SEMANTIC_GROUP,
                                        id: "button_one",
                                        type: .button,
                                        action: .tap,
                                        value: "Button One",
                                        metadata: [:]
                                    )
                                )
                                // Set state to trigger navigation to second screen
                                navigateToSecondScreen = true
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            .onAppear {
                                MoveoOne.instance.tick(
                                    moveoOneData: MoveoOneData(
                                        semanticGroup: SEMANTIC_GROUP,
                                        id: "button_one",
                                        type: .button,
                                        action: .appear,
                                        value: "Button One",
                                        metadata: [:]
                                    )
                                )
                            }
                            .onDisappear {
                                MoveoOne.instance.tick(
                                    moveoOneData: MoveoOneData(
                                        semanticGroup: SEMANTIC_GROUP,
                                        id: "button_one",
                                        type: .button,
                                        action: .disappear,
                                        value: "Button One",
                                        metadata: [:]
                                    )
                                )
                            }
                            
                            Button("Button Two") {
                                MoveoOne.instance.tick(
                                    moveoOneData: MoveoOneData(
                                        semanticGroup: SEMANTIC_GROUP,
                                        id: "button_two",
                                        type: .button,
                                        action: .tap,
                                        value: "Button Two",
                                        metadata: [:]
                                    )
                                )
                                handleButtonPress("Button Two")
                            }
                            .buttonStyle(SecondaryButtonStyle())
                            .onAppear {
                                MoveoOne.instance.tick(
                                    moveoOneData: MoveoOneData(
                                        semanticGroup: SEMANTIC_GROUP,
                                        id: "button_two",
                                        type: .button,
                                        action: .appear,
                                        value: "Button Two",
                                        metadata: [:]
                                    )
                                )
                            }
                            .onDisappear {
                                MoveoOne.instance.tick(
                                    moveoOneData: MoveoOneData(
                                        semanticGroup: SEMANTIC_GROUP,
                                        id: "button_two",
                                        type: .button,
                                        action: .disappear,
                                        value: "Button Two",
                                        metadata: [:]
                                    )
                                )
                            }
                        }
                        .padding(.bottom, 20)
                        
                        // Text Field
                        TextField("Type something...", text: $inputText)
                            .textFieldStyle(GenericTextFieldStyle())
                            .onAppear {
                                MoveoOne.instance.tick(
                                    moveoOneData: MoveoOneData(
                                        semanticGroup: SEMANTIC_GROUP,
                                        id: "main_textfield",
                                        type: .textEdit,
                                        action: .appear,
                                        value: "Type something...",
                                        metadata: [:]
                                    )
                                )
                            }
                            .onDisappear {
                                MoveoOne.instance.tick(
                                    moveoOneData: MoveoOneData(
                                        semanticGroup: SEMANTIC_GROUP,
                                        id: "main_textfield",
                                        type: .textEdit,
                                        action: .disappear,
                                        value: "Type something...",
                                        metadata: [:]
                                    )
                                )
                            }
                            .onSubmit {
                                MoveoOne.instance.tick(
                                    moveoOneData: MoveoOneData(
                                        semanticGroup: SEMANTIC_GROUP,
                                        id: "main_textfield",
                                        type: .textEdit,
                                        action: .submit,
                                        value: inputText,
                                        metadata: [:]
                                    )
                                )
                                handleInputSubmit()
                            }
                    }
                    .padding(25)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color(red: 0.17, green: 0.42, blue: 0.69).opacity(0.1), radius: 10, y: 4)
                    .frame(maxWidth: 350)
                }
                .padding(.horizontal, 20)
                
                // Hidden NavigationLink that triggers on state change
                NavigationLink(destination: SecondScreen(), isActive: $navigateToSecondScreen) {
                    EmptyView()
                }
            }
            .background(Color(red: 0.94, green: 0.97, blue: 0.98))
            .navigationBarHidden(true)
            .onAppear {
                MoveoOne.instance.tick(
                    moveoOneData: MoveoOneData(
                        semanticGroup: SEMANTIC_GROUP,
                        id: "main_scrollview",
                        type: .scrollView,
                        action: .appear,
                        value: "Main ScrollView",
                        metadata: [:]
                    )
                )
            }
            .onDisappear {
                MoveoOne.instance.tick(
                    moveoOneData: MoveoOneData(
                        semanticGroup: SEMANTIC_GROUP,
                        id: "main_scrollview",
                        type: .scrollView,
                        action: .disappear,
                        value: "Main ScrollView",
                        metadata: [:]
                    )
                )
            }
        }
        .onAppear {
            MoveoOne.instance.tick(
                moveoOneData: MoveoOneData(
                    semanticGroup: SEMANTIC_GROUP,
                    id: "main_screen_view",
                    type: .custom,
                    action: .appear,
                    value: "Main Screen View",
                    metadata: [:]
                )
            )
        }
        .onDisappear {
            MoveoOne.instance.tick(
                moveoOneData: MoveoOneData(
                    semanticGroup: SEMANTIC_GROUP,
                    id: "main_screen_view",
                    type: .custom,
                    action: .disappear,
                    value: "Main Screen View",
                    metadata: [:]
                )
            )
        }
    }
    
   private func trackParagraphImpression() {
        print("Paragraph viewed")
    }

    private func handleButtonPress(_ buttonName: String) {
        print("\(buttonName) pressed")
    }

    private func handleInputSubmit() {
        print("Input submitted: \(inputText)")
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color(red: 0.17, green: 0.42, blue: 0.69))
            .cornerRadius(12)
            .shadow(color: Color(red: 0.17, green: 0.42, blue: 0.69).opacity(0.2), radius: 4, y: 2)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color(red: 0.26, green: 0.6, blue: 0.88))
            .cornerRadius(12)
            .shadow(color: Color(red: 0.26, green: 0.6, blue: 0.88).opacity(0.2), radius: 4, y: 2)
    }
}

struct GenericTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(red: 0.89, green: 0.91, blue: 0.94), lineWidth: 1)
            )
    }
}

import SwiftUI
import MoveoOneLibrary

@main
struct GenericApp: App {
    init() {
        MoveoOne.instance.initialize(token: "YOUR_SDK_TOKEN")
        MoveoOne.instance.start(context: "app_launch")
        MoveoOne.instance.setLogging(enabled: true)
        MoveoOne.instance.setFlushInterval(interval: 10)
    }
    var body: some Scene {
        WindowGroup {
            MainContentView()
        }
    }
}
