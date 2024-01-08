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


final class OnboadingBottomSheetViewController: UIViewController {
    
    private let appleLoginButton = CustomButton(.appleLogin)
    private let kakaoLoginButton = CustomButton(.kakaoLogin)
    private let emailLoginButton = CustomButton(title: "이메일로 계속하기", .emailIcon)
    private let joinButton = CustomLabel("또는 새롭게 회원가입 하기".greenColored(),
                                         font: Typography.title2 ?? UIFont.systemFont(ofSize: 13))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
    }
    
    
    private func configure() {
        view.backgroundColor = Colors.Background.primary
        view.addSubview(appleLoginButton)
        view.addSubview(kakaoLoginButton)
        view.addSubview(emailLoginButton)
        view.addSubview(joinButton)
        emailLoginButton.validationBinder.onNext(true)
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
