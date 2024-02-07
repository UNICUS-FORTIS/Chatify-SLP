//
//  ChannelChatTypeFeature.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/31/24.
//

import UIKit
import RxSwift
import RxCocoa


final class ChatManager {
    
    private let networkService = NetworkService.shared
    let socketManager = SocketIOManager.shared
    private var workSpaceID: Int
    private var channelName: String
    private var channelID: Int
    private var cursor: String?
    private let chatMessage = BehaviorSubject(value: "")
    var chatDatasRelay = BehaviorRelay<[ChatModel]>(value: [])
    var recentChatDatas = [ChatModel]()
    private let disposeBag = DisposeBag()
    
    init(iD: Int, channelName: String, channelID: Int) {
        
        self.workSpaceID = iD
        self.channelName = channelName
        self.channelID = channelID
        self.cursor = nil
        
    }
    
    func setNavigationAppearance(with: UIViewController, right: Selector?) {
        guard let right = right else { return }
        with.navigationController?.setChannelChatNavigation(target: with,
                                                            rightAction: right)
    }
    
    func messageSender(request: ChatBodyRequest) {
        let workspaceID = IDRequiredRequest(id: self.workSpaceID)
        let channelName = NameRequest(name: self.channelName)
        networkService.fetchRequest(endpoint: .sendChannelChat(id: workspaceID,
                                                               name: channelName,
                                                               contents: request), decodeModel: ChatModel.self)
        .subscribe(with: self) { owner, result in
            switch result {
            case .success(let response) :
                var messages = owner.chatDatasRelay.value
                messages.append(response)
                owner.chatDatasRelay.accept(messages)
                print(response)
                
            case .failure(let error) :
                print(error.errorCode)
            }
        }
        .disposed(by: disposeBag)
    }
    
    func judgeSender(sender: Int, userID: Int) -> Bool {
        return sender == userID ? true : false
    }
    
    func loadChatLog() {
        let id = IDRequiredRequest(id: self.workSpaceID)
        let name = NameRequest(name: self.channelName)
        //        guard let safeCursor = self.cursor else { return }
        //        let curserDate = ChatCursorDateRequest(cursor: safeCursor)
        networkService
            .fetchRequest(endpoint: .joinToChannelChat(id: id,
                                                       name: name),
                          decodeModel: [ChatModel].self)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let chat):
                    owner.chatDatasRelay.accept(chat)
                    print(chat)
                case.failure(let error):
                    print(error.errorCode)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func fetchUnreadDatas() {
        
    }
    
    func appendNewChat() {
        
    }
    
    func createChannelID() -> Int {
        return self.channelID
    }
    
    deinit {
        print("ChatManager Deinit됨")
    }
}
