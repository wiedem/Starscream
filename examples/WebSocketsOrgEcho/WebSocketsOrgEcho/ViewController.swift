//
//  ViewController.swift
//  WebSocketsOrgEcho
//
//  Created by Kristaps Grinbergs on 08/10/2018.
//  Copyright © 2018 Starscream. All rights reserved.
//

import UIKit

import Starscream

class ViewController: UIViewController, WebSocketDelegate {
    var socket = WebSocket(url: URL(staticString: "wss://echo.websocket.org"))

    func websocketDidConnect(socket _: WebSocketClient) {
        print("websocketDidConnect")
    }

    func websocketDidDisconnect(socket _: WebSocketClient, error: Error?) {
        print("websocketDidDisconnect", error ?? "")
    }

    func websocketDidReceiveMessage(socket _: WebSocketClient, text: String) {
        print("websocketDidReceiveMessage", text)
    }

    func websocketDidReceiveData(socket _: WebSocketClient, data: Data) {
        print("websocketDidReceiveData", data)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        socket.delegate = self
    }

    @IBAction func connect(_: Any) {
        socket.connect()
    }
}
