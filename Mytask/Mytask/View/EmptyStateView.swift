//
//  EmptyStateView.swift
//  YourTask
//
//  Created by Vineet Rai on 15-Mar-25.
//

import SwiftUI

struct EmptyStateView: View {
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    @State var isFilterApplied = false

    var body: some View {
        VStack(spacing: 20) {
            // Image with a more engaging icon
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(settingsViewModel.accentColor.color)
                .accessibilityLabel("Empty state icon")
                .accessibilityHint("A checkmark inside a circle, indicating completion or readiness")
            
            // Title
            Text("All Caught Up!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .accessibilityLabel("All caught up")
                .accessibilityHint("Indicates that there are no tasks to display")
            
            // Subtitle
            Text("Add a new task to stay on track!")
                .font(.title2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .accessibilityLabel("Add a new task to stay on track")
                .accessibilityHint("Suggests adding a new task to manage your tasks effectively")
        }
        .padding()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Empty state: All caught up. Add a new task to stay on track.")
        .accessibilityHint("Displays a message indicating no tasks are available and suggests adding a new task")
    }
}
