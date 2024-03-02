//
//  DMSocketManager.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/27/24.
//


import Foundation
import SocketIO
import RxSwift
import RxCocoa
import RealmSwift


final class DMSocketManager: NSObject {
    
    private var manager: SocketManager?
    private var socket: SocketIOClient?
    
    var channelInfo: Channels?
    
    private let networkService = NetworkService.shared
    private let repository = DMRealmRepository.shared
    private let session = LoginSession.shared
    private var task: Results<DM>?
    private let disposeBag = DisposeBag()
    
    var channelChatRelay = BehaviorRelay<[ChannelDataSource]>(value: [])
    var dmChatRelay = BehaviorRelay<[DMDataSource]>(value: [])
    var titlenameRelay = BehaviorRelay<String>(value: "")
    var dmRoomInfo: DMRoomInfo?
    var temporaryChats = [DMDataSource]()
    var cursorDate: String?
    var scroller: ( ()  -> Void )?
    
    init(dmInfo: DMs) {
        super.init()
        self.dmRoomInfo = DMRoomInfo(roomID: dmInfo.roomID, workspaceID: dmInfo.workspaceID)
        self.titlenameRelay.accept(dmInfo.user.nickname)
        startDM(targetUserID: dmInfo.user.userID, workspaceID: dmInfo.workspaceID)
    }
    
    init(targetUserID: Int, workspaceID: Int, nickname: String) {
        super.init()
        self.titlenameRelay.accept(nickname)
        startDM(targetUserID: targetUserID, workspaceID: workspaceID)
    }
    
    func startDM(targetUserID: Int, workspaceID: Int) {
        let workspace = IDRequiredRequest(id: workspaceID)
        let target = IDRequiredRequest(id: targetUserID)
        let cursor = ChatCursorDateRequest(cursor: self.getCursorDate(workspaceID: workspaceID,
                                                                      withUserID: targetUserID))
        networkService.fetchRequest(endpoint: .loadDMChats(workspaceID: workspace,
                                                           targetUserID: target,
                                                           cursor: cursor), decodeModel: DMChatResponse.self)
        .subscribe(with: self) { owner, result in
            if owner.dmRoomInfo == nil {
                owner.session.reloadDMInfo()
            }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.dmRoomInfo = DMRoomInfo(roomID: response.roomID, workspaceID: response.workspaceID)
                    owner.task = owner.repository.fetchDMDatas(dmRoomID: response.roomID,
                                                               workspaceID: response.workspaceID)
                    owner.loadRecentChatFromDatabse()
                    if !response.chats.isEmpty {
                        owner.repository.updateUnreadDM(dm: response)
                        let newDatas = response.chats.map { DMDataSource(dm: $0) }
                        var currentData = owner.dmChatRelay.value
                        currentData.append(contentsOf: newDatas)
                        owner.dmChatRelay.accept(currentData)
                        owner.scroller?()
                    }
                    owner.scroller?()
                }
                
                guard let url = URL(string: EndPoints.baseURL +
                                    EndPoints.Paths.PathDepthOne.dmSocket +
                                    "\(response.roomID)") else { return }
                
                owner.manager = SocketManager(socketURL: url,
                                              config: [.compress,
                                                       .forceWebsockets(true)])
                
                owner.socket = owner.manager?.socket(forNamespace: "/ws-dm-" + "\(response.roomID)")
                
                owner.socket?.on(clientEvent: .ping) { data, ack in
                    print("ping")
                }
                
                owner.socket?.on(clientEvent: .disconnect) { data, ack in
                    print("SOCKET IS DISCONNECTED", data, ack)
                }
                
                owner.socket?.on("dm") { dataArray, ack in
                    guard let received = dataArray.first as? [String: Any],
                          let roomInfo = self.dmRoomInfo else { return }
                    do {
                        let serialized = try JSONSerialization.data(withJSONObject:received)
                        let decoded = try JSONDecoder().decode(DMChatModel.self,from: serialized)
                        print(decoded)
                        var messages = self.dmChatRelay.value
                        let dmDatasource = DMDataSource(dm: decoded)
                        messages.append(dmDatasource)
                        self.dmChatRelay.accept(messages)
                        self.repository.updateDM(workspaceID: roomInfo.workspaceID,
                                                 dm: decoded)
                    }
                    catch {
                        print(error)
                    }
                    
                    owner.connectSocket()
                }
                
            case .failure(let error):
                print(error.errorCode)
            }
        }
        .disposed(by: disposeBag)
    }
    
    deinit {
        print("소켓매니저 Deinit됨")
    }
}

extension DMSocketManager: ChatProtocol {
    
    func messageSender<T>(request: T) {
        guard let casted = request as? ChatBodyRequest,
              let safeDMInfo = dmRoomInfo else { return }
        let workspaceIDRequest = IDRequiredRequest(id: safeDMInfo.workspaceID)
        let dmRoomIDRequest = IDRequiredRequest(id: safeDMInfo.roomID)
        networkService.fetchStatusCodeRequest(endpoint: .sendDMsChat(workspaceID: workspaceIDRequest,
                                                                     roomID: dmRoomIDRequest,
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
        guard let _ = self.task else { return }
        completion()
    }
    
    func getCursorDate(workspaceID: Int, withUserID: Int) -> String {
        return repository.getDMLatestChatData(workspaceID: workspaceID,
                                              userID: withUserID) ?? getCurrentTimeForCursor()
    }
    
    func getCursorDate(channelInfo: Channels) -> String { return "" }
    
    func checkRelayIsEmpty() -> Bool {
        return dmChatRelay.value.isEmpty
    }
    
    func loadRecentChatFromDatabse() {
        print(#function)
        guard let safeTask = task,
              let target = safeTask.first?.dmDataArray else { return }
        if target.count > 50 {
            let arrayConverted = Array(target.suffix(50))
            dmChatRelay.accept(arrayConverted)
        } else {
            dmChatRelay.accept(target)
        }
    }
    
    func connectSocket() {
        socket?.connect()
    }
    
    func disconnectSocket() {
        socket?.removeAllHandlers()
        socket?.disconnect()
    }
}
