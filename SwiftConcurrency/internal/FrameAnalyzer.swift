//
//  FrameAnalyzer.swift
//  SwiftConcurrency
//
//  Created by Callen Egan on 2025-02-20.
//

@preconcurrency import Vision
import CoreML
import UIKit

class FrameAnalyzer {
    // TODO: load model dynamically
    private var model: VNCoreMLModel? = nil
    
    init() {
        Task {
            self.model = try? VNCoreMLModel(
                for: YOLOv3(
                    configuration: MLModelConfiguration()
                ).model
            )
        }
    }
    
    func forImage(_ image: UIImage) async -> [DetectionResult] {
        guard let model = model, let cgImage = image.cgImage else { return [] }
        
        return await withCheckedContinuation { continuation in
            let request = VNCoreMLRequest(model: model) { request, error in
                guard let results = request.results as? [VNRecognizedObjectObservation], error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    continuation.resume(returning: [])
                    return
                }
                
                let parsedResults = self.parseObservations(results, imageSize: image.size)
                continuation.resume(returning: parsedResults)
            }
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try handler.perform([request])
                } catch {
                    print("Failed to perform request: \(error.localizedDescription)")
                    continuation.resume(returning: [])
                }
            }
        }
    }
    
    private func parseObservations(_ observations: [VNRecognizedObjectObservation], imageSize: CGSize) -> [DetectionResult] {
        return observations.compactMap { observation in
            guard let topLabel = observation.labels.first else { return nil }

            let confidence = topLabel.confidence
            let boundingBox = convertBoundingBox(observation.boundingBox, imageSize: imageSize)

            return DetectionResult(label: topLabel.identifier, confidence: confidence, boundingBox: boundingBox)
        }
        .sorted(by: { $0.confidence > $1.confidence })
    }

    private func convertBoundingBox(_ boundingBox: CGRect, imageSize: CGSize) -> CGRect {
        let x = boundingBox.origin.x * imageSize.width
        let y = (1 - boundingBox.origin.y - boundingBox.height) * imageSize.height
        let width = boundingBox.width * imageSize.width
        let height = boundingBox.height * imageSize.height
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
}
