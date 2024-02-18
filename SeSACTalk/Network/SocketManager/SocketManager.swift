//
//  SocketManager.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/6/24.
//

import Foundation
import SocketIO
import RxSwift
import RxCocoa
import RealmSwift


final class SocketIOManager: NSObject {

    private var manager: SocketManager!
    private var socket: SocketIOClient!
    
    var workspaceID: Int?
    var channelName: String?
    var channelID: Int?
    var dmID: Int?
    var roomdID: Int?
    
    private let networkService = NetworkService.shared
    private let repository = RealmRepository.shared
    private var task: Results<Channel>?
    private let disposeBag = DisposeBag()

    var channelChatRelay = BehaviorRelay<[ChannelDataSource]>(value: [])
    var dmChatRelay = BehaviorRelay<[String]>(value: [])
    
    init(workspaceID: Int, channelID: Int, channelName: String ) {
        super.init()
        self.workspaceID = workspaceID
        self.channelID = channelID
        self.channelName = channelName
        self.dmID = nil
        self.roomdID = nil
        
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
                let data = ChannelDataSource(chatData: decoded)
                messages.append(data)
                self.channelChatRelay.accept(messages)
                
                guard let _ = self.task else {
                    self.repository.createNewChannelChat(workspaceID: workspaceID,
                                                    chatData: decoded)
                    self.task = self.repository.fetchStoredChatData(workspaceID: workspaceID,
                                                          channelID: channelID)
                    return
                }
                let channelDatasource = ChannelDataSource(chatData: decoded)
                self.repository.updateChannelChatDatabse(workspaceID: workspaceID,
                                                    channelID: channelID,
                                                    newDatas: [channelDatasource])
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
        
        repository.checkRealmDirectory()
        
        task = repository.fetchStoredChatData(workspaceID: workspaceID,
                                              channelID: channelID)
        loadRecentChatFromDatabse()
    }
   
    deinit {
        print("소켓매니저 Deinit됨")
    }
}

extension SocketIOManager: ChatProtocol {
    
    func createSocketURL() -> String {
        return EndPoints.baseURL +
        EndPoints.Paths.PathDepthOne.chatSocket + "\(channelID ?? 00)"
    }
    
    func messageSender<T>(request: T) {
        guard let workspaceID = workspaceID,
              let channelName = channelName else { return }
        guard let casted = request as? ChatBodyRequest else { return }
        let workspaceIDRequest = IDRequiredRequest(id: workspaceID)
        let channelNameRequest = NameRequest(name: channelName)
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
        
    func createSocketNamespace() -> String {
        guard let channelID = channelID else { return "" }
        return "/ws-channel-" + "\(channelID)"
    }
    
    func loadChatLog(completion: @escaping () -> Void) {
        print(#function)
        guard let workspaceID = workspaceID,
              let channelID = channelID,
              let channelName = channelName else { return }
        let id = IDRequiredRequest(id: workspaceID)
        let name = NameRequest(name: channelName)
        let cursurDate = ChatCursorDateRequest(cursor: self.getCursorDate())
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
                        for i in chat {
                            let data = ChannelDataSource(chatData: i)
                            current.append(data)
                        }
                        owner.channelChatRelay.accept(current)
                        guard let _ = owner.task else { return }
                        owner.repository.updateChannelChatDatabse(workspaceID: workspaceID,
                                                                  channelID: channelID,
                                                                  newDatas: current)
                    }
                    completion()
                    
                case.failure(let error):
                    print(error.errorCode)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func getCursorDate() -> String {
        return task?.first?.chatDataArray.last?.createdAt ?? getCurrentTimeForCursor()
    }
    
    func checkRelayIsEmpty() -> Bool {
        print(#function)
        print("엠티", channelChatRelay.value.isEmpty)
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
        print(target.count, "target의 count")
    }
    
    func connectSocket() {
        socket.connect()
    }
    
    func disconnectSocket() {
        socket.removeAllHandlers()
        socket.disconnect()
    }
}
