import SwiftUI
import MoveoOneLibrary

struct TestView: View {
    let SEMANTIC_GROUP = "test_screen"

    var body: some View {
        VStack {
            Text("Test Screen")
                .font(.largeTitle)
                .padding()
                .onAppear {
                    MoveoOne.instance.tick(
                        moveoOneData: MoveoOneData(
                            semanticGroup: SEMANTIC_GROUP,
                            id: "test_screen_text",
                            type: .text,
                            action: .view,
                            value: "Test Screen",
                            metadata: [:]
                        )
                    )
                }
        }
        .onAppear {
            MoveoOne.instance.tick(
                moveoOneData: MoveoOneData(
                    semanticGroup: SEMANTIC_GROUP,
                    id: "test_screen",
                    type: .screen,
                    action: .appear,
                    value: "Test Screen",
                    metadata: [:]
                )
            )
        }
        .onDisappear {
            MoveoOne.instance.tick(
                moveoOneData: MoveoOneData(
                    semanticGroup: SEMANTIC_GROUP,
                    id: "test_screen",
                    type: .screen,
                    action: .disappear,
                    value: "Test Screen",
                    metadata: [:]
                )
            )
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}