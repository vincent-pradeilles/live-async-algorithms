//
//  TaskCancellable.swift
//  LiveAsyncAlgorithms
//
//  Created by Vincent on 16/07/2022.
//

import Foundation

// Disclaimer: this code hasn't been battle-tested.
// Exercise caution if you want to use it in production code.

final class TaskCancellable: Hashable {
    static func == (lhs: TaskCancellable, rhs: TaskCancellable) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }

    private var id = UUID()
    private let cancelTask: () -> Void

    init<Success, Failure>(task: Task<Success, Failure>) {
        cancelTask = {
            task.cancel()
        }
    }

    deinit {
        cancelTask()
    }
}

extension Task {
    func store(in cancellables: inout Set<TaskCancellable>) {
        cancellables.insert(TaskCancellable(task: self))
    }
}
