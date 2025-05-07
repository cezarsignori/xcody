import SwiftUI

struct CodeBlockView: View {
    let code: String
    let language: String

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            Text(code)
                .font(.system(.body, design: .monospaced))
                .padding()
                .cornerRadius(8)
        }
        .overlay(
            Text(language)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(.systemGray))
                .cornerRadius(4)
                .padding(4),
            alignment: .topTrailing
        )
    }
}
