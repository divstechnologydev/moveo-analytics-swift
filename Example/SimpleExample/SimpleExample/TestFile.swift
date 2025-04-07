import SwiftUI
import MoveoOne

struct TestFileView: View {
    let SEMANTIC_GROUP = "test_file_screen"

    var body: some View {
        VStack {
            Text("Test File Content")
                .onAppear {
                    MoveoOne.instance.tick(
                        moveoOneData: MoveoOneData(
                            semanticGroup: SEMANTIC_GROUP,
                            id: "test_file_text",
                            type: .text,
                            action: .view,
                            value: "Test File Content",
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

struct TestFileView_Previews: PreviewProvider {
    static var previews: some View {
        TestFileView()
    }
}