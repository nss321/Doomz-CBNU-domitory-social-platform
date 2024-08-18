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
    var roomIDs: [String] = []
    private init() {}

    func connectWebSocket() {
        guard let url = URL(string: Url.webSocket()) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        let token = Token.shared.number
        print("Connecting to WebSocket with URL: \(url)")
        socketClient.openSocketWithURLRequest(request: request as NSURLRequest, delegate: self, connectionHeaders: ["AccessToken": "Bearer \(token)"])
    }

    func disconnectWebSocket() {
        print("Disconnecting WebSocket")
        socketClient.disconnect()
    }

    func subscribe(to roomID: String) {
        if socketClient.isConnected() {
            print("Subscribing to \(roomID)")
            socketClient.subscribe(destination: roomID)
        } else {
            print("WebSocket not connected, adding \(roomID) to pending subscriptions")
            roomIDs.append(roomID)
        }
    }

    func stompClientDidConnect(client: StompClientLib!) {
        print("Socket is connected")
        //소켓 연결되면 들어가있는 채팅방 모두 구독
        chatListApiNetwork(url: Url.chattingRoom(page: 0, size: 999, keyword: nil))
    }

    func stompClientDidDisconnect(client: StompClientLib!) {
        print("Socket is Disconnected")
    }

    func stompClient(client: StompClientLib, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String: String]?, withDestination destination: String) {
        print("Message received from \(destination): \(String(describing: stringBody))")

        if let messageData = stringBody?.data(using: .utf8),
            let message = try? JSONDecoder().decode(ChatMessage.self, from: messageData) {
            NotificationCenter.default.post(name: .newChatMessage, object: message)
        } else {
            print("Failed to decode message")
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
    
    private func chatListApiNetwork(url: String) {
        Network.getMethod(url: url) { (result: Result<ChattingRoomsResponse, Error>) in
            switch result {
            case .success(let response):
                for room in response.data.chatRooms {
                    WebSocketManager.shared.subscribe(to: String(room.roomId))
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}


extension Notification.Name {
    static let newChatMessage = Notification.Name("newChatMessage")
}
