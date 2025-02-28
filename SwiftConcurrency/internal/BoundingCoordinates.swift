//
//  BoundingBoxFactory.swift
//  SwiftConcurrency
//
//  Created by Callen Egan on 2025-02-12.
//

import SwiftUI

struct ScreenPoint {
    let x: Float
    let y: Float
    
    func toCGPoint() -> CGPoint {
        return CGPoint(x: Int(x), y: Int(y))
    }
}

struct BoundingCoordinates {
    let topLeft: ScreenPoint
    let bottomRight: ScreenPoint
    let center: ScreenPoint
    let selfieRadius: Float
    
    func getWidth() -> Float {
        return bottomRight.x - topLeft.x
    }
    
    func getHeight() -> Float {
        return bottomRight.y - topLeft.y
    }
    
    static func build() -> BoundingCoordinates {
        let screenSize = UIScreen.main.bounds
        
        // 24px padding on left and right
        let boundingBoxWidth = screenSize.width - Theme.Paddings.p48
        let boundingBoxHeight = Theme.Dimensions.PASSPORT_RATIO * boundingBoxWidth
        
        let boundingBoxOrigin = ScreenPoint(
            x: Float(screenSize.midX - boundingBoxWidth / 2),
            y: Float(screenSize.midY - boundingBoxHeight / 2))
        
        let bottomRight = ScreenPoint(
            x: boundingBoxOrigin.x + Float(boundingBoxWidth),
            y: boundingBoxOrigin.y + Float(boundingBoxHeight))
        
        let center = ScreenPoint(
            x: Float(screenSize.midX),
            y: Float(screenSize.midY))
        
        let selfieRadius = Float((screenSize.width / 2) * Theme.Dimensions.SELFIE_CIRCLE_WIDTH_RATIO)
        
        return BoundingCoordinates(
            topLeft: boundingBoxOrigin,
            bottomRight: bottomRight,
            center: center,
            selfieRadius: selfieRadius
        )
    }
}
