//
//  TaskViewModel.swift
//  Mytask
//
//  Created by Vineet Rai on 15-Mar-25.
//

import Foundation
import CoreData
import SwiftUI

class TaskListViewModel: ObservableObject {
    @Published var tasks: [TaskItem] = []
    @Published var selectedSortOption: SortOption? = nil
    @Published var selectedFilterOption: FilterOption? = nil
    @Published var recentlyDeletedTask = [Int :TaskItem]()
    @Published var isEmptyState: Bool = false
    @Published var isFetchingTasks: Bool = false
    @Published var showDeleteAlert = false
    @Published var showProgressBar = false
    
    @Published var canLoadMore: Bool = true // Indicates if more tasks can be loaded
    @Published var initialFetch: Bool = true
    private let taskManager = TaskManager.shared // Coredata CRUD
    private var currentOffset: Int = 0
    private let batchSize: Int = 10
    
    init() {
        fetchTasks()
    }

    // Fetch and apply filtering/sorting with pagination
    func fetchTasks(reset: Bool = false) {
        if reset {
            currentOffset = 0
            canLoadMore = true
        }
        guard canLoadMore, !isFetchingTasks else { return }
        isFetchingTasks = true
        if reset { tasks.removeAll() }
        let newTasks = taskManager.fetchTasks(filter: selectedFilterOption, sort: selectedSortOption, offset: currentOffset, limit: batchSize)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // To Dsplay simmer
            self.tasks.append(contentsOf: newTasks)
            self.updateEmptyView()
            self.isFetchingTasks = false
            self.initialFetch = false
            self.canLoadMore = newTasks.count == self.batchSize // Can load more if batch size is met
        }

        if !newTasks.isEmpty {
            currentOffset += batchSize
        }
    }

    // MARK: - Filter & Sort Functions
    
    func updateEmptyView() {
        return self.isEmptyState = self.tasks.isEmpty && selectedSortOption == nil && selectedFilterOption == nil && !showDeleteAlert && !isFetchingTasks
    }

    func setFilterOption(_ option: FilterOption?) {
        selectedFilterOption = selectedFilterOption != option || selectedFilterOption != .all ? option : nil
        updateEmptyView()
        fetchTasks(reset: true)
    }

    func setSortOption(_ option: SortOption?) {
        selectedSortOption = selectedSortOption != option ? option : nil
        updateEmptyView()
        fetchTasks(reset: true)
    }

    func clearFiltersAndSorts() {
        selectedFilterOption = nil
        selectedSortOption = nil
        fetchTasks(reset: true)
        updateEmptyView()
    }

    // MARK: - Task Management Functions

    func addTask(title: String, description: String?, priority: String, dueDate: Date) {
        taskManager.createTask(title: title, description: description, priority: priority, dueDate: dueDate, completion: { newTask in
            self.tasks.insert(newTask, at: 0)
            self.updateEmptyView()
        })
    }

    func deleteTaskWithUndo(_ task: TaskItem) {
        recentlyDeletedTask[getIndex(task)] = task
        tasks.removeAll { $0.id == task.id }
        DispatchQueue.main.async {
               self.showDeleteAlert = true
           }
        updateEmptyView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if self.showDeleteAlert {
                self.permanentlyDeleteTask(task)
                self.showDeleteAlert = false
            }
        }
    }

    func undoDelete() {
        DispatchQueue.main.async { [self] in
            if let index = recentlyDeletedTask.keys.first, let task = recentlyDeletedTask[index] {
                if tasks.count > index {
                    withAnimation {
                        tasks.insert(task, at: index)
                    }
                } else {
                    tasks.append(task)
                }
                updateEmptyView()
            }
            recentlyDeletedTask = [:]
        }
    }

    func permanentlyDeleteTask(_ task: TaskItem?) {
        guard let task else { return }
        deleteTask(task)
        fetchTasks()
    }
    
    func permanentlyDeleteTask(_ taskWithIndex: [Int :TaskItem]?) {
        if let index = recentlyDeletedTask.keys.first, let task = recentlyDeletedTask[index] {
            deleteTask(task)
        }
    }

    func deleteTask(_ task: TaskItem) {
        taskManager.deleteTask(task)
    }

    func toggleTaskCompletion(_ task: TaskItem) {
        taskManager.toggleTaskCompletion(&tasks[getIndex(task)])
    }

    func getIndex(_ task: TaskItem) -> Int {
        return tasks.firstIndex(where: {$0.id == task.id}) ?? 0
    }

    func moveTask(from source: IndexSet, to destination: Int) {
        tasks.move(fromOffsets: source, toOffset: destination)
        for (index, task) in tasks.enumerated() {
            task.order = Int64(tasks.count - index)
        }
        taskManager.saveContext(completion: {})

        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()

        fetchTasks(reset: true)
    }
}

// MARK: - Filter & Sort Enums

extension TaskListViewModel {
    enum FilterOption: String, CaseIterable, Identifiable {
        case all = "All"
        case completed = "Completed"
        case pending = "Pending"
        var id: String { self.rawValue }
    }

    enum SortOption: String, CaseIterable, Identifiable {
        case dueDate = "Due Date"
        case priority = "Priority"
        case title = "Title"
        var id: String { self.rawValue }
    }
}
