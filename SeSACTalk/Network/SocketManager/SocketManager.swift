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
    private let networkService = NetworkService.shared
    private var workspaceID: Int
    private var channelID: Int
    private var isOpen = false
    
    init(workspaceID: Int, channelID: Int) {
        
        self.workspaceID = workspaceID
        self.channelID = channelID
        
        guard let url = URL(string: EndPoints.baseURL +
                            EndPoints.Paths.PathDepthOne.chatSocket +
                            "\(channelID)") else { return }
                
        manager = SocketManager(socketURL: url,
                                config: [.compress,
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
