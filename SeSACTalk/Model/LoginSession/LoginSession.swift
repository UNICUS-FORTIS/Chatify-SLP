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
    private init() { bind() }

    private let networkService = NetworkService.shared
    private let repository = RealmRepository.shared
    private let dmRepository = DMRealmRepository.shared
    private let userIDSubject = PublishSubject<Int>()
    private let nickNameSubject = PublishSubject<String>()
    private var userID: Int?
    private var recentVisitedWorkspace = UserDefaults.loadRecentWorkspace()
    let workSpacesSubject = BehaviorSubject<WorkSpaces?>(value: nil)
    let currentWorkspaceSubject = BehaviorSubject<WorkSpace?>(value: nil)
    private var currentWorkspaceID: Int?
    var setViewControllerActor : (() -> Void)?
    
    // MARK: - Navigation
    var leftCustomView = CustomNavigationLeftView()
    var leftCustomLabel = CustomLeftNaviLabel()
    var rightCustomView = CustomNavigationRightView()
    
    // MARK: - 응답 Response
    let myProfile = BehaviorSubject<MyProfileResponse?>(value: nil)
    let workspaceDetails = BehaviorSubject<WorkspaceInfoResponse?>(value: nil)
    let channelsInfo = BehaviorSubject<[Channels]>(value: [])
    let DmsInfo = BehaviorSubject<DMsResponse>(value: [])
    let workspaceMember = BehaviorSubject<WorkspaceMemberResponse>(value: [])
    let errorReceriver = PublishSubject<ErrorResponse>()
    
    private let disposeBag = DisposeBag()
    
    var layout: Observable<[MultipleSectionModel]> {
        return Observable.combineLatest(channelsInfo, DmsInfo)
            .map { channels, dms in
                var sections: [MultipleSectionModel] = []
                
                let channelItems = channels.map { SectionItem.channel(channel: $0) }
                let channelSection = MultipleSectionModel.channel(items: channelItems)
                sections.append(channelSection)
                
                let dmsItems = dms.map { SectionItem.dms(dms: $0) }
                let dmsSection = MultipleSectionModel.dms(items: dmsItems)
                sections.append(dmsSection)
                
                let memberSection = MultipleSectionModel.member
                sections.append(memberSection)
                
                return sections
            }
    }
    
    func handOverLoginInformation(userID: Int,
                                  nick: String,
                                  access: String,
                                  refresh: String) {
        userIDSubject
            .asDriver(onErrorJustReturn: 000)
            .drive(with: self) { owner, id in
                owner.userID = id
            }
            .disposed(by: disposeBag)
        
        userIDSubject.onNext(userID)
        nickNameSubject.onNext(nick)
        UserdefaultManager.saveNewAccessToken(token: access)
        UserdefaultManager.saveNewRefreshToken(token: refresh)
        repository.userID = userID
        dmRepository.userID = userID
        repository.createInitialUserdata()
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
// MARK: - 경로확인
        repository.checkRealmDirectory()
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
    
    func assignWorkspace(spaces: WorkSpaces) {
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
                guard let safe = profile?.profileImage else {
                    self.rightCustomView.dummyImage = .dummyTypeA
                    return
                }
                self.rightCustomView.profileImage = safe
            }
            .disposed(by: disposeBag)
        
        currentWorkspaceSubject
            .bind(with: self) { owner, info in
                guard let safe = info else { return }
                owner.currentWorkspaceID = safe.workspaceID
                owner.leftCustomView.data = safe.thumbnail
                owner.leftCustomLabel.buttonTitle.onNext(safe.name)
                owner.fetchMyChannelInfo()
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
                    
                case .failure(let error):
                    owner.errorReceriver.onNext(error)
                }
            }
            .disposed(by: disposeBag)
        
        // MARK: - 초기 데이터베이스 생성
        workSpacesSubject
            .subscribe(with: self) { owner, workspaces in
                owner.currentWorkspaceSubject.onNext(workspaces?.first)
                if workspaces?.count == 0 {
                    owner.leftCustomView = CustomNavigationLeftView()
                    owner.leftCustomLabel = CustomLeftNaviLabel()
                }
                
                guard let safe = workspaces else { return }
                DispatchQueue.main.async {
                    owner.repository.createInitialWorkspaceData(new: safe)
                    safe.forEach { workspace in /////
                        owner.createChannelDatabase(workspaceID: workspace.workspaceID)
                        owner.createDMDatabase(workspaceID: workspace.workspaceID)
                    }
                }
                
            }
            .disposed(by: disposeBag)

        channelsInfo
            .subscribe(with: self) { owner, channels in
                channels.forEach { owner.repository.createInitialChannelList(targetWorkspaceID: $0.workspaceID,
                                                                       channelID: $0.channelID) }
            }
            .disposed(by: disposeBag)
        
        DmsInfo
            .subscribe(with: self) { owner, DMS in
                DMS.forEach { owner.dmRepository.createDMRoom(dm: $0) }
            }
            .disposed(by: disposeBag)
    }
    
    func fetchWorkspaceDetails(id: IDRequiredRequest) -> Single<Result<WorkspaceInfoResponse, ErrorResponse>> {
        return networkService.fetchRequest(endpoint: .loadWorkspaceDetails(workspaceID: id),
                                           decodeModel: WorkspaceInfoResponse.self)
    }
    
    func fetchDms(id: IDRequiredRequest) -> Single<Result<DMsResponse, ErrorResponse>> {
        return networkService.fetchRequest(endpoint: .loadDms(id: id),
                                           decodeModel: DMsResponse.self)
    }
    
    func fetchStartDM(targetUserID: Int, cursorDate: String) -> Single<Result<DMChatResponse, ErrorResponse>> {
        let workspaceID = IDRequiredRequest(id: self.makeWorkspaceID())
        let target = IDRequiredRequest(id: targetUserID)
        let cursor = ChatCursorDateRequest(cursor: cursorDate)
        return networkService.fetchRequest(endpoint: .loadDMChats(workspaceID: workspaceID,
                                                                  targetUserID: target,
                                                                  cursor: cursor), decodeModel: DMChatResponse.self)
        
    }
    
    func fetchMyProfile() -> Single<Result<MyProfileResponse, ErrorResponse>> {
        print(#function)
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
    
    func removeWorkspaceDatabase(workspaceID: Int) {
        let idRequest = IDRequiredRequest(id: workspaceID)
        fetchWorkspaceDetails(id: idRequest)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    owner.repository.removeWorkspace(workspaceInfo: response) {
                        owner.fetchRemoveWorkspace(workspaceID: workspaceID)
                    }
                case .failure(let error):
                    print(error.errorCode)
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    private func fetchRemoveWorkspace(workspaceID: Int) {
        let idRequest = IDRequiredRequest(id: workspaceID)
        networkService.fetchStatusCodeRequest(endpoint: .removeWorkSpace(id: idRequest))
            .subscribe(with: self) { owner, result in
                owner.fetchLoadWorkSpace()
            }
            .disposed(by: disposeBag)
    }
    
    func removeChannel(channel: Channels) {
        let idRequest = IDRequiredRequest(id: channel.workspaceID)
        let nameRequest = NameRequest(name: channel.name)
        networkService.fetchStatusCodeRequest(endpoint: .removeChannel(id: idRequest,
                                                                       name: nameRequest))
        .subscribe(with: self) { owner, result in
            switch result {
            case .success(_):
                owner.fetchMyChannelInfo()
                
            case .failure(let error):
                print(error.errorCode)
            }
        }
        .disposed(by: disposeBag)
        
        repository.removeChannelChatting(workspaceID: channel.workspaceID,
                                         channelID: channel.channelID)
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
    
    func loadWorkspaceMember(id: Int, completion: @escaping () -> Void ) {
        let idRequest = IDRequiredRequest(id: id)
        networkService.fetchRequest(endpoint: .loadWorkspaceMember(id: idRequest),
                                    decodeModel: WorkspaceMemberResponse.self)
        .subscribe(with: self) { owner, result in
            switch result {
            case .success(let workspace):
                let new = workspace.filter { owner.makeUserID() != $0.userID }
                owner.workspaceMember.onNext(new)
                print("워크스페이스멤버 할당됨")
                completion()
            case .failure(let error):
                print(error)
            }
        }
        .disposed(by: disposeBag)
    }
    
    func fetchChannelList() -> Single<Result<[Channels], ErrorResponse>> {
        let idRequest = IDRequiredRequest(id: self.makeWorkspaceID())
        return networkService.fetchRequest(endpoint: .loadAllChannels(id: idRequest)
                                           , decodeModel: [Channels].self)
    }
    
    func createChannelDatabase(workspaceID: Int) {
        let idRequest = IDRequiredRequest(id: workspaceID)
        networkService.fetchRequest(endpoint: .loadAllChannels(id: idRequest)
                                           , decodeModel: [Channels].self)
        .subscribe(with: self) { owner, result in
            switch result {
            case .success(let channels):
                channels.forEach { channel in
                    owner.repository.createInitialChannelList(targetWorkspaceID: workspaceID,
                                                              channelID: channel.channelID)
                }
                
            case .failure(let error):
                print(error.errorCode)
                print("채널 정보 가져오지 못했음")
            }
        }
        .disposed(by: disposeBag)
    }
    
    func createDMDatabase(workspaceID: Int) {
        let idRequest = IDRequiredRequest(id: workspaceID)
        fetchDms(id: idRequest)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    
                    response.forEach { owner.dmRepository.createDMRoom(dm: $0) }
                    
                case .failure(let error):
                    print("DM 데이터베이스 작성 실패", error.errorCode)
                }
            }.disposed(by: disposeBag)
    }
    
    func fetchMyChannelInfo() {
        let idRequest = IDRequiredRequest(id: self.makeWorkspaceID())
        networkService.fetchRequest(endpoint: .loadMyChannelInfo(id: idRequest),
                                    decodeModel: [Channels].self)
        .subscribe(with: self) { owner, result in
            switch result {
            case .success(let channels):
                owner.channelsInfo.onNext(channels)
                
            case .failure(let error):
                print(error.errorCode)
            }
        }
        .disposed(by: disposeBag)
    }
    
    func fetchLeaveFromChannel(channelInfo: Channels) {
        let id = IDRequiredRequest(id: self.makeWorkspaceID())
        let name = NameRequest(name: channelInfo.name)
        networkService.fetchStatusCodeRequest(endpoint: .leaveFromChannel(id: id,
                                                                          name: name))
        .subscribe(with: self) { owner, result in
            switch result {
            case .success(_) :
                owner.fetchMyChannelInfo()
                
            case .failure(let error):
                print(error.errorCode)
            }
        }
        .disposed(by: disposeBag)
    }
    
    func fetchUnreadChannelChats(targetChannel: Channels, completion: @escaping (Int) -> Void) {
        
        guard let cursorDate = repository.getChannelLatestChatDate(channelInfo: targetChannel) else {
            completion(0)
            return
        }

        let id = IDRequiredRequest(id: self.makeWorkspaceID())
        let name = NameRequest(name: targetChannel.name)
        let after = ChatCursorDateRequest(cursor: cursorDate)
        print(after.cursor)
        networkService.fetchRequest(endpoint: .loadUnreadChannelChats(id: id,
                                                                      name: name,
                                                                      cursor: after),
                                    decodeModel: UnreadChannelChatResponse.self)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    
                    completion(response.count)
                    
                case .failure(let error):
                    print("Channel unread count 실패",error.errorCode)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func fetchUnreadDMChats(dm: DMs, completion: @escaping (Int) -> Void) {
        guard let cursorDate = dmRepository.getDMLatestChatData(workspaceID: dm.workspaceID,
                                                                userID: dm.user.userID) else {
            completion(0)
            return
        }
    print("커서데이트", cursorDate)
        let roomID = IDRequiredRequest(id: dm.roomID)
        let workspaceID = IDRequiredRequest(id: dm.workspaceID)
        let after = ChatCursorDateRequest(cursor: cursorDate)
        networkService.fetchRequest(endpoint: .loadUnreadDMChats(workspaceID: workspaceID,
                                                                 roomID: roomID,
                                                                 cursor: after),
                                    decodeModel: UnreadDMChatResponse.self)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    
                    completion(response.count)
                    
                case .failure(let error):
                    print("DM unread count 실패",error.errorCode)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func fetchLogout(completion: @escaping () -> Void) {
        networkService.fetchStatusCodeRequest(endpoint: .logout)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(_):
                    completion()
                    
                case .failure(let error):
                    print(error.errorCode)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func makeUserID() -> Int {
        guard let id = userID else { return 000 }
        return id
    }
    
    func makeUserNickname() -> String {
        do {
            guard let profile = try myProfile.value() else { return "" }
            return profile.nickname
        } catch {
            return ""
        }
    }
    
    func makeWorkspaceID() -> Int {
        guard let safe = currentWorkspaceID else { return 000 }
        return safe
    }
    
    func makeWorkspaceListCount() -> Int {
        do {
            guard let count = try workSpacesSubject.value()?.count else { return 0 }
            return count
        } catch {
            return 0
        }
    }
}
