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
import AuthenticationServices


final class OnboadingBottomSheetViewController: UIViewController {
    
    private let session = LoginSession.shared
    private let handler = SocialLoginHandler()
    private let appleLoginButton = CustomButton(.appleLogin)
    private let kakaoLoginButton = CustomButton(.kakaoLogin)
    private let emailLoginButton = CustomButton(title: ScreenTitles
        .Onboarding
        .BottomSheet
        .emailLoginButton, .emailIcon)
    private let joinButton = CustomLabel(ScreenTitles.Onboarding
        .BottomSheet
        .joinButton
        .greenColored(), font: Typography.createTitle2())
    
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
        handler.fetchKakaoLoginRequest() { [weak self] in
            self?.dismiss(animated: true) { [weak self] in
                UserdefaultManager.setLoginMethod(isLogin: true, method: .kakao)
                self?.viewModel?.kakaoLoginPushTrigger?()
            }
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
        guard let safe = viewModel else { return }
        let vc = EmailLogInViewController(viewModel: safe)
        let NavVC = UINavigationController(rootViewController: vc)
        let presentingVC = self.presentingViewController
        dismiss(animated: true) {
                if let sheet = NavVC.presentationController as? UISheetPresentationController {
                sheet.detents = [.large()]
                sheet.prefersGrabberVisible = true
                    presentingVC?.present(NavVC, animated: true)
            }
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
    
    private func moveToNextView() {
        self.dismiss(animated: true) { [weak self] in
            UserdefaultManager.setLoginMethod(isLogin: true, method: .apple)
            self?.viewModel?.appleLoginPushTrigger?()
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
                
                guard let token = appleIDCredential.identityToken,
                      let tokenToString = String(data: token, encoding: .utf8) else {
                    print("Token Error")
                    return }
                UserdefaultManager.saveAppleAppleIDToken(token: tokenToString)

                let userIdentifier = appleIDCredential.user
                let fullName = appleIDCredential.fullName
                let email = appleIDCredential.email
                
                if let email = email {
                    UserdefaultManager.saveAppleEmail(email: email)
                }
                
                if email?.isEmpty ?? true {
                    let result = decode(jwtToken: tokenToString)["email"] as? String ?? ""
                    print("이메일이 없어서 디코드한", result)
                    UserdefaultManager.saveAppleAppleIDToken(token: tokenToString)
                    moveToNextView()
                }

                // MARK: - userIdentifier 저장
                UserdefaultManager.saveAppleUserIdentifier(identifier: userIdentifier)
                                
                if let fullName = fullName {
                    guard let familyName = fullName.familyName,
                          let givenName = fullName.givenName else { return }
                    
                    let name = givenName+familyName
                    UserdefaultManager.saveAppleUsername(name: name)
                }
                
                moveToNextView()
                
            case let passwordCredential as ASPasswordCredential:
                
                let _ = passwordCredential.user
                let _ = passwordCredential.password
                
            default : break
                
            }
    }
}
