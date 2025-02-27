//
//  Navigator.swift
//  SwiftConcurrency
//
//  Created by Callen Egan on 2025-02-12.
//

import SwiftUI

struct Navigator: View {
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.black, Color.gray.opacity(0.8)]),
                    startPoint: .top,
                    endPoint: .bottom
                ).edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    Text("TinyML Object Detection")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Leverage Apple’s YOLOv3 model to detect objects in real-time using a custom multi-threaded processor.")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.black.opacity(0.3))
                        .frame(width: 300, height: 200)
                        .overlay(
                            VStack {
                                Image(systemName: "camera.viewfinder")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.white.opacity(0.6))
                                
                                Text("Camera Access Required")
                                    .foregroundColor(.white.opacity(0.8))
                                    .font(.headline)
                            }
                        )
                    
                    Spacer()
                    
                    NavigationLink(
                        destination: CaptureView(
                            viewModel: CaptureViewModel(
                                model: CaptureModel(isSelfie: false)
                            )
                        )
                    ) {
                        TextView(text: "Back Capture")
                            .padding(.bottom, 16)
                    }
                    
                    NavigationLink(
                        destination: CaptureView(
                            viewModel: CaptureViewModel(
                                model: CaptureModel(isSelfie: true)
                            )
                        )
                    ) {
                        TextView(text: "Front Capture")
                    }
                }
                .padding(.vertical, 24)
            }
        }
    }
}

