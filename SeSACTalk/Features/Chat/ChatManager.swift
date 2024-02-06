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
    private var workSpaceID: Int
    private var channelName: String
    private var cursor: String?
    private let chatMessage = BehaviorSubject(value: "")
    var chatDatasRelay = BehaviorRelay<[ChatModel]>(value: [])
    var recentChatDatas = [ChatModel]()
    private let disposeBag = DisposeBag()
    
    init(iD: Int, channelName: String) {
        
        self.workSpaceID = iD
        self.channelName = channelName
        self.cursor = nil
        
    }
    
    func setNavigationAppearance(with: UIViewController, right: Selector?) {
        guard let right = right else { return }
        with.navigationController?.setChannelChatNavigation(target: with,
                                                            rightAction: right)
    }
    
    func startSocketConnect() {
        
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
    
//    func mockUP() {
//        print("챗매니저 이니셜라이즈드")
//        let model1 = ChatModel(channelID: 1,
//                  channelName: "으아아",
//                  chatID: 1,
//                  content: "안뇽",
//                  createdAt: "2023-12-21T22:47:30.236Z",
//                  files: [],
//                  user: UserModel(userID: 1,
//                                  email: "ddd@sss.com",
//                                  nickname: "Louie Dummy",
//                                  profileImage: nil))
//        
//        let model2 = ChatModel(channelID: 1,
//                  channelName: "으아아",
//                  chatID: 1,
//                  content: "안뇽ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ",
//                  createdAt: "2023-12-21T22:47:30.236Z",
//                  files: [],
//                  user: UserModel(userID: 1,
//                                  email: "ddd@sss.com",
//                                  nickname: "Louie Dummy",
//                                  profileImage: nil))
//        
//        let model3 = ChatModel(channelID: 1,
//                  channelName: "으아아",
//                  chatID: 1,
//                  content: "안뇽에브브베으베으ㅔ븡레브ㅔㅡ베으ㅔ브ㅔ에브브베으베으ㅔ븡레브ㅔㅡ베으ㅔ브ㅔ에브브베으베으ㅔ븡레브ㅔㅡ베으ㅔ브ㅔ에브브베으베으ㅔ븡레브ㅔㅡ베으ㅔ브ㅔ에브브베으베으ㅔ븡레브ㅔㅡ베으ㅔ브ㅔ에브브베으베으ㅔ븡레브ㅔㅡ베으ㅔ브ㅔ에브브베으베으ㅔ븡레브ㅔㅡ베으ㅔ브ㅔ에브브베으베으ㅔ븡레브ㅔㅡ베으ㅔ브ㅔ에브브베으베으ㅔ븡레브ㅔㅡ베으ㅔ브ㅔ에브브베으베으ㅔ븡레브ㅔㅡ베으ㅔ브ㅔㅇ",
//                  createdAt: "2023-12-21T22:47:30.236Z",
//                  files: [],
//                  user: UserModel(userID: 1,
//                                  email: "ddd@sss.com",
//                                  nickname: "Louie Dummy",
//                                  profileImage: nil))
//        
//        recentChatDatas.append(model1)
//        recentChatDatas.append(model2)
//        recentChatDatas.append(model3)
//
//        chatDatasRelay.accept(recentChatDatas)
//    }
}
