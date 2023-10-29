//
//  Task.swift
//

import UIKit

// The Task model
struct Task: Codable {

    // The task's title
    var title: String

    // An optional note
    var note: String?

    // The due date by which the task should be completed
    var dueDate: Date

    // Initialize a new task
    // `note` and `dueDate` properties have default values provided if none are passed into the init by the caller.
    init(title: String, note: String? = nil, dueDate: Date = Date()) {
        self.title = title
        self.note = note
        self.dueDate = dueDate
    }

    // A boolean to determine if the task has been completed. Defaults to `false`
    var isComplete: Bool = false {

        // Any time a task is completed, update the completedDate accordingly.
        didSet {
            if isComplete {
                // The task has just been marked complete, set the completed date to "right now".
                completedDate = Date()
            } else {
                completedDate = nil
            }
        }
    }

    // The date the task was completed
    // private(set) means this property can only be set from within this struct, but read from anywhere (i.e. public)
    private(set) var completedDate: Date?

    // The date the task was created
    // This property is set as the current date whenever the task is initially created.
    var createdDate: Date = Date()

    // An id (Universal Unique Identifier) used to identify a task.
    var id: String = UUID().uuidString
}

// MARK: - Task + UserDefaults
extension Task {

    /* Note that some of the methods are type methods (marked static) which are methods associated with the type (in this case, Task) and allow for the method tobe accessed from anywhere in the app (i.e. Task.save(tasks)) but are not associated with a particular Task instance. In contrast, other methods are instancemethods which are associated with a particular task instance and use the task instance they are called on in some way. For instance, calling task.save() shouldsave (or update) the particular task it's being called on. */

    // Given an array of tasks, encodes them to data and saves to UserDefaults.
    static func save(_ tasks: [Task]) {
        // TODO: Save the array of tasks
        // Encode the array of tasks to data using a JSONEncoder instance.
        let defaults = UserDefaults.standard
        // Save the encoded tasks data to UserDefaults with a key.
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(tasks) {
            defaults.set(data, forKey: "Your Task")
        }
        
    }

    // Retrieve an array of saved tasks from UserDefaults.
    static func getTasks() -> [Task] {
        // TODO: Get the array of saved tasks from UserDefaults
        let defaults = UserDefaults.standard
        let decoder = JSONDecoder()
        // Get the saved task data for the key used to store tasks.
        guard let data = defaults.data(forKey: "Your Task") else { return [] }
        // Decode the tasks data into an array of Task objects (i.e. [Task]) using a JSONDecoder instance.
        let tasks = try? decoder.decode([Task].self, from: data)
        // If the decode failed, return an empty array.
        return tasks ?? []
    }

    // Add a new task or update an existing task with the current task.
    func save() {
        // TODO: Save the current task
        var tasks = Task.getTasks()
        // get the current task id
        let currentTaskID = self.id
        
        // Find the first index where a matching ID is found in the tasks array.
        var existingTaskIndex: Int? =  nil
        for (index, task) in tasks.enumerated() {
            if currentTaskID == task.id {
                existingTaskIndex = index
                break
            }
        }
        
        // Remove the existing task from the array
        if let existingTaskIndex = existingTaskIndex {
            tasks.remove(at: existingTaskIndex)
            tasks.insert(self, at: existingTaskIndex)
        }
        else { tasks.append(self) }
        
        // Save the updated tasks array to UserDefaults
        Task.save(tasks)
        
    }
}
