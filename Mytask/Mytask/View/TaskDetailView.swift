//
//  TaskDetailView.swift
//  Mytask
//
//  Created by Vineet Rai on 15-Mar-25.
//

import SwiftUI

struct TaskDetailView: View {
    let task: TaskItem
    @ObservedObject var viewModel: TaskListViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            // Task Title
            Text(task.title ?? "Untitled")
                .font(.headline)
                .accessibilityLabel("Task title: \(task.title ?? "Untitled")")
                .accessibilityHint("Displays the title of the task")
            
            // Task Description
            Text(task.taskDescription ?? "No description provided")
                .font(.subheadline)
                .accessibilityLabel("Task description: \(task.taskDescription ?? "No description provided")")
                .accessibilityHint("Displays the description of the task")
            
            // Task Priority
            Text("Priority: \(task.priority ?? "Unknown")")
                .accessibilityLabel("Task priority: \(task.priority ?? "Unknown")")
                .accessibilityHint("Displays the priority level of the task")
            
            // Task Due Date
            Text("Due Date: \(task.dueDate ?? Date(), formatter: DateFormatter.taskDateFormatter)")
                .accessibilityLabel("Task due date: \(task.dueDate ?? Date(), formatter: DateFormatter.taskDateFormatter)")
                .accessibilityHint("Displays the due date of the task")
            
            // Task Completion Toggle
            Toggle("Completed", isOn: Binding(
                get: { task.completed },
                set: { newValue in
                    viewModel.toggleTaskCompletion(task)
                }
            ))
            .accessibilityLabel("Task completion status")
            .accessibilityHint("Toggles the task as completed or incomplete")
        }
        .navigationTitle("Task Details")
        .accessibilityLabel("Task Details")
        .accessibilityHint("Displays detailed information about the task")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Delete") {
                    viewModel.deleteTask(task)
                    dismiss()
                }
                .foregroundColor(.red)
                .accessibilityLabel("Delete task")
                .accessibilityHint("Deletes the task permanently")
            }
        }
    }
}
