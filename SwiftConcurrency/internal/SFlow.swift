//
//  CaptureView.swift
//  SwiftConcurrency
//
//  Created by Callen Egan on 2025-02-12.
//

import Foundation
import Combine

class SFlow<T> {
    private let subject = PassthroughSubject<T, Never>()
    private var cancellable: AnyCancellable? = nil
    private let taskLimiter: TaskLimiter
    private let fpsControl: FrameCounter
    
    init(fps: Int = 4) {
        taskLimiter = TaskLimiter(maxConcurrentTasks: fps)
        fpsControl = FrameCounter(fps: fps)
    }
    
    func register(_ run : @Sendable @escaping (T) async -> Void) {
        complete()
        
        let stream = AsyncStream { continuation in
            self.cancellable = self.subject.sink { value in
                continuation.yield(value)
            }
        }
        Task {
            for await item in stream {
                if await self.taskLimiter.tryStartTask() {
                    Task {
                        await run(item)
                        await self.taskLimiter.endTask()
                    }
                }
            }
        }
    }
    
    func emit(_ value: T) {
        guard isActive else { return }
        
        fpsControl.run {
            subject.send(value)
        }
    }

    func complete() {
        if (isActive) {
            cancellable?.cancel()
            cancellable = nil
        }
    }
    
    var isActive: Bool {
        return cancellable != nil
    }
}
