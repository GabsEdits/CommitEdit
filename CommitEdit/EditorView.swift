//
//  EditorView.swift
//  CommitEdit
//
//  Created by kramo on 07-11-2024.
//


import SwiftUI

struct EditorView: View {
    @Binding var text: String
    let onCommit: () -> Void

    let messageLength = 72.0
    let horizontalPadding = 20.0
    let fontSize = NSFont.systemFontSize + 1

    var body: some View {
        ZStack {
            Color.primary.opacity(0.08)
                .offset(
                    CGSize(
                        width: (" ".size(
                            withAttributes: [
                                .font: NSFont.monospacedSystemFont(
                                    ofSize: fontSize,
                                    weight: .regular
                                )
                            ]
                        ).width * (messageLength + 0.5)) + horizontalPadding,
                        height: 0
                    )
                )
            VStack {
                TextEditor(text: $text)
                    .padding(.top, -5)
                    .font(
                        .system(
                            size: fontSize,
                            weight: .regular,
                            design: .monospaced
                        )
                    )
                    .foregroundStyle(.foreground.opacity(0.9))
                    .lineSpacing(3)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, horizontalPadding)
                    .onSubmit {
                        onCommit()
                    }
                HStack {
                    Spacer()
                    HStack {
                        Button("Abort") {
                            text = ""
                            onCommit()
                        }
                        Button(
                            "Commit",
                            systemImage:
                                "point.topright.arrow.triangle.backward.to.point.bottomleft.scurvepath.fill",
                            action: onCommit
                        )
                        .keyboardShortcut("s")
                        .keyboardShortcut(.init("⏎"), modifiers: [.command])
                        .buttonStyle(.borderedProminent)
                        .labelStyle(.titleAndIcon)
                    }
                    .padding(.horizontal, 8)
                    .padding(.bottom, 8)
                }
                .controlSize(.large)
            }
        }
        .containerBackground(.ultraThickMaterial, for: .window)
        .ignoresSafeArea(.all)
    }
}

#Preview {
    @Previewable @State var text = ""

    EditorView(text: $text, onCommit: {})
}
