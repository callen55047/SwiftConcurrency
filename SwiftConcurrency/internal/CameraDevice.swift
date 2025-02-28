//
//  CameraDevice.swift
//  SwiftConcurrency
//
//  Created by Callen Egan on 2025-02-11.
//

import SwiftUI
import AVFoundation

protocol IFrameCaptureDelegate {
    func newFrame(image: UIImage)
}

class CameraDevice: UIView, AVCaptureVideoDataOutputSampleBufferDelegate {
    private var captureSession = AVCaptureSession()
    lazy private var videoDataOutput = AVCaptureVideoDataOutput()
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var captureDevice: AVCaptureDevice!
    private let context = CIContext()
    private var setupComplete = false
    private var delegate: IFrameCaptureDelegate? = nil
    
    private let cameraPosition: AVCaptureDevice.Position
    
    init(_ position: AVCaptureDevice.Position) {
        self.cameraPosition = position
        
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "Main-video-output-queue"))
        videoDataOutput.connection(with: .video)?.isEnabled = true
        previewLayer = (layer as! AVCaptureVideoPreviewLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Coder has not been implemented.")
    }
    
    func startFrameCaptureSession(delegate: IFrameCaptureDelegate) {
        guard !captureSession.isRunning else { return }
        self.delegate = delegate
        
        if (!setupComplete) {
            do {
                captureSession.beginConfiguration()
                guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: cameraPosition) else { return }
                let currentInput = try AVCaptureDeviceInput(device: captureDevice)
                captureSession.addInput(currentInput)
                captureSession.addOutput(self.videoDataOutput)
                previewLayer.session = self.captureSession
                captureSession.commitConfiguration()
                setupComplete = true
                videoDataOutput.connection(with: .video)?.videoOrientation = .portrait
            } catch {
                fatalError("Could not start camera session: \(error)")
            }
        }
        
        OperationQueue().addOperation {
            self.captureSession.startRunning()
        }
    }
    
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let uiImage = convertBufferToUIImage(sampleBuffer) else { return }
        delegate?.newFrame(image: uiImage)
    }
    
    private func convertBufferToUIImage(_ buffer: CMSampleBuffer) -> UIImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(buffer) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: cgImage, scale: 1.0, orientation: .up)
    }
    
    func stopFrameCaptureSession() {
        captureSession.stopRunning()
    }
}

struct CamDeviceUIView: UIViewRepresentable {
    private let cameraComp: CameraDevice
    
    init (cameraComp: CameraDevice) {
        self.cameraComp = cameraComp
    }
    
    func makeUIView(context: Context) -> CameraDevice {
        cameraComp
    }
    
    func updateUIView(_ uiViewController: CameraDevice, context: Context) {}
}
