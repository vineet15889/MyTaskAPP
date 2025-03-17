//
//  TasksHome.swift
//  Mytask
//
//  Created by Vineet Rai on 15-Mar-25.
//

import SwiftUI

struct TasksHome: View {
    @StateObject private var viewModel = TaskListViewModel()
    @StateObject private var progressViewModel = ProgressRingViewModel()
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    @EnvironmentObject private var router: Router // Access Router from the environment
    @State private var isTapped = false // Animation on Add button
    @State private var showingAddTask = false

    var body: some View {
        NavigationStack(path: $router.path) {
            if viewModel.initialFetch {
                ZStack {
                    Color(settingsViewModel.accentColor.color)
                        .edgesIgnoringSafeArea(.all)
                        .accessibilityHidden(true)
                }
            } else {
                ZStack(alignment: .bottomTrailing) {
                    // Main Content
                    VStack {
                        // Large Progress Ring (visible when not in nav bar)
                        if !progressViewModel.isProgressInNavBar, !viewModel.tasks.isEmpty {
                            ProgressRingView(viewModel: viewModel, size:  abs(150 + progressViewModel.dragOffset))
                                .frame(width: 150, height:  abs(150 + progressViewModel.dragOffset))
                                .padding(.top, 20)
                                .offset(y: progressViewModel.dragOffset) // Apply drag offset
                                .offset(x: abs(progressViewModel.dragOffset))
                                .opacity(1 - progressViewModel.dragProgress) // Fade out as drag progresses
                                .accessibilityLabel("Progress Ring")
                                .accessibilityHint("Shows the percentage of completed tasks")
                        }
                        Divider().frame(height: 1)
                            .padding()
                        // Task List
                        TaskListView(viewModel: viewModel)
                            .accessibilityLabel("Task List")
                            .accessibilityHint("Displays all your tasks")
                    }
                    
                    // Floating Action Button (FAB) for Add Task
                    Button(action: {
                        isTapped = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            isTapped = false
                            showingAddTask = true // Trigger sheet presentation after animation
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(settingsViewModel.accentColor.color)
                            .padding()
                            .background(Color(.systemBackground))
                            .clipShape(Circle())
                            .shadow(color: settingsViewModel.accentColor.color, radius: 5)
                            .scaleEffect(isTapped ? 1.3 : 1.0) // Scale up
                            .opacity(isTapped ? 0.5 : 1.0) // Fade
                    }
                    .padding()
                    .accessibilityLabel("Add Task")
                    .accessibilityHint("Tap to create a new task")
                }
                .simultaneousGesture(
                    DragGesture()
                        .onChanged { value in
                            progressViewModel.dragOffsetCalculationOnGestureChange(value: value)
                        }
                        .onEnded { value in
                            progressViewModel.draOnEnd(value: value)
                        }
                )
                .navigationTitle("Task Manager")
                .toolbar {
                    // Progress Ring in Navigation Bar (when moved to nav bar)
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if progressViewModel.isProgressInNavBar, !viewModel.isEmptyState, !viewModel.tasks.isEmpty  {
                            ProgressRingView(viewModel: viewModel, size: 25, ringWidth: 5)
                                .frame(width: 25, height: 25)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        progressViewModel.isProgressInNavBar = false // Move back to main content
                                        progressViewModel.dragOffset = 0
                                        progressViewModel.dragProgress = 0
                                    }
                                }
                                .transition(.opacity) // Smooth transition
                                .accessibilityLabel("Progress Ring")
                                .accessibilityHint("Shows the percentage of completed tasks")
                        }
                    }
                    
                    // Settings Button
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            router.navigate(to: .settings)
                        }) {
                            Image(systemName: "gearshape.fill") // Gear icon for settings
                                .font(.title2)
                                .foregroundColor(settingsViewModel.accentColor.color) // Use accent color
                        }
                        .accessibilityLabel("Settings")
                        .accessibilityHint("Tap to open settings")
                    }
                }
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .addTask:
                        AddTaskView(viewModel: viewModel)
                    case .settings:
                        SettingsView(viewModel: settingsViewModel)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddTask) {
            AddTaskView(viewModel: viewModel)
                .transition(.move(edge: .bottom))
                .animation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0), value: showingAddTask)
        }
    }
}
