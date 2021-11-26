//////////////////////////////////////////////////////////////////////////////////////////////////
//
//  ViewController.swift
//  SimpleTest
//
//  Created by Dalton Cherry on 8/12/14.
//  Copyright © 2014 Vluxe. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//////////////////////////////////////////////////////////////////////////////////////////////////

import Starscream
import UIKit

class ViewController: UIViewController, WebSocketDelegate {
    var socket: WebSocket!
    var isConnected = false
    let server = WebSocketServer()

    override func viewDidLoad() {
        super.viewDidLoad()
//        let err = server.start(address: "localhost", port: 8080)
//        if err != nil {
//            print("server didn't start!")
//        }
//        server.onEvent = { event in
//            switch event {
//            case .text(let conn, let string):
//                let payload = string.data(using: .utf8)!
//                conn.write(data: payload, opcode: .textFrame)
//            default:
//                break
//            }
//        }
        // https://echo.websocket.org
        var request = URLRequest(url: URL(string: "http://localhost:8080")!) // https://localhost:8080
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }

    // MARK: - WebSocketDelegate

    func didReceive(event: WebSocketEvent, client _: WebSocket) {
        switch event {
        case let .connected(headers):
            isConnected = true
            print("websocket is connected: \(headers)")
        case let .disconnected(reason, code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case let .text(string):
            print("Received text: \(string)")
        case let .binary(data):
            print("Received data: \(data.count)")
        case .ping:
            break
        case .pong:
            break
        case .viabilityChanged:
            break
        case .reconnectSuggested:
            break
        case .cancelled:
            isConnected = false
        case let .error(error):
            isConnected = false
            handleError(error)
        }
    }

    func handleError(_ error: Error?) {
        if let e = error as? WSError {
            print("websocket encountered an error: \(e.message)")
        } else if let e = error {
            print("websocket encountered an error: \(e.localizedDescription)")
        } else {
            print("websocket encountered an error")
        }
    }

    // MARK: Write Text Action

    @IBAction func writeText(_: UIBarButtonItem) {
        socket.write(string: "hello there!")
    }

    // MARK: Disconnect Action

    @IBAction func disconnect(_ sender: UIBarButtonItem) {
        if isConnected {
            sender.title = "Connect"
            socket.disconnect()
        } else {
            sender.title = "Disconnect"
            socket.connect()
        }
    }
}
