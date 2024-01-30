//
//  InviteMemberViewController.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/28/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


final class InviteMemberViewController: UIViewController, ToastPresentableProtocol {

    
    private let emailInputView = CustomInputView(label: "이메일",
                                                 placeHolder: "초대하려는 팀원의 이메일을 입력하세요.",
                                                 keyboardType: .emailAddress)
    
    private let confirmButton = CustomButton(title: "초대 보내기")
    private let viewModel = InviteMemberViewModel()
    private let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
        bind()
    }

    private func configure() {
        view.backgroundColor = Colors.Background.primary
        view.addSubview(emailInputView)
        view.addSubview(confirmButton)
        navigationController?.setCloseableNavigation(title: "팀원 초대",
                                                     target: self,
                                                     action: #selector(self.dismissTrigger))
        viewModel.dismissTrigger = { [weak self] in
            self?.dismissTrigger()
        }
    }
    
    private func bind() {
        
        emailInputView.textField.rx.text.orEmpty
            .bind(to: viewModel.emailSubject)
            .disposed(by: disposeBag)
        
        viewModel.emailSubject
            .withLatestFrom(viewModel.emailLengthValidation)
            .bind(with: self) { owner, validation in
                owner.confirmButton.buttonEnabler.onNext(validation)
                owner.confirmButton.validationBinder.onNext(validation)
            }
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .withLatestFrom(viewModel.emailValidation)
            .filter { $0 }
            .bind(with: self) { owner, _ in
                owner.viewModel.fetchInviteNewMember()
            }
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .withLatestFrom(viewModel.emailValidation)
            .filter { !$0 }
            .bind(with: self) { owner, validation in
                if !validation {
                    let message = Notify.InviteMember(.invalidEmail)
                    owner.viewModel.errorSubject.accept(message)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.errorSubject
            .bind(with: self) { owner, notify in
                switch notify {
                case .InviteMember(let notify):
                    let message = notify.toastMessage
                    owner.makeToastAboveView(message: message,
                                             backgroundColor: Colors.Brand.error,
                                             aboveView: owner.confirmButton)
                default: break
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.completionSubject
            .bind(with: self) { owner, notify in
                switch notify {
                case .InviteMember(let notify):
                    let message = notify.toastMessage
                    owner.makeToastAboveView(message: message,
                                             backgroundColor: Colors.Brand.green,
                                             aboveView: owner.confirmButton)
                default: break
                }
            }
            .disposed(by: disposeBag)
    }
    
    
    private func setConstraints() {
        emailInputView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(76) 
        }
        
        confirmButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-45)
        }
    }
}
