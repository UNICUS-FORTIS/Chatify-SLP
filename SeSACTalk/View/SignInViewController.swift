//
//  ViewController.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/3/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


final class SignInViewController: UIViewController {
    
    private let viewModel = SignInViewModel()
    
    private let email = CustomInputView(label: "이메일",
                                        placeHolder: "이메일을 입력하세요",
                                        keyboardType: .emailAddress,
                                        secureEntry: false)
    
    private let nickname = CustomInputView(label: "닉네임",
                                           placeHolder: "닉네임을 입력하세요",
                                           keyboardType: .default,
                                           secureEntry: false)
    
    private let contact = CustomInputView(label: "연락처",
                                          placeHolder: "연락처를 입력하세요",
                                          keyboardType: .phonePad,
                                          secureEntry: false)
    
    private let passcode = CustomInputView(label: "비밀번호",
                                           placeHolder: "비밀번호를 입력하세요",
                                           keyboardType: .default,
                                           secureEntry: true)
    
    private let passcodeConfirm = CustomInputView(label: "비밀번호 확인",
                                                  placeHolder: "비밀번호를 한번 더 입력하세요",
                                                  keyboardType: .default,
                                                  secureEntry: true)
    
    private let emailCheckButton = CustomButton(title: "중복 확인")
    private let signInButton = CustomButton(title: "가입하기")
    private let disposeBag = DisposeBag()
    private var invalidInputArray:[CustomInputView] = []
    
    private lazy var components:[CustomInputView] = [nickname, contact, passcode, passcodeConfirm]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
        bind()
    }
    
    private func bind() {
        email.textField.rx.text.orEmpty
            .bind(to: viewModel.emailSubject)
            .disposed(by: disposeBag)
        
        nickname.textField.rx.text.orEmpty
            .bind(to: viewModel.nicknameSubject)
            .disposed(by: disposeBag)
        
        contact.textField.rx.text.orEmpty
            .bind(to: viewModel.contactSubject)
            .disposed(by: disposeBag)
        
        passcode.textField.rx.text.orEmpty
            .bind(to: viewModel.passcodeSubject)
            .disposed(by: disposeBag)
        
        passcodeConfirm.textField.rx.text.orEmpty
            .bind(to: viewModel.passcodeConfirmSubject)
            .disposed(by: disposeBag)
        
        signInButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.checkEachInputs()
            }
            .disposed(by: disposeBag)
        
        emailCheckButton.rx.tap
            .flatMap { _ -> Observable<Result<Int,Error>> in
                guard let text = self.email.textField.text else { return Observable.empty() }
                let result = self.viewModel.networkService.fetchRequest(info: EmailValidationRequest(email: text))
                return result.asObservable()
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let successCode):
                    if successCode == 200 {
                        print(successCode)
                        owner.emailCheckButton.validationBinder.onNext(true)
                    }
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
        
        
        
        viewModel.isFormValid
            .subscribe(with: self) { owner, validation in
                owner.signInButton.validationBinder
                    .onNext(validation)
                print(validation)
            }
            .disposed(by: disposeBag)
    }
    
    private func checkEachInputs() {
        checkInput(email, validationClosure: viewModel.validateEmail)
        checkInput(nickname, validationClosure: viewModel.validateNickname)
        checkInput(contact, validationClosure: viewModel.validateContact)
        checkInput(passcode, validationClosure: viewModel.validatePasscode)
        
        let confirmText = passcodeConfirm.textField.text ?? ""
        let confirmValidation = viewModel.confirmPasscode(passcode.textField.text ?? "", confirmText)
        passcodeConfirm.validationBinder.onNext(confirmValidation)
        
        if !confirmValidation {
            invalidInputArray.append(passcodeConfirm)
        }
        
        invalidInputArray.first?.textField.becomeFirstResponder()
        invalidInputArray.removeAll()
    }
    
    private func checkInput(_ input: CustomInputView, validationClosure: (String) -> Bool) {
        let text = input.textField.text ?? ""
        let validation = validationClosure(text)
        input.validationBinder.onNext(validation)
        
        if !validation {
            invalidInputArray.append(input)
        }
    }
    
    private func configure() {
        view.backgroundColor = Colors.Background.primary
        title = "회원가입"
        view.addSubview(email)
        view.addSubview(emailCheckButton)
        view.addSubview(signInButton)
        components.forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        
        email.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.width.equalTo(233)
            make.height.equalTo(76)
        }
        
        var previousView: CustomInputView? = email
        
        components.forEach { inputView in
            inputView.snp.makeConstraints { make in
                make.top.equalTo(previousView?.snp.bottom ?? view.safeAreaLayoutGuide).offset(24)
                make.leading.equalToSuperview().offset(24)
                make.trailing.equalToSuperview().offset(-24)
                make.height.equalTo(76)
            }
            previousView = inputView
        }
        
        emailCheckButton.snp.makeConstraints { make in
            make.height.equalTo(email.textField.snp.height)
            make.centerY.equalTo(email.textField.snp.centerY)
            make.leading.equalTo(email.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        signInButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-45)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

