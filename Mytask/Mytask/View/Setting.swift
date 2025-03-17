//
//  Setting.swift
//  Mytask
//
//  Created by Vineet Rai on 15-Mar-25.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        Form {
            Section(header: Text("Accent Color")) {
                ForEach(AccentColor.allCases) { colorOption in
                    Button(action: {
                        viewModel.accentColor = colorOption
                    }) {
                        HStack {
                            Text(colorOption.rawValue.capitalized)
                            Spacer()
                            if viewModel.accentColor == colorOption {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .foregroundColor(.primary)
                    .accessibilityLabel("Accent color: \(colorOption.rawValue.capitalized)")
                    .accessibilityHint("Sets the accent color to \(colorOption.rawValue.capitalized)")
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Accent Color Section")
            .accessibilityHint("Choose an accent color for the app")
        }
        .navigationTitle("Settings")
        .accessibilityLabel("Settings")
        .accessibilityHint("Configure app settings")
    }
}
