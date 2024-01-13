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
import AuthenticationServices


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
        setFlatFormLoginButton()
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
    
    private func setFlatFormLoginButton() {
        appleLoginButton.addTarget(self, action: #selector(startAppleLogin), for: .touchUpInside)
        kakaoLoginButton.addTarget(self, action: #selector(startKakaoLogin), for: .touchUpInside)
        emailLoginButton.addTarget(self, action: #selector(startEmailLogin), for: .touchUpInside)
    }
    
    @objc private func startKakaoLogin() {
        print(#function)
        guard let viewModel = viewModel else { return }
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.rx.loginWithKakaoTalk()
                .flatMap { token -> Observable<KakaoLoginRequest> in
                    let form = KakaoLoginRequest(oauthToken: token.accessToken,
                                                 deviceToken: viewModel.deviceToken ?? "")
                    return Observable.just(form)
                }
                .flatMapLatest { form -> Observable<Result<SignInResponse, ErrorResponse>> in
                    let result = viewModel.networkService.fetchKakaoLoginRequest(info: form)
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
    
    @objc private func startAppleLogin() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.email, .fullName]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    @objc private func startEmailLogin() {
        dismiss(animated: true)
        viewModel?.emailLoginPushTrigger?()
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
    
    // MARK: - 두번째 로그인때부터 이메일 정보가 없을 경우
    private func decode(jwtToken jwt: String) -> [String: Any] {
        
        func base64UrlDecode(_ value: String) -> Data? {
            var base64 = value
                .replacingOccurrences(of: "-", with: "+")
                .replacingOccurrences(of: "_", with: "/")
            
            let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
            let requiredLength = 4 * ceil(length / 4.0)
            let paddingLength = requiredLength - length
            if paddingLength > 0 {
                let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
                base64 = base64 + padding
            }
            return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
        }
        
        
        func decodeJWTPart(_ value: String) -> [String: Any]? {
            guard let bodyData = base64UrlDecode(value),
                  let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
                return nil
            }
            
            return payload
        }
        
        let segments = jwt.components(separatedBy: ".")
        return decodeJWTPart(segments[1]) ?? [:]
    }
    
    
}

extension OnboadingBottomSheetViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
}

extension OnboadingBottomSheetViewController: ASAuthorizationControllerDelegate {
    
    // MARK: - 로그인 실패했을경우
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            print("로그인 실패함 , \(error.localizedDescription)")
    }
    
    // MARK: - 로그인 성공한경우
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            
            switch authorization.credential {
                
            case let appleIDCredential as ASAuthorizationAppleIDCredential :
                
                print(appleIDCredential)
                
                let userIdentifier = appleIDCredential.user
                let fullName = appleIDCredential.fullName
                let email = appleIDCredential.email

                // MARK: - userIdentifier 저장
                UserDefaults.standard.set(userIdentifier, forKey: "AppleUser")

                if let fullName = fullName {
                    guard let familyName = fullName.familyName,
                          let givenName = fullName.givenName else { return }
                    
                    let name = givenName+familyName
                    print(name)
                    UserDefaults.standard.set(name, forKey: "AppleLoginName")
                }
                
                if let email = email {
                    UserDefaults.standard.set(email, forKey: "AppleLoginEmail")
                }
                
                guard let token = appleIDCredential.identityToken,
                      let tokenToString = String(data: token, encoding: .utf8) else {
                    print("Token Error")
                    return }
                
                if email?.isEmpty ?? true {
                    let result = decode(jwtToken: tokenToString)["email"] as? String ?? ""
                    print("이메일이 없어서 디코드한", result) // 모 이 데이터를 userDefault 에 업데이트 해줄수 있다
                }
                
                
                guard let viewModel = viewModel else { return }
                if let fullName = fullName {
                    guard let familyName = fullName.familyName,
                          let givenName = fullName.givenName else { return }
                    let name = givenName+familyName
                    let form = AppleLoginRequest(idToken: tokenToString,
                                                 nickname: name,
                                                 deviceToken: viewModel.deviceToken ?? "")
                    let group = DispatchGroup()
                    group.enter()
                    viewModel.fetchAppleLogin(form: form)
                    group.leave()
                    
                    group.notify(queue: .main) {
                        self.dismiss(animated: true)
                        print("완료")
                    }
                }
                // MARK: - 여기부터 없어도 될듯
//                else {
//                    if let storedFullName = viewModel.appleFullName {
//                        let form = AppleLoginRequest(idToken: tokenToString,
//                                                     nickname: storedFullName,
//                                                     deviceToken: viewModel.deviceToken ?? "")
//                        print("else문 Form ",form)
//                        viewModel.fetchAppleLogin(form: form)
//                    }
//                }
                
    // 이메일, 토큰, 이름 -> UserDefault & API 서버에 POST
    // 서버에 Request 이후 Response 를 받게되면, 성공시 화면을 전환해조야됨
                
            case let passwordCredential as ASPasswordCredential:
                
                let username = passwordCredential.user
                let password = passwordCredential.password
                
            default : break
                
            }
        }
}
