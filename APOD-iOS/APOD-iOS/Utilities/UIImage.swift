//
//  UIImage.swift
//  APOD-iOS
//
//  Created by Ankita Kotadiya on 15/11/24.
//

import Foundation
import UIKit

// UIImage extension to handle GIF data
extension UIImage {
    static func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }
        return UIImage.animatedImageWithSource(source)
    }
    
    static func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        var images: [UIImage] = []
        var duration: Double = 0
        
        let count = CGImageSourceGetCount(source)
        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let frameDuration = UIImage.frameDuration(at: i, source: source)
                duration += frameDuration
                images.append(UIImage(cgImage: cgImage))
            }
        }
        
        return UIImage.animatedImage(with: images, duration: duration)
    }
    
    static func frameDuration(at index: Int, source: CGImageSource) -> Double {
        var frameDuration = 0.1
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        guard let gifProperties = (cfProperties as? [String: AnyObject])?[kCGImagePropertyGIFDictionary as String] as? [String: AnyObject] else {
            return frameDuration
        }
        
        if let delayTime = gifProperties[kCGImagePropertyGIFUnclampedDelayTime as String] as? Double {
            frameDuration = delayTime
        } else if let delayTime = gifProperties[kCGImagePropertyGIFDelayTime as String] as? Double {
            frameDuration = delayTime
        }
        
        return frameDuration < 0.1 ? 0.1 : frameDuration
    }
}
