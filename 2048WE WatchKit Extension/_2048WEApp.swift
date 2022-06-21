//
//  _2048WEApp.swift
//  2048WE WatchKit Extension
//
//  Created by Trevor Bays on 5/10/22.
//

import SwiftUI
import WatchKit

final class ExtensionDelegate: NSObject, WKExtensionDelegate {
    func applicationWillResignActive() {
        // Saves state of game if app goes out of focus or closes
        DefaultsManager.shared.saveGameState(GameState.shared.currentScore, GameState.shared.currentMoves, GameState.shared.currentBoard)
    }
}

@main
struct _2048WEApp: App {

    @WKExtensionDelegateAdaptor(ExtensionDelegate.self) var delegate

    init() {
        DefaultsManager.shared.initSavedDefaults()
    }

    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
