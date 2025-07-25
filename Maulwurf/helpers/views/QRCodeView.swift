//
//  QRCodeView.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 20.07.25.
//

import Foundation
import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeView: View {
    let urlString: String
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        if let qrImage = generateQRCode(from: urlString) {
            Image(uiImage: qrImage)
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .padding()
        } else {
            Text("Failed to generate QR code.")
        }
    }

    func generateQRCode(from string: String) -> UIImage? {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")

        if let outputImage = filter.outputImage,
           let cgimg = context.createCGImage(outputImage.transformed(by: CGAffineTransform(scaleX: 1, y: 1)), from: outputImage.extent) {
            return UIImage(cgImage: cgimg)
        }

        return nil
    }
}
