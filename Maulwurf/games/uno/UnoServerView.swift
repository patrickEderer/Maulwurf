//
//  UnoServerView.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 10.08.25.
//

import Foundation
import SwiftUI

struct UnoServerView: View {
    var manager: UnoViewManager
    @State var fullscreenQRCode: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("State:")
                    switch manager.engine.server.httpServer!.state {
                    case .Running: Text("Running").foregroundColor(.green)
                    case .Error: Text("Error").foregroundColor(.red)
                    case .Stopped: Text("Stopped").foregroundColor(.red)
                    }
                }
                
                let address = "http://\(getIPv4Address()):8080"
                QRCodeView(urlString: address)
                    .scaledToFit()
                    .scaleEffect(fullscreenQRCode ? 2 : 1)
                    .onTapGesture {
                        withAnimation(.bouncy(duration: 0.25, extraBounce: 0.2)) {
                            fullscreenQRCode.toggle()
                        }
                    }
                    .zIndex(2)
                Text(address)
                    .font(.title)
            }
            
            VStack {
                Spacer()
                
                Button {
                    manager.serverView = false
                } label: {
                    Text("Back")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                        .frame(width: 100, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white)
                                .stroke(.green.darker(by: 0.5), lineWidth: 1)
                        )
                }
            }
        }
    }
}
