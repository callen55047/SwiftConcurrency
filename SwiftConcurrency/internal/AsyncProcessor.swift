//
//  CaptureView.swift
//  SwiftConcurrency
//
//  Created by Callen Egan on 2025-02-12.
//

import Foundation
import SwiftUI

class AsyncProcessor: IAsyncProcessor {
    private let imageFeed = SFlow<ImagePackage>()
    private var currentImage: ImagePackage? = nil
    private let analyzer = FrameAnalyzer()
    
    func start(delegate: IProcessorDelegate) {
        imageFeed.register { image in
            let feedback = await self.processFrame(image: image)
            
            // joins background tasks into main thread
            DispatchQueue.main.async {
                guard self.imageFeed.isActive else {
                    return
                }
                
                if (!feedback.isEmpty()) {
                    delegate.onDetection(image: image, feedback: feedback)
                }
            }
        }
    }
    
    func processFrame(image: ImagePackage) async -> DetectionResult {
        let detections = await analyzer.forImage(image.image)
        if (detections.isEmpty) {
            return DetectionResult.EMPTY
        }
        
        return detections.first!
    }
    
    func addImage(image: UIImage) {
        let package = ImagePackage(image)
        currentImage = package
        imageFeed.emit(package)
    }
    
    func complete() {
        imageFeed.complete()
        currentImage = nil
    }
    
    func getLatest() -> ImagePackage? {
        return currentImage
    }
}
