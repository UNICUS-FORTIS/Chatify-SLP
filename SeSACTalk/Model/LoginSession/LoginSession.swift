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
    private var currentWorkspaceID: Int?
    
    // MARK: - Navigation
    var leftCustomView = CustomNavigationLeftView()
    var leftCustomLabel = CustomLeftNaviLabel()
    var rightCustomView = CustomNavigationRightView()
    
    // MARK: - 응답 Response
    let myProfile = PublishSubject<MyProfileResponse>()
    let workspaceDetails = BehaviorSubject<WorkspaceInfoResponse?>(value: nil)
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
            }
            .disposed(by: disposeBag)
        
        userIDSubject.onNext(id)
        nickNameSubject.onNext(nick)
        UserDefaults.standard.setValue(access, forKey: "accessToken")
        UserDefaults.standard.setValue(refresh, forKey: "refreshToken")
        
        bind()
    }
    
    func modifyCurrentWorkspace(path: IndexPath) {
        workSpacesSubject
            .subscribe(with: self) { owner, workspace in
                guard let safe = workspace else { return }
                if owner.currentWorkspaceID != safe[path.row].workspaceID {
                    owner.currentWorkspaceSubject.onNext(safe[path.row])
                }
            }
            .disposed(by: disposeBag)
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
                guard let profileImage = profile.profileImage else {
                    self.rightCustomView.dummyImage = .dummyTypeA
                    return
                }
                self.rightCustomView.profileImage = profileImage
            }
            .disposed(by: disposeBag)
        
        currentWorkspaceSubject
            .bind(with: self) { owner, info in
                guard let safe = info else { return }
                owner.leftCustomView.data = safe.thumbnail
                owner.leftCustomLabel.buttonTitle.onNext(safe.name)
                owner.currentWorkspaceID = safe.workspaceID
            }
            .disposed(by: disposeBag)
        
        // MARK: - 워크스페이스 채널인포로드
        currentWorkspaceSubject
            .flatMapLatest { workSpaces -> Observable<Result<WorkspaceInfoResponse, ErrorResponse>> in
                guard let workSpaceID = workSpaces?.workspaceID else { return Observable.empty() }
                let id = IDRequiredRequest(id: workSpaceID)
                return self.fetchWorkspaceDetails(id: id).asObservable()
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    owner.workspaceDetails.onNext(response)
                    print("워크스페이스 디테일")
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
                    
                case .failure(let error):
                    owner.errorReceriver.onNext(error)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func numberOfChannelInfoCount() -> Int {
        let info = try? workspaceDetails.value()?.channels
        return info?.count ?? 0
    }
    
    func numberOfDmsCount() -> Int {
        let dms = try? DmsInfo.value()
        return dms?.count ?? 0
    }
    
    func fetchWorkspaceDetails(id: IDRequiredRequest) -> Single<Result<WorkspaceInfoResponse, ErrorResponse>> {
        return networkService.fetchRequest(endpoint: .loadWorkspaceDetails(workspaceID: id),
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
                switch result {
                case .success(_):
                    owner.fetchLoadWorkSpace()
                case .failure(let error):
                    print(error.errorCode)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func handoverWorkspaceManager(id: Int, receiverID: Int) {
        let request = IDwithIDRequest(id: id, receiverID: receiverID)
        networkService.fetchStatusCodeRequest(endpoint: .handoverWorkspaceManager(model: request))
            
    }
    
    func loadWorkspaceMember(id: Int, completion: @escaping () -> Void ) {
        let idRequest = IDRequiredRequest(id: id)
        networkService.fetchRequest(endpoint: .loadWorkspaceMember(id: idRequest),
                                    decodeModel: WorkspaceMemberResponse.self)
        .subscribe(with: self) { owner, result in
            switch result {
            case .success(let workspace):
                owner.workspaceMember.onNext(workspace)
                print("워크스페이스멤버 할당됨")
                completion()
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
    
    func makeWorkspaceID() -> Int {
        guard let safe = currentWorkspaceID else { return 000 }
        return safe
    }
}
