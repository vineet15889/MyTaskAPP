//
//  ClearFilterView.swift
//  Mytask
//
//  Created by Vineet Rai on 16-Mar-25.
//

import SwiftUI

struct ClearFilterView: View {
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    var onClearFilters: () -> Void // Callback to clear filters

    var body: some View {
        VStack(spacing: 16) { // Reduced spacing for a more compact layout
            // Image with a filter icon
            Image(systemName: "line.horizontal.3.decrease.circle.fill")
                .font(.system(size: 60)) // Smaller icon size
                .foregroundColor(settingsViewModel.accentColor.color)
                .accessibilityLabel("Filter icon")
                .accessibilityHint("A filter icon indicating that filters are applied")
            
            // Title
            Text("All Caught Up!")
                .font(.title) // Smaller font size
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .accessibilityLabel("Filters applied")
                .accessibilityHint("Indicates that filters are currently applied to the task list")
            
            // Subtitle
            Text("Clear filters to see all tasks.")
                .font(.subheadline) // Smaller font size
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .accessibilityLabel("Clear filters to see all tasks")
                .accessibilityHint("Suggests clearing filters to view all tasks")
            
            // Clear Filters Button
            Button(action: {
                onClearFilters() // Call the callback to clear filters
            }) {
                Text("Clear Filters")
                    .font(.headline) // Smaller font size
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical, 12) // Smaller vertical padding
                    .padding(.horizontal, 24) // Smaller horizontal padding
                    .background(settingsViewModel.accentColor.color)
                    .cornerRadius(8) // Smaller corner radius
                    .shadow(color: settingsViewModel.accentColor.color.opacity(0.3), radius: 4, x: 0, y: 4) // Softer shadow
            }
            .accessibilityLabel("Clear filters button")
            .accessibilityHint("Tap to clear all applied filters")
        }
        .padding(24) // Reduced padding for a more compact layout
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Clear filters view: Filters are applied. Tap to clear filters.")
        .accessibilityHint("Displays a message indicating filters are applied and provides an option to clear them")
    }
}
