//
//  CaptureView.swift
//  SwiftConcurrency
//
//  Created by Callen Egan on 2025-02-12.
//

import Foundation
import UIKit

struct ImagePackage {
    let image: UIImage
    let id: String
    
    init(_ image: UIImage, _ id: String? = nil) {
        self.image = image
        self.id = id ?? UUID().uuidString
    }
    
    var isRequiredResolution: Bool {
        return min(image.size.width, image.size.height) >= 720
    }
    
    func resizedModelImage() -> UIImage {
        return image
            .cropToSubject()
            .resize(to: CGSize(width: 320, height: 320))!
    }
}
