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
    
    private let email = CustomInputView(label: "이메일", placeHolder: "이메일을 입력하세요", secureEntry: false, validation: true)
    private let nickname = CustomInputView(label: "닉네임", placeHolder: "닉네임을 입력하세요", secureEntry: false, validation: true)
    private let contact = CustomInputView(label: "연락처", placeHolder: "연락처를 입력하세요", secureEntry: false, validation: true)
    private let passcode = CustomInputView(label: "비밀번호", placeHolder: "비밀번호를 입력하세요", secureEntry: true, validation: true)
    private let passcodeConfirm = CustomInputView(label: "비밀번호 확인", placeHolder: "비밀번호를 한번 더 입력하세요", secureEntry: true, validation: true)
    private let emailCheckButton = CustomButton(title: "중복 확인")
    private let signInButton = CustomButton(title: "가입하기")
    
    private lazy var components:[CustomInputView] = [nickname, contact, passcode, passcodeConfirm]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
    }
    
    private func configure() {
        view.backgroundColor = Colors.Background.primary
        title = "회원가입"
        view.addSubview(email)
        view.addSubview(emailCheckButton)
        view.addSubview(signInButton)
        components.forEach { view.addSubview($0) }
        signInButton.addTarget(self, action: #selector(printsss), for: .touchUpInside)
    }
    
    @objc func printsss() {
        print(viewModel.SignInRequestForm)
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
}

