import MoveoOneLibrary
import SwiftUI

struct MainContentView: View {
    @State private var inputText: String = ""
    private let SEMANTIC_GROUP = "main_screen"
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    Text("Moveo One")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color(red: 0.1, green: 0.2, blue: 0.36))
                        .padding(.top, 60)
                        .padding(.bottom, 40)
                        .onAppear {
                            MoveoOne.instance.tick(
                                moveoOneData: MoveoOneData(
                                    semanticGroup: SEMANTIC_GROUP,
                                    id: "title_text",
                                    type: .text,
                                    action: .appear,
                                    value: "Moveo One",
                                    metadata: [:]
                                )
                            )
                        }
                        .onDisappear {
                            MoveoOne.instance.tick(
                                moveoOneData: MoveoOneData(
                                    semanticGroup: SEMANTIC_GROUP,
                                    id: "title_text",
                                    type: .text,
                                    action: .disappear,
                                    value: "Moveo One",
                                    metadata: [:]
                                )
                            )
                        }
                    // Content Container
                    VStack {
                        Text("This is an example SwiftUI app made for demo purposes.")
                            .font(.system(size: 16))
                            .foregroundColor(Color(red: 0.29, green: 0.33, blue: 0.41))
                            .lineSpacing(6)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 30)
                            .onAppear {
                                MoveoOne.instance.tick(
                                    moveoOneData: MoveoOneData(
                                        semanticGroup: SEMANTIC_GROUP,
                                        id: "intro_paragraph",
                                        type: .text,
                                        action: .appear,
                                        value: "This is an example SwiftUI app made for demo purposes.",
                                        metadata: [:]
                                    )
                                )
                                trackParagraphImpression()
                            }
                            .onDisappear {
                                MoveoOne.instance.tick(
                                    moveoOneData: MoveoOneData(
                                        semanticGroup: SEMANTIC_GROUP,
                                        id: "intro_paragraph",
                                        type: .text,
                                        action: .disappear,
                                        value: "This is an example SwiftUI app made for demo purposes.",
                                        metadata: [:]
                                    )
                                )
                            }
                        // Buttons
                        VStack(spacing: 16) {
                            Button("Button One") {
                                handleButtonPress("Button One")
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
                            }
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
                            .buttonStyle(MoveoButtonStyle(primary: true))
                            Button("Button Two") {
                                handleButtonPress("Button Two")
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
                            }
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
                            .buttonStyle(MoveoButtonStyle(primary: false))
                        }
                        .padding(.bottom, 20)
                        // Text Field
                        TextField("Type something...", text: $inputText)
                            .textFieldStyle(MoveoTextFieldStyle())
                            .onSubmit {
                                handleInputSubmit()
                                MoveoOne.instance.tick(
                                    moveoOneData: MoveoOneData(
                                        semanticGroup: SEMANTIC_GROUP,
                                        id: "main_input",
                                        type: .textEdit,
                                        action: .input,
                                        value: inputText,
                                        metadata: ["input_length": String(inputText.count)]
                                    )
                                )
                            }
                            .onAppear {
                                MoveoOne.instance.tick(
                                    moveoOneData: MoveoOneData(
                                        semanticGroup: SEMANTIC_GROUP,
                                        id: "main_input",
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
                                        id: "main_input",
                                        type: .textEdit,
                                        action: .disappear,
                                        value: "Type something...",
                                        metadata: [:]
                                    )
                                )
                            }
                    }
                    .padding(25)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color(red: 0.17, green: 0.42, blue: 0.69).opacity(0.1), radius: 10, y: 4)
                    .frame(width: geometry.size.width * 0.85)
                }
            }
            .background(Color(red: 0.94, green: 0.97, blue: 0.98))
        }
        .onAppear {
            MoveoOne.instance.tick(
                moveoOneData: MoveoOneData(
                    semanticGroup: SEMANTIC_GROUP,
                    id: "main_content_screen",
                    type: .custom,
                    action: .appear,
                    value: "MainContentView",
                    metadata: [:]
                )
            )
        }
        .onDisappear {
            MoveoOne.instance.tick(
                moveoOneData: MoveoOneData(
                    semanticGroup: SEMANTIC_GROUP,
                    id: "main_content_screen",
                    type: .custom,
                    action: .disappear,
                    value: "MainContentView",
                    metadata: [:]
                )
            )
        }
    }
    private func trackParagraphImpression() {
        MoveoOne.instance.tick(moveoOneData: MoveoOneData(
            semanticGroup: SEMANTIC_GROUP,
            id: "intro_paragraph",
            type: .text,
            action: .view,
            value: "demo_description",
            metadata: [
                "screen": "main_screen",
                "interaction_type": "impression",
                "app_version": "1.0",
                "platform": "iOS"
            ]
        ))
    }
    private func handleButtonPress(_ buttonName: String) {
        MoveoOne.instance.track(
            context: SEMANTIC_GROUP,
            moveoOneData: MoveoOneData(
                semanticGroup: SEMANTIC_GROUP,
                id: buttonName == "Button One" ? "button_one" : "button_two",
                type: .button,
                action: .tap,
                value: buttonName,
                metadata: [
                    "source": "main_screen",
                    "button": buttonName
                ]
            )
        )
    }
    private func handleInputSubmit() {
        MoveoOne.instance.track(
            context: SEMANTIC_GROUP,
            moveoOneData: MoveoOneData(
                semanticGroup: SEMANTIC_GROUP,
                id: "main_input",
                type: .textEdit,
                action: .input,
                value: inputText,
                metadata: [
                    "source": "main_screen",
                    "input_length": String(inputText.count)
                ]
            )
        )
    }
}

struct MoveoButtonStyle: ButtonStyle {
    var primary: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(primary ? Color(red: 0.17, green: 0.42, blue: 0.69) : Color(red: 0.26, green: 0.6, blue: 0.88))
            .cornerRadius(12)
            .shadow(color: Color(red: 0.17, green: 0.42, blue: 0.69).opacity(0.2), radius: 4, y: 2)
    }
}

struct MoveoTextFieldStyle: TextFieldStyle {
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

@main
struct SimpleExampleAppApp: App {
    init() {
        MoveoOne.instance.initialize(token: "YOUR_API_KEY")
        MoveoOne.instance.identify(userId: "demo_user_123")
        MoveoOne.instance.setLogging(enabled: true)
        MoveoOne.instance.setFlushInterval(interval: 5)
        // Start session with context
        MoveoOne.instance.start(
            context: "main_screen",
            metadata: ["app_version": "1.0", "platform": "iOS"]
        )
    }
    var body: some Scene {
        WindowGroup {
            MainContentView()
        }
    }
}
