//
//  UnoView.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 14.07.25.
//

import Foundation
import SwiftUI

struct UnoView: View {
    @ObservedObject var engine: UnoEngine
    @ObservedObject var updater = Updater.getInstance()

    @State private var ipAddress: String = "localhost"
    @State private var qrCodeImage: UIImage? = nil
    @State private var showQRCode: Bool = true

    var body: some View {
        ZStack {
            VStack {
                Slider(value: Binding(get: {
                    Float(engine.players.first?.cards.count ?? 0) / 40.0
                }, set: { new in
                    engine.setCardCountEveryPlayer(Int(new * 40.0))
                    updater.update()
                }))
                
                Spacer()
            }
            
            UnoCardView(card: engine.getTopCard())
                .scaleEffect(0.5)
            
            VStack {
                Spacer()
                
                VStack {
                    UnoCardSelector(currentCard: engine.getTopCard(), cards: engine.players[engine.currentPlayerIndex].cards) { i in
                        engine.placeCard(i)
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.black.opacity(0.5))
                        .frame(height: 250)
                )
            }
            
            VStack {
                Spacer()
                
                Button {
                    engine.sortCards(playerIndex: engine.currentPlayerIndex)
                } label: {
                    Text("Sort")
                }
            }
            
            if showQRCode {
                QRCodeView(urlString: "http://\(getIPv4Address()):8080")
                    .onTapGesture { showQRCode = false }
            }
        }
    }

    func generateQRCode(from string: String) -> UIImage? {
        let data = Data(string.utf8)
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("Q", forKey: "inputCorrectionLevel")

        if let outputImage = filter.outputImage {
            let scaledImage = outputImage.transformed(
                by: CGAffineTransform(scaleX: 10, y: 10)
            )
            return UIImage(ciImage: scaledImage)
        }

        return nil
    }
}
