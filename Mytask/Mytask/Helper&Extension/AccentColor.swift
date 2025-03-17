//
//  AccentColor.swift
//  Mytask
//
//  Created by Vineet Rai on 15-Mar-25.
//

import SwiftUI

enum AccentColor: String, CaseIterable, Identifiable {
    case blue
    case green
    case orange
    case purple
    case red
    
    var id: String { self.rawValue }
    
    var color: Color {
        switch self {
        case .blue: return .blue
        case .green: return .green
        case .orange: return .orange
        case .purple: return .purple
        case .red: return .red
        }
    }
}
