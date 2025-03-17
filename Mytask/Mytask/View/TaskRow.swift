//
//  TaskRow.swift
//  YourTask
//
//  Created by Vineet Rai on 15-Mar-25.
//

import SwiftUI

struct TaskRow: View {
    @ObservedObject var task: TaskItem
    @EnvironmentObject private var settingsViewModel: SettingsViewModel

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                // Task Title
                Text(task.title ?? "Untitled")
                    .font(.headline)
                    .accessibilityLabel("Task title: \(task.title ?? "Untitled")")
                    .accessibilityHint("Displays the title of the task")
                
                // Task Due Date
                Text("Due: \(task.dueDate ?? Date(), formatter: DateFormatter.taskDateFormatter)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .accessibilityLabel("Task due date: \(task.dueDate ?? Date(), formatter: DateFormatter.taskDateFormatter)")
                    .accessibilityHint("Displays the due date of the task")
                
                // Task Priority
                Text("Priority: \(task.priority ?? "Unknown")")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .accessibilityLabel("Task priority: \(task.priority ?? "Unknown")")
                    .accessibilityHint("Displays the priority level of the task")
            }
            Spacer()
            
            // Task Completion Indicator
            if task.completed {
                Image(systemName: "checkmark.circle.fill")
                    .renderingMode(.template)
                    .foregroundColor(settingsViewModel.accentColor.color)
                    .accessibilityLabel("Task completed")
                    .accessibilityHint("Indicates that the task is completed")
            }
        }
        .padding()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Task: \(task.title ?? "Untitled"), due \(task.dueDate ?? Date(), formatter: DateFormatter.taskDateFormatter), priority \(task.priority ?? "Unknown")")
        .accessibilityHint(task.completed ? "Task is completed" : "Task is pending")
    }
}
