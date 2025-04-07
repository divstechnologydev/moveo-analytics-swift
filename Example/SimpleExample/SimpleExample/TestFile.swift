import SwiftUI
import MoveoOne

struct TestFile: View {
    let SEMANTIC_GROUP = "test_file"

    var body: some View {
        VStack {
            Text("Welcome to Test File")
                .font(.title)
                .padding()
                .onAppear {
                    MoveoOne.instance.tick(
                        moveoOneData: MoveoOneData(
                            semanticGroup: SEMANTIC_GROUP,
                            id: "test_file_text",
                            type: .text,
                            action: .view,
                            value: "Welcome to Test File",
                            metadata: [:]
                        )
                    )
                }
            Button("Click Me") {
                MoveoOne.instance.tick(
                    moveoOneData: MoveoOneData(
                        semanticGroup: SEMANTIC_GROUP,
                        id: "test_file_button",
                        type: .button,
                        action: .click,
                        value: "Click Me",
                        metadata: [:]
                    )
                )
            }
        }
        .onAppear {
            MoveoOne.instance.tick(
                moveoOneData: MoveoOneData(
                    semanticGroup: SEMANTIC_GROUP,
                    id: "test_file_screen",
                    type: .screen,
                    action: .appear,
                    value: "Test File Screen",
                    metadata: [:]
                )
            )
        }
        .onDisappear {
            MoveoOne.instance.tick(
                moveoOneData: MoveoOneData(
                    semanticGroup: SEMANTIC_GROUP,
                    id: "test_file_screen",
                    type: .screen,
                    action: .disappear,
                    value: "Test File Screen",
                    metadata: [:]
                )
            )
        }
    }
}

struct TestFile_Previews: PreviewProvider {
    static var previews: some View {
        TestFile()
    }
}