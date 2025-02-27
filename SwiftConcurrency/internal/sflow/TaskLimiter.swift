//
//  TaskLimiter.swift
//  SwiftConcurrency
//
//  Created by Callen Egan on 2025-02-11.
//

actor TaskLimiter {
    private var runningTasks: Int = 0
    private let maxConcurrentTasks: Int

    init(maxConcurrentTasks: Int) {
        self.maxConcurrentTasks = maxConcurrentTasks
    }

    func tryStartTask() -> Bool {
        if runningTasks < maxConcurrentTasks {
            runningTasks += 1
            return true
        } else {
            return false
        }
    }

    func endTask() {
        runningTasks -= 1
    }
}
