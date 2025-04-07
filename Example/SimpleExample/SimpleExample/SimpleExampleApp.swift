import SwiftUI

struct MainContentView: View {
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
                    
                    // Content Container
                    VStack {
                        Text("This is a generic SwiftUI app made for demo purposes.")
                            .font(.system(size: 16))
                            .foregroundColor(Color(red: 0.29, green: 0.33, blue: 0.41))
                            .lineSpacing(6)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 30)
                            .onAppear {
                                trackParagraphImpression()
                            }
                        
                        // Buttons
                        VStack(spacing: 16) {
                            Button("Button One") {
                                // Set state to trigger navigation to second screen
                                navigateToSecondScreen = true
                            }
                            .buttonStyle(PrimaryButtonStyle())
                            
                            Button("Button Two") {
                                handleButtonPress("Button Two")
                            }
                            .buttonStyle(SecondaryButtonStyle())
                        }
                        .padding(.bottom, 20)
                        
                        // Text Field
                        TextField("Type something...", text: $inputText)
                            .textFieldStyle(GenericTextFieldStyle())
                            .onSubmit {
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

@main
struct GenericApp: App {
    var body: some Scene {
        WindowGroup {
            MainContentView()
        }
    }
}
