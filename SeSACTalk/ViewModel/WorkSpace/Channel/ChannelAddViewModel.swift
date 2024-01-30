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
    
}
