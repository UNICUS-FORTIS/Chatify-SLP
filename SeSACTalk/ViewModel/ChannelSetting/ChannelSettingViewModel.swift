//
//  ChannelSettingViewModel.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/19/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ChannelSettingViewModel {
    
    private let session = LoginSession.shared
    private let networkService = NetworkService.shared
    private var channelInfo: Channels
    private let disposeBag = DisposeBag()
    var sectionExpender = true
    
    let userModelsRelay = BehaviorRelay<[UserModel]>(value: [])
    
    init(channelInfo: Channels) {
        self.channelInfo = channelInfo
        fetchChannelMemebers()
    }
    
    func fetchChannelMemebers() {
        
        let path = IDwithWorkspaceIDRequest(name: channelInfo.name,
                                            id: channelInfo.workspaceID)
        networkService.fetchRequest(endpoint: .loadChannelMemebers(path: path),
                                    decodeModel: [UserModel].self)
        .subscribe(with: self) { owner, result in
            switch result {
            case .success(let models):
                owner.userModelsRelay.accept(models)
                
            case .failure(let error):
                print(error.errorCode)
            }
        }
        .disposed(by: disposeBag)
    }
    
    func makeNumberOfItemInsection() -> Int {
        return userModelsRelay.value.count
    }
    
    func makeMemberCount() -> Int {
        return sectionExpender ? userModelsRelay.value.count : 0
    }
    
    func toggleExpender() {
        sectionExpender.toggle()
    }
    
    func makeWorkspaceID() -> Int {
        return channelInfo.workspaceID
    }

    func makeChannelInfo() -> Channels {
        return channelInfo
    }
    
    func checkChannelOwner() -> Bool {
        return session.makeUserID() == channelInfo.ownerID
    }
    
    deinit{
        print("채널 세팅 뷰모델 Deinit")
    }
}

