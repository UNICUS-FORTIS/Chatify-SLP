//
//  LoginSession.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/13/24.
//

import Foundation
import RxSwift
import RxCocoa


final class LoginSession {
    
    static let shared = LoginSession()
    private let networkService = NetworkService.shared
    private let userIDSubject = PublishSubject<Int>() // temp
    private let nickNameSubject = PublishSubject<String>() // temp
    private let workSpacesSubject = PublishSubject<WorkSpaces>()
    
    // MARK: - Navigation
    var leftCustomView = CustomNavigationLeftView()
    var rightCustomView = CustomNavigationRightView()
    
    // MARK: - 응답 Response
    let myProfile = PublishSubject<MyProfileResponse>()
    let channelInfo = BehaviorSubject<ChannelInfoResponse?>(value: nil)
    let DmsInfo = BehaviorSubject<DMsResponse?>(value: nil)
    let errorReceriver = PublishSubject<ErrorResponse>()
    
    
    
    private let disposeBag = DisposeBag()
    
    func handOverLoginInformation(id: Int,
                                  nick: String,
                                  access: String,
                                  refresh: String) {
        
        userIDSubject
            .subscribe(with: self) { owner, id in
                print("아이디", id)
            }
            .disposed(by: disposeBag)
        
        userIDSubject.onNext(id)
        nickNameSubject.onNext(nick)
        UserDefaults.standard.setValue(access, forKey: "accessToken")
        UserDefaults.standard.setValue(access, forKey: "refreshToken")
        
        bind()
    }
    
    func assginWorkSpaces(spaces: WorkSpaces) {
        print(#function)
        workSpacesSubject.onNext(spaces)
    }
    
    private func bind() {
        
        print(#function)
        
        myProfile
            .bind(with: self) { owner, profile in
                print("네비게이션바 프로파일", profile)
                guard let profileImage = profile.profileImage else {
                    self.rightCustomView.dummyImage = .dummyTypeA
                    return
                }
                self.rightCustomView.profileImage = profileImage
            }
            .disposed(by: disposeBag)
        
        channelInfo
            .bind(with: self) { owner, info in
                self.leftCustomView.data = info
            }
            .disposed(by: disposeBag)
        
        
        workSpacesSubject
            .flatMapLatest { workSpaces -> Observable<Result<ChannelInfoResponse, ErrorResponse>> in
                guard let workSpaceID = workSpaces.first?.workspaceID else { return Observable.empty() }
                let id = IDRequiredRequest(id: workSpaceID)
                return self.networkService.fetchChannelInfo(id: id).asObservable()
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    owner.channelInfo.onNext(response)
                    print("워크스페이스 서브젝트에 채널리스폰스 들어감",response)
                case .failure(let error):
                    owner.errorReceriver.onNext(error)
                }
            }
            .disposed(by: disposeBag)
        
        workSpacesSubject
            .flatMapLatest { workSpaces -> Observable<Result<DMsResponse, ErrorResponse>> in
                guard let workSpaceID = workSpaces.first?.workspaceID else { return Observable.empty() }
                let id = IDRequiredRequest(id: workSpaceID)
                return self.networkService.fetchDms(id: id).asObservable()
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    owner.DmsInfo.onNext(response)
                    print("아이디서브젝트에 DM 들어감",response)
                    
                case .failure(let error):
                    owner.errorReceriver.onNext(error)
                }
            }
            .disposed(by: disposeBag)
        
        networkService.fetchMyProfile()
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    owner.myProfile.onNext(response)
                    print("아이디서브젝트에 프로파일 들어감",response)
                    
                case .failure(let error):
                    owner.errorReceriver.onNext(error)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func numberOfChannelInfoCount() -> Int {
        let info = try? channelInfo.value()?.channels
        return info?.count ?? 0
    }
    
    func numberOfDmsCount() -> Int {
        let dms = try? DmsInfo.value()
        return dms?.count ?? 0
    }
}
