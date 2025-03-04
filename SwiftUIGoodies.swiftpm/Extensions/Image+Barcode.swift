//
//  Image+Barcode.swift
//  SwiftUIGoodies
//
//  Created by Eyal Katz on 05/03/2025.
//

import SwiftUI
import CoreImage

extension Image {
    
    enum BarCode {
        case qr
        case code128Barcode
        case pdf417Barcode
        case aztec
        
        var ciFilterName: String {
            switch self {
            case .qr:
                return "CIQRCodeGenerator"
            case .code128Barcode:
                return "CICode128BarcodeGenerator"
            case .pdf417Barcode:
                return "CIPDF417BarcodeGenerator"
            case .aztec:
                return "CIAztecCodeGenerator"
            }
        }
    }
    
    init(_ barcodeType: BarCode, code: String, color: UIColor, filterParameters: [String: Any?] = [:]) {
        guard let filter = CIFilter(name: barcodeType.ciFilterName) else {
            self.init(systemName: "xmark.circle")
            return
        }
        
        filter.setValue(Data(code.utf8), forKey: "inputMessage")
        
        if barcodeType == .qr {
            filter.setValue("H", forKey: "inputCorrectionLevel")
        }
        
        if let ciImage = filter.outputImage?.transformed(by: CGAffineTransform(scaleX: 10, y: 10)).tinted(by: color),
           let cgImage = CIContext().createCGImage(ciImage, from: ciImage.extent) {
            self.init(cgImage, scale: 1, label: Text("BarCode"))
        } else {
            self.init(systemName: "xmark.circle")
        }
    }
}
