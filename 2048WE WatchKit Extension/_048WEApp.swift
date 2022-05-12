//
//  _048WEApp.swift
//  2048WE WatchKit Extension
//
//  Created by Trevor Bays on 5/10/22.
//

import SwiftUI
import WatchKit

final class ExtensionDelegate: NSObject, WKExtensionDelegate {
    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
        DefaultsManager.shared.saveGameState(GameState.shared.currentScore, GameState.shared.currentMoves, GameState.shared.currentBoard)
    }
}

@main
struct _048WEApp: App {

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
