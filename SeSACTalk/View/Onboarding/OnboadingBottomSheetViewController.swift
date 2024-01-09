//
//  OnboadingBottomSheetViewController.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/8/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import KakaoSDKCommon
import RxKakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser


final class OnboadingBottomSheetViewController: UIViewController {
    
    private let appleLoginButton = CustomButton(.appleLogin)
    private let kakaoLoginButton = CustomButton(.kakaoLogin)
    private let emailLoginButton = CustomButton(title: ScreenTitles
        .Onboarding
        .BottomSheet
        .emailLoginButton, .emailIcon)
    private let joinButton = CustomLabel(ScreenTitles.Onboarding
        .BottomSheet
        .joinButton
        .greenColored(), font: Typography.title2 ??
                                         UIFont.systemFont(ofSize: 13))
    
    private var viewModel: OnboardingViewModel?
    private let disposeBag = DisposeBag()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(viewModel: OnboardingViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
        setButtonBehavior()
        setKakaoLogin()
    }
    
    
    private func configure() {
        view.backgroundColor = Colors.Background.primary
        view.addSubview(appleLoginButton)
        view.addSubview(kakaoLoginButton)
        view.addSubview(emailLoginButton)
        view.addSubview(joinButton)
        emailLoginButton.validationBinder.onNext(true)
    }
    
    private func setButtonBehavior() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(touch))
        joinButton.addGestureRecognizer(gesture)
    }
    
    @objc private func touch() {
        dismiss(animated: true)
        viewModel?.joinPagePushTrigger?()
    }
    
    private func setKakaoLogin() {
        kakaoLoginButton.addTarget(self, action: #selector(startKakaoLogin), for: .touchUpInside)
    }
    
    @objc private func startKakaoLogin() {
        print(#function)
        guard let viewModel = viewModel else { return }
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.rx.loginWithKakaoTalk()
                .flatMap { token -> Observable<KakaoLoginRequest> in
                    viewModel.kakaoOAuthToken.onNext(token.accessToken)
                    return viewModel.form
                }
                .flatMapLatest { request -> Observable<Result<SignInResponse, ErrorResponse>> in
                    let result = viewModel.networkService.fetchKakaoLoginRequest(info: request)
                    return result.asObservable()
                }
                .subscribe(with: self) { owner, result in
                    switch result {
                    case .success(let response):
                        print("응답왔음",response)
                    case .failure(let error):
                        print(error.errorCode)
                    }
                }
                .disposed(by: disposeBag)
        }
    }
    
    
    private func setConstraints() {
        
        appleLoginButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(42)
            make.horizontalEdges.equalToSuperview().inset(35)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.top.equalTo(appleLoginButton.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(35)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
        }
        
        emailLoginButton.snp.makeConstraints { make in
            make.top.equalTo(kakaoLoginButton.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(35)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
        }
        
        joinButton.snp.makeConstraints { make in
            make.top.equalTo(emailLoginButton.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(35)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
    }
    
    
}
