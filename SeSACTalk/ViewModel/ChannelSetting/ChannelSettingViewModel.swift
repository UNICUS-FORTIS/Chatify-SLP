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
    let userModelsRelay = BehaviorRelay<[UserModel]>(value: [])
    var channelInfoRelay = PublishRelay<Channels>()
    private let disposeBag = DisposeBag()

    var channelInfo: Channels
    var sectionExpender = true

    init(channelInfo: Channels) {
        self.channelInfoRelay.accept(channelInfo)
        self.channelInfo = channelInfo
        
        channelInfoRelay
            .subscribe(with: self) { owner, channels in
                self.channelInfo = channels
            }
            .disposed(by: disposeBag)
        
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
    
    func checkChannelManagerModifiable() -> Bool {
        return userModelsRelay.value.count > 1 ? true : false
    }
    
    func acceptChannelInfoRelay(channel: Channels) {
        self.channelInfoRelay.accept(channel)
    }
    
    deinit{
        print("채널 세팅 뷰모델 Deinit")
    }
}

