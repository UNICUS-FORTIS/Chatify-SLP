//
//  SocketManager.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/6/24.
//

import Foundation
import SocketIO
import RxSwift


final class SocketIOManager: NSObject {
    
    static let shared = SocketIOManager()
    private override init() { super.init() }
    
    private var channelID: Int?
    private var manager: SocketManager!
    private var socket: SocketIOClient!
    private var networkService = NetworkService.shared
    
    private var timer: Timer?
    private var isOpen = false
    var chatSubject = PublishSubject<ChatModel>()
    
    func startConnect(channelID: Int) {
        guard let url = URL(string: EndPoints.baseURL +
                            EndPoints.Paths.PathDepthOne.chatSocket +
                            "\(channelID)") else { return }
        
        print(url)
        
        manager = SocketManager(socketURL: url,
                                config: [.log(true),
                                         .compress,
                                         .connectParams(getConnectionParam())])
        
        socket = manager.defaultSocket
        
        openWebSocket()
        print("소켓 오픈됨")
    }
    
    func getConnectionParam() -> [String: String] {
        return [
            SecureKeys.Headers.auth : SecureKeys.Headers.accessToken,
            SecureKeys.Headers.Headerkey : SecureKeys.APIKey.secretKey
        ]
    }
    
    func openWebSocket() {
        socket.removeAllHandlers()
        socket.disconnect()
        socket.connect()
        
        socket.on(clientEvent: .connect) { data, ack in
            print("socket 연결됨", data, ack)
        }
        
        socket.on("channel") { dataArray, ack in
            print("수신됨")
        }
        
//        socket.on("channel") { data, ack in
//            print("수신중")
//            let a = data
//            guard let dict = data.first else { return }
//            print("수신된 데이터", dict)
//            do {
//                let jsonData = try JSONSerialization.data(withJSONObject: dict)
//                let response = try JSONDecoder().decode(ChatModel.self, from: jsonData)
//                print("수신된 데이터:", response)
//            } catch {
//                print(error)
//            }
//        }
    }
    
    func closeWebSocket() {
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("disconnect됨")
        }
        socket.removeAllHandlers()
        socket.disconnect()
    }
    
    func sendMessage(data: ChatModel) {
        socket.emit("channel", data)
    }
}
