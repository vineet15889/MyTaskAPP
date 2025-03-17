//
//  MytaskApp.swift
//  Mytask
//
//  Created by Vineet Rai on 15-Mar-25.
//

import SwiftUI

@main
struct MytaskApp: App {
    @StateObject private var settingsViewModel = SettingsViewModel()
    @StateObject private var router = Router()

    var body: some Scene {
        WindowGroup {
            TasksHome()
                .tint(settingsViewModel.accentColor.color) // Apply accent color globally
                .environmentObject(settingsViewModel) // Make SettingsViewModel available globa
                .environmentObject(router)
        }
    }
}
