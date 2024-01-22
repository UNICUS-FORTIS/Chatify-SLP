//
//  WorkSpaceViewModel.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/10/24.
//

import Foundation
import RxSwift
import RxCocoa


final class EmptyWorkSpaceViewModel {
    
    private let networkService = NetworkService.shared
    private let disposeBag = DisposeBag()
    var storedNickname: String {
        if let nickname = UserDefaults.standard.string(forKey: "AppleLoginName") {
            return nickname
        } else {
            return ""
        }
    }
    
    let workspace = PublishSubject<String>()
    let workspaceImage = PublishSubject<Data>()
    let workspaceImageMounted = BehaviorSubject<Bool>(value: false)
    let spaceDescription = PublishSubject<String>()
    var HomeDefaultTrasferTrigger: (() -> Void)?
    
    var form: Observable<NewWorkSpaceRequest> {
        return Observable.combineLatest(workspace,
                                        workspaceImage,
                                        spaceDescription) {
            name, image, description in
            return NewWorkSpaceRequest(name: name, description: description, image: image)
        }
        
    }
    
    func fetchCreateWorkSpace(info: NewWorkSpaceRequest) -> Single<Result<NewWorkSpaceResponse, ErrorResponse>> {
        return networkService.fetchRequest(endpoint: .createWorkSpace(model: info),
                                           decodeModel: NewWorkSpaceResponse.self)
    }
    
}
