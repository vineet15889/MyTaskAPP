//
//  DateFormatter+Extensions.swift
//  YourTask
//
//  Created by Vineet Rai on 15-Mar-25.
//

import Foundation

extension DateFormatter {
    static let taskDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}
