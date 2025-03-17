//
//  ProgressRingView.swift
//  Mytask
//
//  Created by Vineet Rai on 16-Mar-25.
//

import SwiftUI

struct ProgressRingView: View {
    @StateObject var viewModel: TaskListViewModel
    var size: CGFloat = 200 // Default size
    var ringWidth: CGFloat = 20 // Width of the progress ring
    var backgroundColor: Color = .gray.opacity(0.3) // Background color of the ring
    @EnvironmentObject private var settingsViewModel: SettingsViewModel

    var body: some View {
        let completedTasks = CGFloat(viewModel.tasks.filter { $0.completed }.count)
        let totalTasks = CGFloat(viewModel.tasks.count)
        let progress = totalTasks > 0 ? completedTasks / totalTasks : 0

        ZStack {
            // Background Circle
            Circle()
                .stroke(backgroundColor, lineWidth: ringWidth)
                .frame(width: size, height: size)

            // Progress Circle
            Circle()
                .trim(from: 0, to: progress)
                .stroke(settingsViewModel.accentColor.color, style: StrokeStyle(lineWidth: ringWidth, lineCap: .round))
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90)) // Start from the top
                .animation(.easeInOut(duration: 1), value: progress) // Smooth animation

            // Percentage Text (only shown if size is large enough)
            if size > 50 {
                Text("\(Int(progress * 100))%")
                    .font(.system(size: size * 0.2, weight: .bold, design: .rounded))
                    .foregroundColor(settingsViewModel.accentColor.color)
            }
        }
    }
}
