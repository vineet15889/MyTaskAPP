//
//  TaskManager.swift
//  Mytask
//
//  Created by Vineet Rai on 15-Mar-25.
//

import CoreData
import Foundation

class TaskManager: ObservableObject {
    static let shared = TaskManager()
    
    private let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "Mytask")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext(completion: @escaping () -> Void) {
        if context.hasChanges {
            do {
                try context.save()
                completion()
            } catch {
                print("Error saving context: \(error.localizedDescription)")
            }
        }
    }
    
    func createTask(title: String, description: String?, priority: Int, dueDate: Date, completion: @escaping (_ task: TaskItem) -> Void) {
        let newTask = TaskItem(context: context)
        newTask.id = UUID()
        newTask.title = title
        newTask.taskDescription = description
        newTask.priority = Int16(priority)
        newTask.dueDate = dueDate
        newTask.completed = false
        let currentTasks = fetchTasks(filter: nil, sort: nil, offset: 0, limit: .max)
        let highestOrder = (currentTasks.max(by: { $0.order < $1.order })?.order ?? -1) + 1
        newTask.order = highestOrder
        saveContext(completion: {
            completion(newTask)
        })
    }
    
    func fetchTasks(filter: TaskListViewModel.FilterOption?, sort: TaskListViewModel.SortOption?, offset: Int, limit: Int) -> [TaskItem] {
        let request: NSFetchRequest<TaskItem> = TaskItem.fetchRequest()
        
        var predicates: [NSPredicate] = []

        // Apply filtering
        if let filterOption = filter {
            switch filterOption {
            case .completed:
                predicates.append(NSPredicate(format: "completed == %@", NSNumber(value: true)))
            case .pending:
                predicates.append(NSPredicate(format: "completed == %@", NSNumber(value: false)))
            case .all:
                print("no predicates")
            }
        }
        
        if !predicates.isEmpty {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }

        // Apply sorting
        if let sortOption = sort {
            let sortDescriptor: NSSortDescriptor
            switch sortOption {
            case .dueDate:
                sortDescriptor = NSSortDescriptor(key: "dueDate", ascending: false)
            case .priority:
                sortDescriptor = NSSortDescriptor(key: "priority", ascending: false)
            case .title:
                sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
            }
            request.sortDescriptors = [sortDescriptor]
        } else {
            request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: false)]
        }

        request.fetchOffset = offset
        request.fetchLimit = limit

        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching tasks: \(error.localizedDescription)")
            return []
        }
    }
    
    func deleteTask(_ task: TaskItem) {
        context.delete(task)
        saveContext(completion: {})
    }
    
    func toggleTaskCompletion(_ task: inout TaskItem) {
        task.completed.toggle()
        saveContext(completion: {})
    }
}
