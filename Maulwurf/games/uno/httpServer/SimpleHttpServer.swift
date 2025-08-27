//
//  SimpleHttpServer.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 20.07.25.
//

import Foundation
import Network

class SimpleHTTPServer {
    private var listener: NWListener?
    private let port: NWEndpoint.Port = 8080
    private let htmlContent: () -> String
    public var state: UnoServerState = .Stopped

    init(contentProvider: @escaping () -> String) {
        self.htmlContent = contentProvider
    }
    
    func stop() {
        listener?.cancel()
        state = .Stopped
    }

    func start() {
        do {
            listener = try NWListener(using: .tcp, on: port)
        } catch {
            print("❌ Failed to create listener: \(error)")
            return
        }

        listener?.newConnectionHandler = { [weak self] connection in
            connection.start(queue: .main)
            connection.stateUpdateHandler = { [weak self] state in
                if state == .ready {
                    self?.state = .Running
                } else if state == .cancelled {
                    self?.state = .Stopped
                } else {
                    self?.state = .Error
                }
            }
            self?.handle(connection: connection)
        }

        listener?.start(queue: .main)
        state = .Running
        print("✅ Server running on port \(port)")
    }

    private func handle(connection: NWConnection) {
        connection.receive(minimumIncompleteLength: 1, maximumLength: 1500) { [weak self] data, _, isComplete, error in
            guard
                let self = self/*,
                let data = data,
                let request = String(data: data, encoding: .utf8)*/
            else {
                connection.cancel()
                return
            }

//            print("🌐 Request:\n\(request)")

            let body = self.htmlContent()
            let response = """
            HTTP/1.1 200 OK\r
            Content-Type: text/html; charset=utf-8\r
            Content-Length: \(body.utf8.count)\r
            Connection: close\r
            \r
            \(body)
            """

            connection.send(content: response.data(using: .utf8), completion: .contentProcessed { _ in
                connection.cancel()
            })
        }
    }
}
