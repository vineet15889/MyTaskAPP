//
//  SettingsViewModel.swift
//  Mytask
//
//  Created by Vineet Rai on 15-Mar-25.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    @AppStorage("accentColor") var accentColor: AccentColor = .blue
}
