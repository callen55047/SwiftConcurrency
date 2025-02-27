//
//  CaptureView.swift
//  SwiftConcurrency
//
//  Created by Callen Egan on 2025-02-12.
//

import SwiftUI

struct CaptureView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: CaptureViewModel
    
    @ViewBuilder
    private func cameraLayer() -> some View {
        if (viewModel.capturedImage != nil) {
            Image(uiImage: viewModel.capturedImage!)
                .resizable()
                .rotation3DEffect(.degrees(viewModel.model.isSelfie ? 180 : 0), axis: (x:0, y:1, z:0))
        } else {
            CamDeviceUIView(cameraComp: viewModel.camera)
        }
    }
    
    @ViewBuilder
    private func graphicAnimationLayer(_ viewport: CGSize, _ heightOffset: CGFloat) -> some View {
        let coordinates = BoundingCoordinates.build()
        
        ZStack {
            cutout(viewport, coordinates)
            
            if (viewModel.model.isSelfie) {
                Circle()
                    .stroke(Color.green, lineWidth: 1)
                    .clipShape(Circle())
                    .frame(width: viewport.width * Theme.Dimensions.SELFIE_CIRCLE_WIDTH_RATIO)
                    
            } else {
                RoundedRectangle(cornerRadius: Theme.CornerRadiuses.c8)
                    .stroke(Color.green, lineWidth: 1)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadiuses.c8))
                    .frame(width: CGFloat(coordinates.getWidth()), height: CGFloat(coordinates.getHeight()))
            }
        }
        .frame(width: viewport.width, height: viewport.height)
        .offset(y: -heightOffset)
    }
    
    @ViewBuilder
    private func cutout(_ viewport: CGSize, _ coordinates: BoundingCoordinates) -> some View {
        if (viewModel.model.isSelfie) {
            TransparentCircleCutout(
                width: viewport.width,
                height: viewport.height,
                cameraCenter: coordinates.center.toCGPoint(),
                circleRadius: CircleData(width: viewport.width * Theme.Dimensions.SELFIE_CIRCLE_WIDTH_RATIO).radius
            )
        } else {
            TransparentCutout(
                viewport: viewport,
                insetWidth: CGFloat(coordinates.getWidth()),
                documentHeight: CGFloat(coordinates.getHeight())
            )
        }
    }
    
    @ViewBuilder
    private func informationLayer(_ viewport: CGSize, _ bottomSafeArea: CGFloat) -> some View {
        VStack {
            Spacer()
            BottomCardView {
                
                Text(viewModel.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                ScrollViewReader { scrollProxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(Array(viewModel.detections.enumerated()), id: \.offset) { index, detection in
                                Text(detection.formattedString())
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: Theme.CornerRadiuses.c8)
                            .fill(Color.gray)
                    )
                    .padding(.horizontal, Theme.Paddings.p24)
                    .padding(.bottom, Theme.Paddings.p12 + bottomSafeArea)
                    .animation(.default, value: viewModel.detections)
                    .onChange(of: viewModel.detections, initial: true) {oldState, newState in
                        if let lastIndex = viewModel.detections.indices.last {
                            withAnimation {
                                scrollProxy.scrollTo(lastIndex, anchor: .bottom)
                            }
                        }
                    }
                }
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let fullHeight = geometry.size.height + geometry.safeAreaInsets.top + geometry.safeAreaInsets.bottom
            let bottomSafeArea = geometry.safeAreaInsets.bottom
            let viewport = CGSize(width: geometry.size.width, height: fullHeight)
            let cardHeight = fullHeight * Theme.Dimensions.CARD_HEIGHT
            let heightOffset = (viewport.height / 2) - (viewport.height - cardHeight) / 2
            
            ZStack {
                cameraLayer()
                    .scaledToFill()
                    .frame(width: viewport.width)
                    .offset(y: -heightOffset)
                
                graphicAnimationLayer(viewport, heightOffset)
                
                informationLayer(viewport, bottomSafeArea)
            }
            .onAppear(perform: viewModel.start)
            .ignoresSafeArea()
        }
    }
}
