//
//  UIImageExtension.swift
//  SwiftConcurrency
//
//  Created by Callen Egan on 2025-02-11.
//

import SwiftUI

extension UIImage {
    func resize(to newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        defer { UIGraphicsEndImageContext() }

        self.draw(in: CGRect(origin: .zero, size: newSize))

        return UIGraphicsGetImageFromCurrentImageContext()
    }

    func centerPoint() -> CGPoint {
        let centerX = size.width / 2
        let centerY = size.height / 2
        return CGPoint(x: centerX, y: centerY)
    }

    func sizeInMb() -> Float {
        let data = pngData()
        let bytesPerMB: Float = 1024 * 1024
        return Float(data!.count) / bytesPerMB
    }

    func cropToSubject() -> UIImage {
        let documentRatio = 88.0 / 125.0
        let documentViewfinderWidth: CGFloat = 0.90
        let imageWidth = size.width
        let imageHeight = size.height

        let croppedImageWidth = imageWidth * documentViewfinderWidth
        let croppedImageHeight = croppedImageWidth * documentRatio

        let xCenter = imageWidth / 2.0
        let yCenter = imageHeight / 2.0
        let sourceX = xCenter - (croppedImageWidth / 2)
        let sourceY = yCenter - (croppedImageHeight / 2)

        let cropRectangle = CGRect(
            x: sourceX,
            y: sourceY,
            width: croppedImageWidth,
            height: croppedImageHeight
        )

        let imageRef = cgImage!.cropping(to: cropRectangle)!
        let croppedImage = UIImage(cgImage: imageRef)
        return croppedImage
    }

    func cropByPercentage(percentageTarget: CGFloat) -> UIImage? {
        let width = size.width
        let height = size.height
        let centerPoint = self.centerPoint()

        let percent = percentageTarget
        if percent >= 1.0 || percent <= 0.0 { return nil }

        let adjustedWidth = size.width - (width * percent)
        let adjustedHeight = size.height - (height * percent)
        let cropZone = CGRect(
            x: centerPoint.x - adjustedWidth / 2,
            y: centerPoint.y - adjustedHeight / 2,
            width: adjustedWidth,
            height: adjustedHeight
        )

        guard let croppedCGImage = cgImage?.cropping(to: cropZone) else {
            return nil
        }
        return UIImage(cgImage: croppedCGImage)
    }
}
