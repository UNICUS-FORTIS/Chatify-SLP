//
//  InviteMemberViewModel.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/28/24.
//

import Foundation
import RxSwift
import RxCocoa


final class InviteMemberViewModel {
    
    
    private let networkService = NetworkService.shared
    private let session = LoginSession.shared
    private let disposeBag = DisposeBag()
    private let center = ValidationCenter()
    let emailSubject = BehaviorRelay<String>(value: "")
    let emailValidation = BehaviorRelay<Bool>(value: false)
    let emailLengthValidation = BehaviorRelay<Bool>(value: false)
    let completionSubject = PublishRelay<Notify>()
    let errorSubject = PublishRelay<Notify>()
    var dismissTrigger: ( ()-> Void )?

    
    init() {
        emailSubject
            .map { self.center.validateEmail($0) }
            .bind(to: emailValidation)
            .disposed(by: disposeBag)
        
        emailSubject
            .map { self.center.checkLength(target: $0) }
            .bind(to: emailLengthValidation)
            .disposed(by: disposeBag)
            
    }
    
    
    func fetchInviteNewMember(){
        let idRequest = IDRequiredRequest(id: session.makeWorkspaceID())
        networkService.fetchStatusCodeRequest(endpoint: .inviteWorkspaceMember(id: idRequest, model: EmailValidationRequest(email: emailSubject.value)))
            .subscribe(with: self) { owner, result in
                switch result {
                case .success( _ ):
                    owner.completionSubject.accept(.InviteMember(.success))
                case .failure(let error):
                    if let errorcase = InviteMemberErrors(rawValue: error.errorCode) {
                        owner.errorSubject.accept(.InviteMember(errorcase))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                            owner.dismissTrigger?()
                        }
                    }
                    print("멤버초대에러코드", error.errorCode)
                }
            }
            .disposed(by: disposeBag)
    }
    
    
    
}
