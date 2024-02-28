//
//  SocketIOManager.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/6/24.
//

import Foundation
import SocketIO
import RxSwift
import RxCocoa
import RealmSwift


final class ChatSocketManager: NSObject {

    private var manager: SocketManager!
    private var socket: SocketIOClient!
    
    var channelInfo: Channels?
    var dmRoomInfo: DMRoomInfo?
    
    private let networkService = NetworkService.shared
    private let repository = RealmRepository.shared
    private var task: Results<Channel>?
    private let disposeBag = DisposeBag()

    var channelChatRelay = BehaviorRelay<[ChannelDataSource]>(value: [])
    var dmChatRelay = BehaviorRelay<[DMDataSource]>(value: [])
    
    init(channelInfo: Channels) {
        super.init()
        self.channelInfo = channelInfo
        
        guard let url = URL(string: createSocketURL()) else { return }
        manager = SocketManager(socketURL: url,
                                config: [.compress,
                                         .forceWebsockets(true)])
        
        socket = manager.socket(forNamespace: createSocketNamespace())
        socket.on("channel") { dataArray, ack in
            print("🏷️🏷️🏷️ channel")
            guard let received = dataArray.first as? [String: Any] else { return }
            do {
                let serialized = try JSONSerialization.data(withJSONObject:received)
                let decoded = try JSONDecoder().decode(ChatModel.self,from: serialized)
                print(decoded)
                var messages = self.channelChatRelay.value
                let channelDatasource = ChannelDataSource(chatData: decoded)
                messages.append(channelDatasource)
                self.channelChatRelay.accept(messages)
                self.repository.updateChannelChatDatabse(workspaceID: channelInfo.workspaceID,
                                                         channelID: channelInfo.channelID,
                                                    newDatas: [channelDatasource])
                guard let _ = self.task else {
                    self.task = self.repository.fetchStoredChatData(workspaceID: channelInfo.workspaceID,
                                                                    channelID: channelInfo.channelID)
                    return
                }
            }
            catch {
                print(error)
            }
        }
        
        socket.on(clientEvent: .ping) { data, ack in
            print("ping")
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED", data, ack)
        }
        
        task = repository.fetchStoredChatData(workspaceID: channelInfo.workspaceID,
                                              channelID: channelInfo.channelID)
        loadRecentChatFromDatabse()
    }
   
    deinit {
        print("소켓매니저 Deinit됨")
    }
}

extension ChatSocketManager: ChatProtocol {
    
    func messageSender<T>(request: T) {
        guard let safeChannel = channelInfo else { return }
        guard let casted = request as? ChatBodyRequest else { return }
        let workspaceIDRequest = IDRequiredRequest(id: safeChannel.workspaceID)
        let channelNameRequest = NameRequest(name: safeChannel.name)
        networkService.fetchStatusCodeRequest(endpoint: .sendChannelChat(id: workspaceIDRequest,
                                                                         name: channelNameRequest,
                                                                         contents: casted))
        .subscribe(with: self) { owner, result in
            switch result {
            case .success(let statuscode) :
                print(statuscode)
            case .failure(let error) :
                print(error.errorCode)
            }
        }
        .disposed(by: disposeBag)
    }
    
    func loadChatLog(completion: @escaping () -> Void) {
        print(#function)
        guard let safeChannel = channelInfo else { return }
        let id = IDRequiredRequest(id: safeChannel.workspaceID)
        let name = NameRequest(name: safeChannel.name)
        let cursurDate = ChatCursorDateRequest(cursor: self.getCursorDate(channelInfo: safeChannel))
        print("커서 데이트", cursurDate.cursor)
        networkService
            .fetchRequest(endpoint: .joinToChannelChat(id: id,
                                                       name: name,
                                                       cursor: cursurDate),
                          decodeModel: [ChatModel].self)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let chat):
                    if !chat.isEmpty {
                        var current = owner.channelChatRelay.value
                        var newDatas:[ChannelDataSource] = []
                        for i in chat {
                            let data = ChannelDataSource(chatData: i)
                            current.append(data)
                            newDatas.append(data)
                        }
                        dump(newDatas)
                        owner.channelChatRelay.accept(current)
                        owner.repository.updateChannelChatDatabse(workspaceID: safeChannel.workspaceID,
                                                                  channelID: safeChannel.channelID,
                                                                  newDatas: newDatas)
                    }
                    completion()
                    
                case.failure(let error):
                    print(error.errorCode)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func getCursorDate(channelInfo: Channels) -> String {
        return repository.getChannelLatestChatDate(channelInfo: channelInfo) ?? getCurrentTimeForCursor()
    }
    
    func checkRelayIsEmpty() -> Bool {
        return channelChatRelay.value.isEmpty
    }
    
    func loadRecentChatFromDatabse() {
        print(#function)
        guard let safeTask = task,
              let target = safeTask.first?.chatDataArray else { return }
        if target.count > 50 {
            let arrayConverted = Array(target.suffix(50))
            channelChatRelay.accept(arrayConverted)
        } else {
            channelChatRelay.accept(target)
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
