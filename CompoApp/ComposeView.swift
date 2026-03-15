//
//  ComposeView.swift
//  CompoApp
//
//  Created by GH w on 3/15/26.
//

import SwiftUI

struct ComposeView: View {
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    VStack(spacing: 20) {
      Text("✍️ Compose")
        .font(.largeTitle)

      TextEditor(text: .constant("Write something..."))
        .border(Color.gray, width: 1)
        .frame(height: 200)

      Button("Done") {
        dismiss()
      }
      .buttonStyle(.borderedProminent)

      Spacer()
    }
    .padding()
    .navigationTitle("Compose")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        Button("Cancel") {
          dismiss()
        }
      }
    }
  }
}

#Preview {
    ComposeView()
}
