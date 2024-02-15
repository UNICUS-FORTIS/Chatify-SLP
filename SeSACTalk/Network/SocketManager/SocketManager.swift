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
        
    private var manager: SocketManager!
    private var socket: SocketIOClient!
    private var networkService = NetworkService.shared
    private var workspaceID: Int
    private var channelID: Int
    private var timer: Timer?
    private var isOpen = false
    var chatSubject = PublishSubject<ChatModel>()
    
    init(workspaceID: Int, channelID: Int) {
        
        self.workspaceID = workspaceID
        self.channelID = channelID
        
        guard let url = URL(string: EndPoints.baseURL +
                            EndPoints.Paths.PathDepthOne.chatSocket +
                            "\(channelID)") else { return }
                
        manager = SocketManager(socketURL: url,
                                config: [.log(true),
                                         .compress,
                                         .forceWebsockets(true)])
        
        socket = manager.socket(forNamespace: "/ws-channel-" + "\(channelID)")
        
        socket.on("channel") { dataArray, ack in
            print("🏷️🏷️🏷️ channel", dataArray, ack)
        }
        
        socket.on(clientEvent: .ping) { data, ack in
            print("data")
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED", data, ack)
        }
    }

    func connectSocket() {
        socket.connect()
    }

    func disconnectSocket() {
        socket.removeAllHandlers()
        socket.disconnect()
    }
}
