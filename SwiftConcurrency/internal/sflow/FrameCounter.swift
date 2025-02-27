//
//  FrameCounter.swift
//  SwiftConcurrency
//
//  Created by Callen Egan on 2025-02-11.
//

import QuartzCore

class FrameCounter {
    private let fps: Int
    private let interval: Double
    private var lastRun: Double = 0.0
    
    init(fps: Int) {
        self.fps = fps
        self.interval = 1 / Double(fps)
    }
    
    func run(process: () -> Void) {
        let current = CACurrentMediaTime()
        if ((current - lastRun) > interval) {
            lastRun = current
            process()
        }
    }
}
