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
    
    private let email = CustomInputView(label: "이메일",
                                        placeHolder: "이메일을 입력하세요",
                                        keyboardType: .emailAddress,
                                        secureEntry: false)
    
    private let password = CustomInputView(label: "비밀번호",
                                           placeHolder: "비밀번호를 입력하세요",
                                           keyboardType: .default,
                                           secureEntry: false)
    
    private let logInButton = CustomButton(title: "로그인")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setConstraints()
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
}
