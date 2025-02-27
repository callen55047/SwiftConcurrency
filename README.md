# SwiftConcurrency Object Detection Demo

## Overview
This SwiftUI project demonstrates real-time object detection using Apple's **TinyML** model and **Swift Concurrency** for efficient multi-threaded image processing. The app leverages **Vision** and **CoreML** frameworks to analyze frames from the camera feed while utilizing asynchronous operations to maintain performance.

## Key Components

### 1. **CaptureView.swift**
- The main SwiftUI view that integrates the camera feed and displays detected objects in real-time.
- Uses `AsyncProcessor` to process multiple frames concurrently.
- Displays bounding boxes and detection results dynamically.

### 2. **AsyncProcessor.swift**
- Implements `IAsyncProcessor` to handle image frame processing.
- Manages an **image stream** (`SFlow<ImagePackage>`) for asynchronous processing.
- Delegates frame analysis to `FrameAnalyzer` and dispatches detection results to the main thread.
- **Functions:**
  - `start(delegate:)` → Registers the image processing task.
  - `processFrame(image:)` → Calls `FrameAnalyzer` to detect objects asynchronously.
  - `addImage(image:)` → Receives and processes new frames.
  - `complete()` → Stops the processor and clears resources.
  - `getLatest()` → Retrieves the most recent frame.

### 3. **FrameAnalyzer.swift**
- Responsible for running the **YOLOv3 TinyML model** using Apple's `VNCoreMLModel`.
- Uses **Vision** framework to analyze image frames for object detection.
- **Functions:**
  - `forImage(_:)` → Performs inference on the given image asynchronously.
  - `parseObservations(_, imageSize:)` → Extracts recognized objects and sorts them by confidence.
  - `convertBoundingBox(_, imageSize:)` → Converts Vision's bounding box coordinates to the correct image dimensions.

## Features
✅ **Real-Time Object Detection** – Uses Apple's Vision & CoreML frameworks.  
✅ **Multi-Threaded Processing** – Async frame processing to ensure smooth UI.  
✅ **YOLOv3 Model Integration** – Uses a TinyML model for object detection.  
✅ **Swift Concurrency Optimized** – Async/Await ensures high efficiency.  
✅ **Live Camera Feed Analysis** – Detects and displays objects in real time.  

## Next Steps
🔹 Optimize detection performance using a more lightweight ML model.  
🔹 Add additional UI elements for better visualization of detected objects.  
🔹 Implement model selection to dynamically load different CoreML models.  

This project is designed for **developers looking to implement real-time machine learning** in Swift applications. 🚀

---

### Run the Project
Open the `SwiftConcurrency.xcodeproj` file and run the project in Xcode:
```sh
open SwiftConcurrency.xcodeproj
```

Make sure your Mac is running the latest Xcode version for best compatibility.

