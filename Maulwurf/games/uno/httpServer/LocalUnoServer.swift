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
    
    private var card: UnoCard? = UnoCard(color: .WILD, char: "")
    
    var httpServer: SimpleHTTPServer?

    private init() {
        httpServer = SimpleHTTPServer(contentProvider: {
            return """
            <html>
                <head>
                    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
                    <meta http-equiv='refresh' content='1'>
                </head>
                <body style='font-size:100px;text-align:center;margin-top:30%;background-color:\(self.card!.color.getHex())'>
                    \(self.card!.char)
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
    
    func setTopCard(_ card: UnoCard) {
        self.card = card
    }

    func start(_ card: UnoCard) {
        setTopCard(card)
        httpServer!.start()
    }
}
