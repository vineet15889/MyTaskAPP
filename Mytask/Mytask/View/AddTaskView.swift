//
//  AddTaskView.swift
//  Mytask
//
//  Created by Vineet Rai on 15-Mar-25.
//

import SwiftUI

enum Priority: String, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: TaskListViewModel
    
    @State private var title = ""
    @State private var description = ""
    @State private var priority: Priority = .medium // Use the Priority enum
    @State private var dueDate = Date()
    
    var body: some View {
        NavigationStack {
            Form {
                // Title TextField
                TextField("Title", text: $title)
                    .accessibilityLabel("Task title")
                    .accessibilityHint("Enter the title of the task")
                
                // Description TextField
                TextField("Description", text: $description)
                    .accessibilityLabel("Task description")
                    .accessibilityHint("Enter a description for the task")
                
                // Priority Picker
                Picker("Priority", selection: $priority) {
                    ForEach(Priority.allCases, id: \.self) { priority in
                        Text(priority.rawValue) // Use the rawValue for display
                            .accessibilityLabel("\(priority.rawValue) priority")
                            .accessibilityHint("Sets the task priority to \(priority.rawValue.lowercased())")
                    }
                }
                .accessibilityLabel("Task priority")
                .accessibilityHint("Select the priority level for the task")
                
                // Due Date Picker
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                    .accessibilityLabel("Task due date")
                    .accessibilityHint("Select the due date for the task")
            }
            .navigationTitle("New Task")
            .accessibilityLabel("New Task Form")
            .accessibilityHint("Add a new task with title, description, priority, and due date")
            .toolbar {
                // Cancel Button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss() // Dismiss the sheet
                    }
                    .accessibilityLabel("Cancel")
                    .accessibilityHint("Discard changes and return to the task list")
                }
                
                // Save Button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.addTask(
                            title: title,
                            description: description,
                            priority: priority.rawValue, // Pass the rawValue to the ViewModel
                            dueDate: dueDate
                        )
                        dismiss() // Dismiss the sheet after saving
                    }
                    .disabled(title.isEmpty) // Disable save button if title is empty
                    .accessibilityLabel("Save task")
                    .accessibilityHint("Saves the new task and returns to the task list")
                }
            }
        }
    }
}
