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
    private init() {}
    private let networkService = NetworkService.shared
    private let userIDSubject = PublishSubject<Int>()
    private let nickNameSubject = PublishSubject<String>() // temp
    private var userID: Int?
    private var recentVisitedWorkspace = UserDefaults.loadRecentWorkspace()
    let workSpacesSubject = BehaviorSubject<WorkSpaces?>(value: nil)
    let currentWorkspaceSubject = BehaviorSubject<WorkSpace?>(value: nil)
    
    
    // MARK: - Navigation
    var leftCustomView = CustomNavigationLeftView()
    var leftCustomLabel = CustomLeftNaviLabel()
    var rightCustomView = CustomNavigationRightView()
    
    // MARK: - 응답 Response
    let myProfile = PublishSubject<MyProfileResponse>()
    let workspaceChannelInfo = BehaviorSubject<WorkspaceInfoResponse?>(value: nil)
    let DmsInfo = BehaviorSubject<DMsResponse?>(value: [])
    let workspaceMember = BehaviorSubject<WorkspaceMemberResponse?>(value: [])
    let errorReceriver = PublishSubject<ErrorResponse>()
    
    private let disposeBag = DisposeBag()
    
    func handOverLoginInformation(id: Int,
                                  nick: String,
                                  access: String,
                                  refresh: String) {
        userIDSubject
            .asDriver(onErrorJustReturn: 000)
            .drive(with: self) { owner, id in
                owner.userID = id
                print("ID 할당됨", id)
            }
            .disposed(by: disposeBag)
        
        userIDSubject.onNext(id)
        nickNameSubject.onNext(nick)
        UserDefaults.standard.setValue(access, forKey: "accessToken")
        UserDefaults.standard.setValue(refresh, forKey: "refreshToken")
        
        bind()
    }
    
    func assginWorkSpaces(spaces: WorkSpaces) {
        print(#function)
        workSpacesSubject.onNext(spaces)
        let filtered = spaces.first { $0.workspaceID == recentVisitedWorkspace }
        guard let safeFiltered = filtered else {
            UserDefaults.createRecentWorkspace(workspaces: spaces)
            currentWorkspaceSubject.onNext(spaces.first)
            return }
        currentWorkspaceSubject.onNext(safeFiltered)
    }
    
    private func bind() {
                
        myProfile
            .bind(with: self) { owner, profile in
                print("네비게이션바 Profile")
                dump(profile)
                guard let profileImage = profile.profileImage else {
                    self.rightCustomView.dummyImage = .dummyTypeA
                    return
                }
                self.rightCustomView.profileImage = profileImage
            }
            .disposed(by: disposeBag)
        
        currentWorkspaceSubject
            .bind(with: self) { owner, info in
                guard let safeInfo = info else { return }
                owner.leftCustomView.data = safeInfo.thumbnail
                owner.leftCustomLabel.buttonTitle.onNext(safeInfo.name)
            }
            .disposed(by: disposeBag)
        
        // MARK: - 워크스페이스 채널인포로드
        currentWorkspaceSubject
            .flatMapLatest { workSpaces -> Observable<Result<WorkspaceInfoResponse, ErrorResponse>> in
                guard let workSpaceID = workSpaces?.workspaceID else { return Observable.empty() }
                let id = IDRequiredRequest(id: workSpaceID)
                return self.fetchWorkspaceChannelInfo(id: id).asObservable()
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    owner.workspaceChannelInfo.onNext(response)
                    print("채널인포 리스폰스")
                    dump(response)
                case .failure(let error):
                    owner.errorReceriver.onNext(error)
                }
            }
            .disposed(by: disposeBag)
        
        // MARK: - 워크스페이스 DMs 로드
        currentWorkspaceSubject
            .flatMapLatest { workSpaces -> Observable<Result<DMsResponse, ErrorResponse>> in
                guard let workSpaceID = workSpaces?.workspaceID else { return Observable.empty() }
                let id = IDRequiredRequest(id: workSpaceID)
                return self.fetchDms(id: id).asObservable()
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    owner.DmsInfo.onNext(response)
                    print("DM정보 할당됨")
                    dump(response)
                    
                case .failure(let error):
                    owner.errorReceriver.onNext(error)
                }
            }
            .disposed(by: disposeBag)
        
        // MARK: - 유저 프로파일 로드
        fetchMyProfile()
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    owner.myProfile.onNext(response)
                    print("myProfile 할당됨")
                    dump(response)
                    
                case .failure(let error):
                    owner.errorReceriver.onNext(error)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func numberOfChannelInfoCount() -> Int {
        let info = try? workspaceChannelInfo.value()?.channels
        return info?.count ?? 0
    }
    
    func numberOfDmsCount() -> Int {
        let dms = try? DmsInfo.value()
        return dms?.count ?? 0
    }
    
    func fetchWorkspaceChannelInfo(id: IDRequiredRequest) -> Single<Result<WorkspaceInfoResponse, ErrorResponse>> {
        return networkService.fetchRequest(endpoint: .loadWorkSpaceChannels(channel: id),
                                           decodeModel: WorkspaceInfoResponse.self)
    }
    
    func fetchDms(id: IDRequiredRequest) -> Single<Result<DMsResponse, ErrorResponse>> {
        return networkService.fetchRequest(endpoint: .loadDms(id: id),
                                           decodeModel: DMsResponse.self)
    }
    
    func fetchMyProfile() -> Single<Result<MyProfileResponse, ErrorResponse>> {
        return networkService.fetchRequest(endpoint: .loadMyProfile,
                                           decodeModel: MyProfileResponse.self)
    }
    
    func fetchLoadWorkSpace() {
        networkService.fetchRequest(endpoint: .loadWorkSpace,
                                    decodeModel: WorkSpaces.self)
        .subscribe(with: self) { owner, result in
            switch result {
            case .success(let response) :
                owner.workSpacesSubject.onNext(response)
            case .failure(let error) :
                print(error.errorCode)
            }
        }
        .disposed(by: disposeBag)
    }
    
    func removeWorkSpace(id: Int) {
        let idRequest = IDRequiredRequest(id: id)
        networkService.fetchStatusCodeRequest(endpoint: .removeWorkSpace(id: idRequest))
            .subscribe(with: self) { owner, result in
                owner.fetchLoadWorkSpace()
            }
            .disposed(by: disposeBag)
    }
    
    func leaveFromWorkspace(id:Int) {
        let idRequest = IDRequiredRequest(id: id)
        networkService.fetchStatusCodeRequest(endpoint: .leaveWorkspace(id: idRequest))
            .subscribe(with: self) { owner, result in
                owner.fetchLoadWorkSpace()
            }
            .disposed(by: disposeBag)
    }
    
    func handoverWorkspaceManager(id: Int, receiverID: Int) {
        let request = IDwithIDRequest(id: id, receiverID: receiverID)
        networkService.fetchStatusCodeRequest(endpoint: .handoverWorkspaceManager(model: request))
    }
    
    func loadWorkspaceMember(id: Int) {
        let idRequest = IDRequiredRequest(id: id)
        networkService.fetchRequest(endpoint: .loadWorkspaceMember(id: idRequest),
                                    decodeModel: WorkspaceMemberResponse.self)
        .subscribe(with: self) { owner, result in
            switch result {
            case .success(let workspace):
                owner.workspaceMember.onNext(workspace)
                
            case .failure(let error):
                print(error)
            }
        }
        .disposed(by: disposeBag)
    }
    
    func makeUserID() -> Int {
        guard let id = userID else { return 000 }
        return id
    }
}
