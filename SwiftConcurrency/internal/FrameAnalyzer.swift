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
    private let confidence: Float
    private let isSelfie: Bool
    private var model: VNCoreMLModel? = nil

    init(withMinimumConfidence confidence: Float, withSelfie: Bool) {
        self.confidence = confidence
        self.isSelfie = withSelfie

        if !isSelfie {
            Task {
                self.model = try? VNCoreMLModel(
                    for: MobileNetV2(
                        configuration: MLModelConfiguration()
                    ).model
                )
            }
        }
    }

    func forImage(_ image: UIImage) async -> [DetectionResult] {
        guard let cgImage = image.cgImage else { return [] }

        return await withCheckedContinuation { continuation in
            let request: VNRequest

            if isSelfie {
                request = VNDetectFaceRectanglesRequest { request, error in
                    guard let results = request.results as? [VNFaceObservation], error == nil else {
                        print("Face detection error: \(error?.localizedDescription ?? "Unknown error")")
                        continuation.resume(returning: [])
                        return
                    }
                    
                    let parsedResults = self.parseFaceObservations(results, imageSize: image.size)
                    continuation.resume(returning: parsedResults)
                }
            } else {
                guard let model = model else {
                    continuation.resume(returning: [])
                    return
                }
                
                request = VNCoreMLRequest(model: model) { request, error in
                    guard let results = request.results as? [VNClassificationObservation], error == nil else {
                        print("Classification error: \(error?.localizedDescription ?? "Unknown error")")
                        continuation.resume(returning: [])
                        return
                    }
                    
                    let parsedResults = self.parseClassifications(results)
                    continuation.resume(returning: parsedResults)
                }
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

    // Face Detection Parsing
    private func parseFaceObservations(_ observations: [VNFaceObservation], imageSize: CGSize) -> [DetectionResult] {
        return observations
            .filter { $0.confidence >= confidence }
            .map { observation in
            let boundingBox = convertBoundingBox(observation.boundingBox, imageSize: imageSize)
                return DetectionResult(label: "Face", confidence: observation.confidence, boundingBox: boundingBox)
        }
    }

    // Classification Parsing
    private func parseClassifications(_ observations: [VNClassificationObservation]) -> [DetectionResult] {
        return observations
            .filter { $0.confidence >= confidence }
            .map { observation in
                print(observation)
                return DetectionResult(
                    label: observation.identifier,
                    confidence: observation.confidence,
                    boundingBox: .zero // Classification models do not have bounding boxes
                )
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
