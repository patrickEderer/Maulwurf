//
//  LocalUnoServer.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 19.07.25.
//

import Foundation
//import GCDWebServer
import UIKit

public class LocalUnoServer {
    private static var INSTANCE: LocalUnoServer?

    private init() {}

    public static func getInstance() -> LocalUnoServer {
        if INSTANCE == nil {
            INSTANCE = LocalUnoServer()
        }
        return INSTANCE!
    }

//    public func start() {
        // Start the server
//        webServer = GCDWebServer()
//
//        // Add a handler for GET requests to "/"
//        webServer?.addDefaultHandler(
//            forMethod: "GET",
//            request: GCDWebServerRequest.self,
//            processBlock: { request in
//
//                // The top UNO card (could be dynamic)
//                let topCard = "🟦 Reverse"
//
//                let html = """
//                    <!DOCTYPE html>
//                    <html><head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
//                    <body style="font-size: 80px; text-align: center; margin-top: 20%;">
//                        \(topCard)
//                    </body></html>
//                    """
//
//                return GCDWebServerDataResponse(html: html)
//            }
//        )
//
//        // Start the server
//        do {
//            try webServer?.start(options: [
//                GCDWebServerOption_Port: 8080,
//                GCDWebServerOption_BindToLocalhost: false,  // important: allow other devices on the network
//                GCDWebServerOption_AutomaticallySuspendInBackground: false,
//            ])
//
//            if let serverURL = webServer?.serverURL {
//                print("✅ Web server running at: \(serverURL)")
//                // You can display this URL in the app, or generate a QR code from it
//            }
//
//        } catch {
//            print("❌ Error starting server: \(error)")
//        }
//    }

}
