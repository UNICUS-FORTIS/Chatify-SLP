//
//  EmailSignInViewController.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/7/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Toast

final class EmailLogInViewController: UIViewController {
    
    
    private let viewModel = EmailLoginViewModel()
    private let loginSession = LoginSession.shared
    private lazy var center = ValidationCenter()
    
    private let email = CustomInputView(label: "이메일",
                                        placeHolder: "이메일을 입력하세요",
                                        keyboardType: .emailAddress,
                                        secureEntry: false)
    
    private let password = CustomInputView(label: "비밀번호",
                                           placeHolder: "비밀번호를 입력하세요",
                                           keyboardType: .default,
                                           secureEntry: true)
    
    private let logInButton = CustomButton(title: "로그인")
    private let disposeBag = DisposeBag()
    private var onBoardingViewModel: OnboardingViewModel!
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(viewModel: OnboardingViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.onBoardingViewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
        bind()
    }
    
    private func configure() {
        view.backgroundColor = Colors.Background.primary
        title = "이메일 로그인"
        view.addSubview(email)
        view.addSubview(password)
        view.addSubview(logInButton)
    }
    
    private func setConstraints() {
        
        email.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(76)
        }

        password.snp.makeConstraints { make in
            make.top.equalTo(email.snp.bottom).offset(24)
            make.height.equalTo(email.textField.snp.height)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        logInButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-45)
        }
    }
    
    private func bind() {
        email.textField.rx.text.orEmpty
            .bind(to: viewModel.emailSubject)
            .disposed(by: disposeBag)
        
        password.textField.rx.text.orEmpty
            .bind(to: viewModel.passcodeSubject)
            .disposed(by: disposeBag)
        
        viewModel.isFormInputed
            .subscribe(with: self) { owner, validation in
                owner.logInButton.validationBinder.onNext(validation)
                owner.logInButton.buttonEnabler.onNext(validation)
            }
            .disposed(by: disposeBag)
        
        logInButton.rx.tap
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .flatMapLatest { self.checkEachInputs() }
            .filter { $0 }
            .withLatestFrom(viewModel.isFormValid)
            .filter { $0 }
            .withLatestFrom(viewModel.emailLoginRequestForm)
            .flatMapLatest { form -> Observable<Result<EmailLoginResponse, ErrorResponse>> in
                let logInForm = EmailLoginRequest(email: form.email,
                                                  password: form.password,
                                                  deviceToken: form.deviceToken)
                let result = self.viewModel.networkService.fetchEmailLoginRequest(info: logInForm)
                return result.asObservable()
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    owner.loginSession.handOverLoginInformation(id: response.userID,
                                                          nick: response.nickname,
                                                          access: response.accessToken,
                                                          refresh: response.refreshToken)
                    dump(response)
                    owner.dismiss(animated: true)
                    owner.onBoardingViewModel.afterLoginSucceedTrigger?()
                case .failure(let error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)

    }
    
    private func checkEachInputs() -> Observable<Bool> {
        center.checkInput(email, validationClosure: center.validateEmail)
        center.checkInput(password, validationClosure: center.validatePasscode)
        
        if let firstInvalidInput = center.invalidComponents.first {
            firstInvalidInput.textField.becomeFirstResponder()
            
            if firstInvalidInput == email {
                self.makeToastAboveView(message: ToastMessages.Join.invalidEmail.description,
                                        backgroundColor: Colors.Brand.error,
                                        aboveView: logInButton)
            } else if firstInvalidInput == password {
                self.makeToastAboveView(message: ToastMessages.Join.invalidPassword.description,
                                        backgroundColor: Colors.Brand.error,
                                        aboveView: logInButton)
            }
            print(center.invalidComponents.count)
            center.invalidComponents.removeAll()
            return Observable.just(false)
        }
        return Observable.just(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
}

extension EmailLogInViewController: ToastPresentableProtocol {
    
    func createInformationToast(message: String, backgroundColor: UIColor, aboveView: UIView) {
        makeToastAboveView(message: message, backgroundColor: backgroundColor, aboveView: aboveView)
    }
    
}
