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
    
    private let networkService = NetworkService.shared
    private var workspaceID: Int
    private var channelName: String
    private let disposeBag = DisposeBag()
    var sectionExpender = true
    
    let userModelsRelay = BehaviorRelay<[UserModel]>(value: [])
    
    init(workspaceID: Int, channelName: String) {
        self.workspaceID = workspaceID
        self.channelName = channelName
        fetchChannelMemebers()
    }
    
    func fetchChannelMemebers() {
        
        let path = IDwithWorkspaceIDRequest(name: self.channelName,
                                            id: self.workspaceID)
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
    
    
}

