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
    
    let session = LoginSession.shared
    private let networkService = NetworkService.shared
    private let disposeBag = DisposeBag()
    var storedNickname: String {
        if let nickname = UserDefaults.standard.string(forKey: "AppleLoginName") {
            return nickname
        } else {
            return session.makeUserNickname()
        }
    }
    
    let workspaceEditMode: WorkSpaceEditMode
    let workspaceInfoForEdit = BehaviorSubject<WorkSpace?>(value: nil)
    let workspaceThumbnail = PublishSubject<String>()
    private var workspaceID: Int?

    let workspaceName = PublishSubject<String>()
    let workspaceImage = PublishSubject<Data>()
    let workspaceImageMounted = BehaviorSubject<Bool>(value: false)
    let spaceDescription = BehaviorSubject<String>(value: "")
    var setViewControllerHandeler: ( () -> Void )?
    var editViewControllerTransferTrigger: (() -> Void)?
    var HomeDefaultTrasferTrigger: (() -> Void)?
    
    init(editMode: WorkSpaceEditMode, workspaceInfo: WorkSpace?) {
        self.workspaceEditMode = editMode
        guard let safeInfo = workspaceInfo else { return }
        print(safeInfo)
        self.bind()
        self.workspaceInfoForEdit.onNext(safeInfo)
    }
    
    var form: Observable<NewWorkSpaceRequest> {
        return Observable.combineLatest(workspaceName,
                                        workspaceImage,
                                        spaceDescription) {
            name, image, description in
            print("새로 생성된 form", NewWorkSpaceRequest(name: name, description: description, image: image))
            return NewWorkSpaceRequest(name: name, description: description, image: image)
        }
        
    }
    
    func fetchCreateWorkSpace(info: NewWorkSpaceRequest) -> Single<Result<NewWorkSpaceResponse, ErrorResponse>> {
        return networkService.fetchRequest(endpoint: .createWorkSpace(model: info),
                                           decodeModel: NewWorkSpaceResponse.self)
    }
    
    func fetchEditWorkSpace(form: NewWorkSpaceRequest) -> Single<Result<NewWorkSpaceResponse, ErrorResponse>> {
        let id = IDRequiredRequest(id: self.workspaceID ?? 000)
        return networkService.fetchRequest(endpoint: .editWorkSpace(id: id,
                                                                    model: form),
                                           decodeModel: NewWorkSpaceResponse.self)
    }
    
    func bind() {
        workspaceInfoForEdit
            .subscribe(with: self) { owner, workspace in
                guard let safe = workspace else { return }
                owner.workspaceName.onNext(safe.name)
                owner.workspaceThumbnail.onNext(safe.thumbnail)
                owner.spaceDescription.onNext(safe.description)
                owner.workspaceID = safe.workspaceID
            }
            .disposed(by: disposeBag)
    }
    deinit {
        print("엠티 워크스페이스 뷰모델 Deinit됨")
    }
}
