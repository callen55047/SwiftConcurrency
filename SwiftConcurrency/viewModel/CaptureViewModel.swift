//
//  CaptureViewModel.swift
//  SwiftConcurrency
//
//  Created by Callen Egan on 2025-02-12.
//

import SwiftUI

class CaptureViewModel: ObservableObject, IFrameCaptureDelegate, IProcessorDelegate {
    let model: CaptureModel
    let camera: CameraDevice
    lazy var processor = AsyncProcessor(isSelfie: model.isSelfie)
    
    @Published var title: String = "Setting up..."
    @Published var detections: [DetectionResult] = []
    var capturedImage: UIImage? = nil
    
    init(model: CaptureModel) {
        self.model = model
        self.camera = CameraDevice(model.isSelfie ? .front : .back)
    }
    
    func start() {
        title = "Detecting objects"
        processor.start(delegate: self)
        camera.startFrameCaptureSession(delegate: self)
    }
    
    func newFrame(image: UIImage) {
        processor.addImage(image: image.cropToSubject())
    }
    
    func onDetection(image: ImagePackage, feedback: DetectionResult) {
        withAnimation {
            detections.append(feedback)
        }
    }
}
