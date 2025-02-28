//
//  ProcessorTypes.swift
//  SwiftConcurrency
//
//  Created by Callen Egan on 2025-02-11.
//

import SwiftUI

protocol IAsyncProcessor {
    func start(delegate: IProcessorDelegate)
    func addImage(image: UIImage)
    func getLatest() -> ImagePackage?
    func complete()
}

protocol IProcessorDelegate {
    func onDetection(image: ImagePackage, feedback: DetectionResult)
}

struct DetectionResult: Equatable {
    let label: String
    let confidence: Float
    let boundingBox: CGRect
    
    func isEmpty() -> Bool {
        return self == DetectionResult.EMPTY
    }
    
    func formattedString() -> String {
        var formatted = "[\(label)] ---------- \n" +
        "   Confidence: \(String(format: "%.2f", confidence * 100))% \n"
        
        if (boundingBox != CGRect.zero) {
            formatted += "   Bounding Box: x=\(Int(boundingBox.origin.x)), y=\(Int(boundingBox.origin.y)) \n" +
            "   width=\(Int(boundingBox.width)), height=\(Int(boundingBox.height))"
        }
        
        return formatted
    }
    
    static let EMPTY: DetectionResult = .init(label: "", confidence: 0, boundingBox: .zero)
}
