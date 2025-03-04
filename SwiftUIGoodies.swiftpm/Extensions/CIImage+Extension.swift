//
//  CIImage+Extension.swift
//  SwiftUIGoodies
//
//  Created by Eyal Katz on 05/03/2025.
//

import SwiftUI
import CoreImage.CIFilterGenerator

public extension CIImage {
    
    var transparent: CIImage? {
        inverted?.blackTransparent
    }
    
    var inverted: CIImage? {
        guard let invertedColorFilter = CIFilter(name: "CIColorInvert") else { return nil }
        invertedColorFilter.setValue(self, forKey: "inputImage")
        return invertedColorFilter.outputImage
    }
    
    var blackTransparent: CIImage? {
        guard let blackTransparentFilter = CIFilter(name: "CIMaskToAlpha") else { return nil }
        blackTransparentFilter.setValue(self, forKey: "inputImage")
        return blackTransparentFilter.outputImage
    }
    
    func tinted(by color: UIColor) -> CIImage? {
        guard let transparentQRImage = transparent,
              let filter = CIFilter(name: "CIMultiplyCompositing"),
              let colorFilter = CIFilter(name: "CIConstantColorGenerator") else { return nil }
        
        let ciColor = CIColor(cgColor: color.cgColor)
        colorFilter.setValue(ciColor, forKey: kCIInputColorKey)
        let colorImage = colorFilter.outputImage
        
        filter.setValue(colorImage, forKey: kCIInputImageKey)
        filter.setValue(transparentQRImage, forKey: kCIInputBackgroundImageKey)
        return filter.outputImage
    }
}
