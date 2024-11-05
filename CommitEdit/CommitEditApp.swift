//
//  CommitEditApp.swift
//  CommitEdit
//
//  Created by kramo on 04-11-2024.
//

import SwiftUI

@main
struct CommitEditApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var fileHandler = FileHandler()

    var body: some Scene {
        WindowGroup {
            ContentView(showWelcomeView: $fileHandler.showWelcomeView,
                        text: $fileHandler.text,
                        onCommit: {
                            fileHandler.saveFile()
                            exit(0)
                        }
            )
            .onAppear {
                NSWindow.allowsAutomaticWindowTabbing = false

                for window in NSApplication.shared.windows {
                    window.standardWindowButton(.zoomButton)?.isEnabled = false
                }

                // Start with the editor view and add a slight delay so the welcome view doesn't flash before a file is opened
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    if !fileHandler.fileOpened {
                        fileHandler.showWelcomeView = true
                    }
                }
            }
            .onOpenURL { url in
                fileHandler.loadFile(from: url)
            }
            .gesture(WindowDragGesture())
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .windowResizability(.contentSize)
        .windowLevel(.floating)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}


class FileHandler: ObservableObject {
    @Published var showWelcomeView: Bool = false
    @Published var fileOpened: Bool = false
    @Published var text: String = ""
    private var fileURL: URL?

    func loadFile(from url: URL) {
        self.showWelcomeView = false
        self.fileOpened = true
        self.fileURL = url
        do {
            let fileContents = try String(contentsOf: url, encoding: .utf8)
            self.text = fileContents
        } catch {}
    }

    func saveFile() {
        guard let fileURL = fileURL else { return }
        do {
            try text.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {}
    }
}
