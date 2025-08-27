//
//  LocalUnoServer.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 19.07.25.
//

import Foundation
import Network
import UIKit
import CoreImage.CIFilterBuiltins

public class LocalUnoServer {
    private static var INSTANCE: LocalUnoServer?
    
    private var card: any UnoCard = UnoNumberCard(colorIndex: 0, number: -10)
    
    var httpServer: SimpleHTTPServer?

    private init() {
        httpServer = SimpleHTTPServer(contentProvider: {
            return """
            <html>
                <head>
                    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
                    <meta http-equiv='refresh' content='1'>
                </head>
                <body style='font-size:100px;text-align:center;margin-top:30%;background-color:\(UnoColorManager.getInstance().getHexCode(colorIndex: self.card.getColorIndex()))'>
                    \(self.card.getChar())
                </body>
            </html>
            """
        })
    }

    public static func getInstance() -> LocalUnoServer {
        if INSTANCE == nil {
            INSTANCE = LocalUnoServer()
        }
        return INSTANCE!
    }
    
    func setTopCard(_ card: any UnoCard) {
        self.card = card
    }
    
    func stop() {
        httpServer!.stop()
    }

    func start(_ card: any UnoCard) {
        setTopCard(card)
        httpServer!.start()
    }
}
