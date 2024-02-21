//
//  File.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/29/24.
//

import Foundation
import RxSwift
import RxCocoa


final class ChannelAddViewModel {
    
    private let session = LoginSession.shared
    private let networkService = NetworkService.shared
    let channelNameSubject = PublishSubject<String>()
    let channelDescriptionSubject = BehaviorSubject<String>(value: "")
    let errorReceiver = PublishRelay<Notify>()
    let completionSubject = PublishRelay<Notify>()
    var completionHandeler: ( (Channels) -> Void )?
    var dismissTrigger: ( ()-> Void )?
    private let disposeBag = DisposeBag()
    
    
    var form: Observable<ChannelAddRequest> {
        return Observable
            .combineLatest(channelNameSubject, channelDescriptionSubject) {
                name, description in
                return ChannelAddRequest(name: name, description: description)
            }
    }
    
    func createNewChannel(form: ChannelAddRequest) {
        let idRequest = IDRequiredRequest(id: session.makeWorkspaceID())
        networkService.fetchStatusCodeRequest(endpoint: .createChannel(id: idRequest, model: form))
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(_):
                    owner.session.fetchMyChannelInfo()
                    owner.completionSubject.accept(.createChannels(.success))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                        owner.dismissTrigger?()
                    }
                case .failure(let error):
                    if let errorcase = CreateChannelErrors(rawValue: error.errorCode) {
                        owner.errorReceiver.accept(.createChannels(errorcase))
                        print(error.errorCode)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    func fetchEditChannelInfo(name: String, form: ChannelAddRequest) {
        let id = IDRequiredRequest(id: session.makeWorkspaceID())
        let name = NameRequest(name: name)
        networkService.fetchRequest(endpoint: .editChannelInfo(id: id,
                                                               name: name,
                                                               model: form),
                                    decodeModel: Channels.self)
        .subscribe(with: self) { owner, result in
            switch result {
            case .success(let channel):
                print(channel, "채널 변경완료")
                owner.session.fetchMyChannelInfo()
                owner.completionHandeler?(channel)
                
            case .failure(let error):
                print(error.errorCode)
            }
        }
        .disposed(by: disposeBag)
    }
}
