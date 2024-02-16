//
//  ChannelChatTypeFeature.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift


final class ChatViewModel {
    
    private let networkService = NetworkService.shared
    private let repository = RealmRepository.shared
    
    private var workSpaceID: Int
    private var channelName: String
    private var channelID: Int
    private var task: Results<Channel>?
    
    private let chatMessage = BehaviorSubject(value: "")
    private let disposeBag = DisposeBag()
    var currentChattingRelay = BehaviorRelay<[ChannelDataSource]>(value: [])
    
    init(iD: Int, channelName: String, channelID: Int) {
        
        self.workSpaceID = iD
        self.channelName = channelName
        self.channelID = channelID
        fetchRealmData()
        loadRecentChats()
    }
    
    private func fetchRealmData() {
        self.task = repository.fetchStoredChatData(workspaceID: workSpaceID,
                                                   channelID: channelID)
        repository.checkRealmDirectory()
    }
    
    private func loadRecentChats() {
        guard let safeTask = task,
                let target = safeTask.first?.chatDataArray else { return }
        if target.count > 50 {
            let arrayConverted = Array(target.suffix(50))
            currentChattingRelay.accept(arrayConverted)
        } else {
            currentChattingRelay.accept(target)
        }
        print(target.count, "target의 count")
    }
    
    private func getCursorDate() -> String {
        return task?.first?.chatDataArray.last?.createdAt ?? getCurrentTimeForCursor()
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
                var messages = owner.currentChattingRelay.value
                let data = ChannelDataSource(chatData: response)
                messages.append(data)
                owner.currentChattingRelay.accept(messages)
                
                guard let _ = owner.task else {
                    owner.repository.createNewChannelChat(workspaceID: self.workSpaceID,
                                                          chatData: response)
                    owner.fetchRealmData()
                    return
                }
                let channelDatasource = ChannelDataSource(chatData: response)
                owner.repository.updateChannelChatDatabse(workspaceID: self.workSpaceID,
                                                    channelID: self.channelID,
                                                    newDatas: [channelDatasource])
            case .failure(let error) :
                print(error.errorCode)
            }
        }
        .disposed(by: disposeBag)
    }
    
    func getCurrentTimeForCursor() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        let now = Date()
        print(formatter.string(from: now))
        return formatter.string(from: now)
    }
    
    func judgeSender(sender: Int, userID: Int) -> Bool {
        return sender == userID ? true : false
    }
    
    // MARK: - 최근 채팅 로드 + 기존 채팅내역에 업데이트 // Cursor Date 사용
    func loadChatLog(completion: @escaping () -> Void ) {
        let id = IDRequiredRequest(id: self.workSpaceID)
        let name = NameRequest(name: self.channelName)
        let cursurDate = ChatCursorDateRequest(cursor: self.getCursorDate())

        networkService
            .fetchRequest(endpoint: .joinToChannelChat(id: id,
                                                       name: name,
                                                       cursor: cursurDate),
                          decodeModel: [ChatModel].self)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let chat):
                    if !chat.isEmpty {
                        var current = owner.currentChattingRelay.value
                        for i in chat {
                            let data = ChannelDataSource(chatData: i)
                            current.append(data)
                        }
                        owner.currentChattingRelay.accept(current)
                        completion()
                        guard let _ = owner.task else { return }
                        owner.repository.updateChannelChatDatabse(workspaceID: owner.workSpaceID,
                                                            channelID: owner.channelID,
                                                            newDatas: current)
                    }
                    
                case.failure(let error):
                    print(error.errorCode)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func createChannelID() -> Int {
        return self.channelID
    }
    
    deinit {
        print("ChatManager Deinit됨")
    }
}
