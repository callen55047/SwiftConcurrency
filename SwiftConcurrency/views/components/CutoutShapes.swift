//
//  CutoutShapes.swift
//  SwiftConcurrency
//
//  Created by Callen Egan on 2025-02-12.
//

import SwiftUI

struct TransparentCutout: View {
    let viewport: CGSize
    let insetWidth: CGFloat
    let documentHeight: CGFloat
    
    private struct DocumentCaptureCutOutRectangle: Shape {
        let width: CGFloat
        let height: CGFloat

        func path(in rect: CGRect) -> Path {
            let size = CGSize(width: width, height: height)
            let origin = CGPoint(x: rect.midX - size.width / 2, y: rect.midY - (size.height / 2))

            var path = Rectangle().path(in: rect)
            path.addRoundedRect(
                in: CGRect(origin: origin, size: size),
                cornerSize: CGSize(width: Theme.CornerRadiuses.c8, height: Theme.CornerRadiuses.c8)
            )
            return path
        }
    }
    
    var body: some View {
        Rectangle()
            .foregroundColor(Color.black.opacity(0.4))
            .mask(
                DocumentCaptureCutOutRectangle(
                    width: insetWidth,
                    height: documentHeight
                )
                    .fill(style: FillStyle(eoFill: true))
            )
    }
}

struct CircleData {
    let diameter: CGFloat
    let radius: CGFloat
    
    init (width: CGFloat) {
        diameter = width
        radius = width / 2
    }
}

func TransparentCircleCutout(width: CGFloat, height: CGFloat, cameraCenter: CGPoint, circleRadius: CGFloat) -> some View {
    return CircleCutoutShape(circleRadius: circleRadius, cameraCenter: cameraCenter)
        .fill(Color.black.opacity(0.4), style: FillStyle(eoFill: true, antialiased: true))
        .frame(width: width, height: height, alignment: .center)
}

private struct CircleCutoutShape: Shape {
    let circleRadius: CGFloat
    let cameraCenter: CGPoint
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.addArc(
                center: cameraCenter,
                radius: circleRadius,
                startAngle: Angle(degrees: 0),
                endAngle: Angle(degrees: 360),
                clockwise: true
            )
            path.addRect(
                CGRect(
                    x: rect.minX,
                    y: rect.minY,
                    width: rect.width,
                    height: rect.height
                )
            )
        }
    }
}
