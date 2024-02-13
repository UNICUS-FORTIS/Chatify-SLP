//
//  ProfileViewModel.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/11/24.
//

import Foundation
import RxSwift
import RxCocoa


final class ProfileViewModel {
    
    private let session = LoginSession.shared
    private let networkService = NetworkService.shared
    var profileDataRelay = BehaviorRelay<[ProfileDataModel]>(value: [])
    private let disposeBag = DisposeBag()
    private var currentProfileImgURL: String?
    private var currentProfileEmail: String?
    var profileImageData = PublishSubject<Data>()
    
    init() {
        
        session.myProfile
            .subscribe(with: self) { owner, profile in
                guard let safe = profile else { return }
                owner.makeProfileDatas(profile: safe)
                owner.makeProfileURL(profile: safe)
                owner.createEmailInfo(profile: safe)
            }
            .disposed(by: disposeBag)
        
    }
    
    func makeProfileURL(profile: MyProfileResponse) {
        currentProfileImgURL = profile.profileImage
    }
    
    func createEmailInfo(profile: MyProfileResponse) {
        currentProfileEmail = profile.email
    }
    
    func makeEmailInfo() -> String {
        guard let safe = currentProfileEmail else { return "" }
        return safe
    }
    
    func makeProfileURL() -> String? {
        guard let safe = currentProfileImgURL else { return nil }
        return safe
    }
    
    func makeProfileDatas(profile: MyProfileResponse) {
        
        let coinString = String(describing: profile.sesacCoin ?? 0)
        
        let coinInfo = ProfileDataModel(title: AccountInformation.myCoin.title,
                                        value: coinString)
        
        let nickname = ProfileDataModel(title: AccountInformation.nickname.title,
                                        value: profile.nickname)
        
        let contact = ProfileDataModel(title: AccountInformation.contact.title,
                                       value: profile.phone ?? "")
        
        profileDataRelay.accept([coinInfo, nickname, contact])
    }
    
 
    
    func fetchNewProfileImage() {
        profileImageData
            .flatMapLatest { data -> Single<Result<MyProfileResponse, ErrorResponse>> in
                let request = ImageUpdateRequest(image: data)
                return self.networkService.fetchRequest(endpoint: .updateProfileImage(image: request), decodeModel: MyProfileResponse.self)
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
        print("프로필 뷰모델 deinit 됨")
    }
}
