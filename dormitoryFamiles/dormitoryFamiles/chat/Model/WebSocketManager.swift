//
//  WebSocketManager.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 8/7/24.
//

import Foundation
import StompClientLib

class WebSocketManager: StompClientLibDelegate {
    static let shared = WebSocketManager()
    
    var socketClient: StompClientLib = StompClientLib()
    var roomUUID: String?

    private init() {}
    
    func connectWebSocket() {
        guard let url = URL(string: Url.webSocket()) else { return }
        let request = URLRequest(url: url)
        let token = Token.shared.number
        socketClient.openSocketWithURLRequest(request: request as NSURLRequest, delegate: self, connectionHeaders: ["AccessToken": "Bearer \(token)"])
    }
    
    func disconnectWebSocket() {
        socketClient.disconnect()
    }
    
    func subscribe(to roomUUID: String) {
        self.roomUUID = roomUUID
        if socketClient.isConnected() {
            socketClient.subscribe(destination: roomUUID)
        }
    }
    
    func stompClientDidConnect(client: StompClientLib!) {
        print("Socket is connected")
        if let roomUUID = roomUUID {
            socketClient.subscribe(destination: roomUUID)
        }
    }

    func stompClientDidDisconnect(client: StompClientLib!) {
        print("Socket is Disconnected")
    }

    func stompClient(client: StompClientLib, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String: String]?, withDestination destination: String) {
        print("Message received: \(String(describing: stringBody))")
        
        if let messageData = stringBody?.data(using: .utf8) {
            NotificationCenter.default.post(name: .newChatMessage, object: nil, userInfo: ["messageData": messageData])
        }
    }

    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        print("Receipt: \(receiptId)")
    }

    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        print("Error: \(description)")
        if let message = message {
            print("Error Description: \(message)")
        }
    }

    func serverDidSendPing() {
        print("Server ping")
    }
}

extension Notification.Name {
    static let newChatMessage = Notification.Name("newChatMessage")
}
