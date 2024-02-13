//
//  ProfileEditViewModel.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/13/24.
//

import Foundation
import RxSwift
import RxCocoa


final class ProfileEditViewModel {
    
    
    private let session = LoginSession.shared
    private let networkService = NetworkService.shared
    var profile: MyProfileResponse?
    let nicknameRelay = BehaviorRelay<String>(value: "")
    let contactRelay = BehaviorRelay<String>(value: "")
    private let disposeBag = DisposeBag()
    
    var form: Observable<ProfileUpdateRequest> {
        return Observable.combineLatest(nicknameRelay,
                                        contactRelay)
        .map { nickname, contact in
            
            return ProfileUpdateRequest(nickname: nickname,
                                        phone: contact)
        }
    }
    
    init() {
        session.myProfile
            .subscribe(with: self) { owner, profile in
                guard let safe = profile else { return }
                owner.profile = safe
            }
            .disposed(by: disposeBag)
        
        createCurrentProfile()
    }
    
    
    func createCurrentProfile() {
        guard let safe = profile else { return }
        nicknameRelay.accept(safe.nickname)
        contactRelay.accept(safe.phone ?? "")
    }
    
    func createCurrentNickname() -> String {
        guard let safe = profile else { return "" }
        return safe.nickname
    }
    
    func createCurrentContact() -> String {
        guard let safe = profile else { return "" }
        return safe.phone ?? ""
    }
    
    func fetchProfileUpdate() {
        
        form
            .flatMapLatest { profile in
                return self.networkService.fetchRequest(endpoint: .updateProfileInformations(profile: profile), decodeModel: MyProfileResponse.self)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    owner.session.myProfile.onNext(response)
                    
                case .failure(let error):
                    print(error.errorCode)
                }
            }
            .disposed(by: disposeBag)
    }
    
    deinit {
        print("ProfileEditViewModel deinit 됨")
    }
}
