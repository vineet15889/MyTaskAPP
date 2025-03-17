//
//  TaskListView.swift
//  Mytask
//
//  Created by Vineet Rai on 15-Mar-25.
//

import SwiftUI

struct TaskListView: View {
    @ObservedObject var viewModel: TaskListViewModel
    @EnvironmentObject private var settingsViewModel: SettingsViewModel

    var body: some View {
        ZStack {
            VStack {
                // Top Bar with Icons
                if !viewModel.isEmptyState {
                    HStack {
                        // Filter Icon (Left)
                        Menu {
                            ForEach(TaskListViewModel.FilterOption.allCases) { option in
                                Button(action: {
                                    viewModel.setFilterOption(option)
                                }) {
                                    HStack {
                                        Text(option.rawValue)
                                        if viewModel.selectedFilterOption == option {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                    .foregroundColor(settingsViewModel.accentColor.color)
                                }
                                .accessibilityLabel("Filter by \(option.rawValue)")
                                .accessibilityHint("Filters tasks by \(option.rawValue)")
                            }
                        } label: {
                            Image(systemName: "line.horizontal.3.decrease.circle")
                                .font(.title2)
                                .foregroundColor(settingsViewModel.accentColor.color)
                                .accessibilityLabel("Filter tasks")
                                .accessibilityHint("Opens filter menu")
                        }
                        
                        Spacer()
                        
                        // Sort Icon (Right)
                        Menu {
                            ForEach(TaskListViewModel.SortOption.allCases) { option in
                                Button(action: {
                                    viewModel.setSortOption(option)
                                }) {
                                    HStack {
                                        Text(option.rawValue)
                                        if viewModel.selectedSortOption == option {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                    .foregroundColor(settingsViewModel.accentColor.color)
                                }
                                .accessibilityLabel("Sort by \(option.rawValue)")
                                .accessibilityHint("Sorts tasks by \(option.rawValue)")
                            }
                        } label: {
                            Image(systemName: "arrow.up.arrow.down.circle")
                                .font(.title2)
                                .foregroundColor(settingsViewModel.accentColor.color)
                                .accessibilityLabel("Sort tasks")
                                .accessibilityHint("Opens sorting menu")
                        }
                    }
                    .padding(.horizontal)
                }
                VStack {
                    if viewModel.isEmptyState, !viewModel.showDeleteAlert, !viewModel.isFetchingTasks {
                        Spacer()
                        EmptyStateView(isFilterApplied: viewModel.isEmptyState)
                            .accessibilityLabel("No tasks available")
                            .accessibilityHint("Add a task using the plus button")
                        Spacer().frame(height: 100)
                    } else if viewModel.tasks.isEmpty, !viewModel.showDeleteAlert, !viewModel.isFetchingTasks {
                        Spacer()
                        ClearFilterView(onClearFilters: {
                            viewModel.clearFiltersAndSorts()
                        })
                        .accessibilityLabel("No tasks available")
                        .accessibilityHint("Clear Filter to load other data using the clear button")
                        Spacer().frame(height: 100)
                    } else {
                        List {
                            ForEach(viewModel.tasks) { task in
                                NavigationLink(destination: TaskDetailView(task: task, viewModel: viewModel)) {
                                    TaskRow(task: task)
                                        .accessibilityElement(children: .combine)
                                        .accessibilityLabel("\(task.title ?? "Unnamed task"), due \(formattedDate(task.dueDate))")
                                        .accessibilityHint(task.completed ? "Task is completed" : "Task is pending")
                                }
                                .transition(.scale.combined(with: .opacity))
                                .animation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.5), value: viewModel.tasks)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        viewModel.deleteTaskWithUndo(task)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    .tint(.red)
                                    .accessibilityLabel("Delete task")
                                    .accessibilityHint("Deletes the task permanently")
                                }
                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    Button {
                                        withAnimation {
                                            viewModel.toggleTaskCompletion(task)
                                        }
                                    } label: {
                                        Label(task.completed ? "Mark Incomplete" : "Mark Complete",
                                              systemImage: task.completed ? "xmark.circle" : "checkmark.circle")
                                    }
                                    .tint(task.completed ? .gray : .green)
                                    .accessibilityLabel(task.completed ? "Mark task as incomplete" : "Mark task as complete")
                                    .accessibilityHint(task.completed ? "Marks the task as incomplete" : "Marks the task as complete")
                                }
                            }
                            .onMove(perform: viewModel.moveTask)
                            if viewModel.canLoadMore {
                                TaskRowPlaceholder()
                                    .shimmer() // Apply shimmer effect
                                    .onAppear {
                                        getMoreData()
                                    }
                            }
                        }
                        .listStyle(PlainListStyle())
                        .accessibilityLabel("Task list")
                        .accessibilityHint("Displays all your tasks")
                    }
                    Spacer()
                }
                
            }
        }
        .alert("Task Deleted", isPresented: $viewModel.showDeleteAlert) {
            // Alert Buttons
            Button("Undo", role: .cancel) {
                viewModel.undoDelete() // Undo the deletion
            }
            Button("Delete", role: .destructive) {
                viewModel.permanentlyDeleteTask(viewModel.recentlyDeletedTask) // Permanently delete the task
            }
        } message: {
            Text("The task has been deleted. You can undo this action or permanently delete it.")
        }
    }

    func getMoreData() {
        viewModel.fetchTasks()
    }

    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "No due date" }
        return DateFormatter.taskDateFormatter.string(from: date)
    }
}
