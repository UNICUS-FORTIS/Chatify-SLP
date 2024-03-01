//
//  ProfileEditViewController.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/13/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxKeyboard

final class ProfileEditViewController: UIViewController {

    private let viewModel = ProfileEditViewModel()
    private let profileInputView = CustomInputView(label: "",
                                        placeHolder: "",
                                        keyboardType: .default,
                                        secureEntry: false)
    
    private let completeButton = CustomButton(title: "완료")
    private let disposeBag = DisposeBag()
    private var editMode: ProfileEditModeSelector?

    init(editMode: ProfileEditModeSelector) {
        self.editMode = editMode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
        setCurrentProfile()
        bind()
        setCompleteButtonAction()
    }
    
    private func setCurrentProfile() {
        switch editMode {
        case .nickname:
            
            profileInputView.textField.text = viewModel.createCurrentNickname()

        case .contact:
            
            profileInputView.textField.text = viewModel.createCurrentContact()
            
        case nil:
            break
        }
    }
    
    private func bind() {

        switch editMode {
            
        case .nickname:

            profileInputView.textField.rx.text.orEmpty
                .bind(to: viewModel.nicknameRelay)
                .disposed(by: disposeBag)
            
            viewModel.nicknameRelay
                .asDriver(onErrorJustReturn: "")
                .drive(with: self) { owner, nickname in
                    let validation = nickname == owner.viewModel.profile?.nickname
                    owner.completeButton.validationBinder.onNext(!validation)
                    owner.completeButton.buttonEnabler.onNext(!validation)
                }
                .disposed(by: disposeBag)
            
        case .contact:
            
            profileInputView.textField.rx.text.orEmpty
                .bind(to: viewModel.contactRelay)
                .disposed(by: disposeBag)
            
            profileInputView.textField.rx.text.orEmpty
                .map { text in
                    switch text.count {
                    case 13:
                        return text.formated(by: "###-####-####")
                    default:
                        return text.formated(by: "###-###-####")
                    }
                }
                .bind(to: profileInputView.textField.rx.text)
                .disposed(by: disposeBag)
            
            viewModel.contactRelay
                .asDriver(onErrorJustReturn: "")
                .drive(with: self) { owner, contact in
                    let validation = contact == owner.viewModel.profile?.phone
                    owner.completeButton.validationBinder.onNext(!validation)
                    owner.completeButton.buttonEnabler.onNext(!validation)
                }
                .disposed(by: disposeBag)
            
        case nil:
            break
        }
        
        
    }
    
    private func setCompleteButtonAction() {
        completeButton.rx.tap
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(with: self) { owner, _ in
                owner.viewModel.fetchProfileUpdate()
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func configure() {
        view.backgroundColor = Colors.Background.primary
        view.addSubview(profileInputView)
        view.addSubview(completeButton)
        guard let safe = editMode else { return }
        navigationController?.setDefaultNavigation(target: self, title: safe.title)
        keyboardSetting(target: self,
                        view: completeButton,
                        tableView: nil,
                        scrollView: nil,
                        disposeBag: disposeBag)
    }
    
    private func setConstraints() {
        profileInputView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
        }
        
        completeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
    }
    
    deinit {
        print("프로필 에딧창-닉네임/연락처 deinit됨")
    }
}
