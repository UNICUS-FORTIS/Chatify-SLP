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
import Toast


final class SignInViewController: UIViewController {
    
    private let viewModel = SignInViewModel()
    private lazy var center = ValidationCenter()
    private let networkService = NetworkService.shared
    weak var delegate: ToWorkSpaceTriggerProtocol?

    
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
        
        // MARK: - 회원가입버튼 동작
        signInButton.rx.tap
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .flatMapLatest { self.checkEachInputs() }
            .filter { $0 }
            .withLatestFrom(viewModel.isFormValid)
            .filter { $0 }
            .withLatestFrom(viewModel.signInRequestForm)
            .flatMapLatest { requestForm -> Observable<Result<SignInResponse, ErrorResponse>> in
                let form = SignInRequest(email: requestForm.email,
                                         password: requestForm.password,
                                         nickname: requestForm.nickname,
                                         phone: requestForm.phone,
                                         deviceToken: requestForm.deviceToken)
                return self.networkService.fetchJoinRequest(info: form).asObservable()
            }
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, response in
                switch response {
                case .success(let result):
                    owner.viewModel.saveTokens(access: result.token.accessToken,
                                         refresh: result.token.refreshToken)
                    
                    owner.dismiss(animated: true)
                    owner.delegate?.pushToWorkSpace()
                    
                case .failure(let error):
                    print(error.errorCode)
                }
            }
            .disposed(by: disposeBag)

        
        email.textField.rx.text.orEmpty
            .subscribe(with: self) { owner, text in
                if text.count > 0 {
                    owner.viewModel.emailTextfieldisInputed.onNext(true)
                    owner.emailCheckButton.validationBinder.onNext(true)
                    owner.emailCheckButton.buttonEnabler.onNext(true)
                } else {
                    owner.viewModel.emailTextfieldisInputed.onNext(false)
                    owner.emailCheckButton.validationBinder.onNext(false)
                    owner.emailCheckButton.buttonEnabler.onNext(false)
                }
            }
            .disposed(by: disposeBag)
        
        // MARK: - 중복버튼 동작
        emailCheckButton.rx.tap
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged({ _ , _ in
                let previous = self.viewModel.validatedEmail
                let current = self.email.textField.text
                if previous == current {
                    self.createInformationToast(message: ToastMessages.Join.availiableEmail.description,
                                                backgroundColor: Colors.Brand.green,
                                                aboveView: self.signInButton)
                    return true
                } else {
                    return false
                }
            })
            .flatMap { _ -> Observable<Result<Int, ErrorResponse>> in
                guard let text = self.email.textField.text,
                      self.center.validateEmail(text) else {
                    self.createInformationToast(message: ToastMessages.Join.invalidEmail.description,
                                                backgroundColor: Colors.Brand.error,
                                                aboveView: self.signInButton)
                    return Observable.empty()
                }
                let result = self.networkService.fetchEmailValidationRequest(info: EmailValidationRequest(email: text))
                return result.asObservable()
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let successCode):
                    if successCode == 200 {
                        owner.viewModel.validatedEmail = owner.email.textField.text
                        owner.emailCheckButton.validationBinder.onNext(true)
                        owner.viewModel.emailValidationSubject.onNext(true)
                        owner.createInformationToast(message: ToastMessages.Join.availiableEmail.description,
                                                     backgroundColor: Colors.Brand.green,
                                                     aboveView: owner.signInButton)
                    }
                    
                case .failure(let error):
                    print(error)
                    let responseCode = error.errorCode
                    owner.createInformationToast(message: APIError.ErrorCodes(rawValue: responseCode)?.description ?? "",
                                                 backgroundColor: Colors.Brand.error,
                                                 aboveView: owner.signInButton)
                }
            }
            .disposed(by: disposeBag)
        
        email.textField.rx.controlEvent(.editingChanged)
            .subscribe(with: self) { owner, _ in
                owner.viewModel.emailValidationSubject.onNext(false)
            }
            .disposed(by: disposeBag)
        
        contact.textField.rx.text.orEmpty
            .map { text in
                switch text.count {
                case 13:
                    return text.formated(by: "###-####-####")
                default:
                    return text.formated(by: "###-###-####")
                }
            }
            .bind(to: contact.textField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isFormValid
            .subscribe(with: self) { owner, validation in
                owner.signInButton.validationBinder.onNext(validation)
            }
            .disposed(by: disposeBag)
    }
    
    private func checkEachInputs() -> Observable<Bool> {
        print(#function)
        center.checkInput(email, validationClosure: center.validateEmail)
        center.checkInput(nickname, validationClosure: center.validateNicknameOrWorkspaceName)
        center.checkInput(contact, validationClosure: center.validateContact)
        center.checkInput(passcode, validationClosure: center.validatePasscode)
        
        let confirmText = passcodeConfirm.textField.text ?? ""
        let confirmValidation = center.confirmPasscode(passcode.textField.text ?? "", confirmText)
        passcodeConfirm.validationBinder.onNext(confirmValidation)
        
        if !confirmValidation {
            center.invalidComponents.append(passcodeConfirm)
        }
        
        if let firstInvalidInput = center.invalidComponents.first {
            firstInvalidInput.textField.becomeFirstResponder()
            
            if firstInvalidInput == email {
                self.makeToastAboveView(message: ToastMessages.Join.invalidEmail.description,
                                        backgroundColor: Colors.Brand.error, aboveView: signInButton)
                
            } else if firstInvalidInput != email {
                let emailValidation = try? viewModel.emailValidationSubject.value()
                if emailValidation == false {
                    makeToastAboveView(message: ToastMessages.Join.validationReck.description,
                                       backgroundColor: Colors.Brand.error, aboveView: signInButton)
                } else if firstInvalidInput == nickname {
                    
                    self.makeToastAboveView(message: ToastMessages.Join.invalidNickname.description,
                                            backgroundColor: Colors.Brand.error, aboveView: signInButton)
                    
                } else if firstInvalidInput == contact {
                    
                    self.makeToastAboveView(message: ToastMessages.Join.invalidPhone.description,
                                            backgroundColor: Colors.Brand.error, aboveView: signInButton)
                    
                } else if firstInvalidInput == passcode {
                    
                    self.makeToastAboveView(message: ToastMessages.Join.invalidPassword.description,
                                            backgroundColor: Colors.Brand.error, aboveView: signInButton)
                    
                } else if firstInvalidInput == passcodeConfirm {
                    
                    self.makeToastAboveView(message: ToastMessages.Join.invalidPasswordConfirmation.description,
                                            backgroundColor: Colors.Brand.error, aboveView: signInButton)
                }
            }
            center.invalidComponents.removeAll()
            return Observable.just(false)
        } else {
            let emailValidation = try? viewModel.emailValidationSubject.value()
            if emailValidation == false {
                makeToastAboveView(message: ToastMessages.Join.validationReck.description,
                                   backgroundColor: Colors.Brand.error, aboveView: signInButton)
                return Observable.just(false)
            }
        }
        return Observable.just(true)
    }
    
    private func configure() {
        view.backgroundColor = Colors.Background.primary
        view.addSubview(email)
        view.addSubview(emailCheckButton)
        view.addSubview(signInButton)
        components.forEach { view.addSubview($0) }
        navigationController?.setStartingAppearance(title: "회원가입",
                                                  target: self,
                                                  action: #selector(dismissTrigger))
    }
    
    @objc private func dismissTrigger() {
        self.dismiss(animated: true)
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
                make.horizontalEdges.equalToSuperview().inset(24)
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


extension SignInViewController: ToastPresentableProtocol {
    
    func createInformationToast(message: String, backgroundColor: UIColor, aboveView: UIView) {
        makeToastAboveView(message: message, backgroundColor: backgroundColor, aboveView: aboveView)
    }
    
}

