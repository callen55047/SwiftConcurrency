//
//  CaptureView.swift
//  SwiftConcurrency
//
//  Created by Callen Egan on 2025-02-12.
//

import SwiftUI

final class Theme {
    struct CornerRadiuses {
        static let c8: CGFloat = 8
        static let c12: CGFloat = 12
        static let c24: CGFloat = 24
    }
    
    struct Dimensions {
        static let CARD_HEIGHT: CGFloat = 0.4
        
        static let DOCUMENT_RATIO: CGFloat = 0.63
        static let PASSPORT_RATIO: CGFloat = 0.71
        static let DOCUMENT_OUTLINE_WIDTH_RATIO: CGFloat = 1.01
        static let SELFIE_CIRCLE_WIDTH_RATIO: CGFloat = 0.8
    }
    
    static func TImage(name: ThemeImage) -> Image {
        return Image(
            name.rawValue,
            bundle: Bundle(identifier: "com.egan.example.swiftConcurrency")
        )
    }
    
    struct Paddings {
        static let p12: CGFloat = 12
        static let p24: CGFloat = 24
        static let p48: CGFloat = 48
    }
    
    struct Spacing {
        static let s0: CGFloat = 0
    }
}

enum ThemeImage: String {
    case passportWhiteOutline = "Passport_White_Outline"
    case selfieWhiteOutline = "Selfie_White_Outline"
}
