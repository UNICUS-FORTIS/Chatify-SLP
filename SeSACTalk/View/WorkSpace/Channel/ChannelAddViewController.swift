//
//  ChannelAddViewController.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/29/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


final class ChannelAddViewController: UIViewController, ToastPresentableProtocol {

    let viewModel = ChannelAddViewModel()
    private let loginSession = LoginSession.shared
    private lazy var center = ValidationCenter()
    private var channelInfo: Channels?
    
    private let channelName = CustomInputView(label: "채널 이름",
                                        placeHolder: "채널 이름을 입력하세요 (필수)",
                                        keyboardType: .emailAddress,
                                        secureEntry: false)
    
    private let channelDescription = CustomInputView(label: "채널 설명",
                                           placeHolder: "채널을 설명하세요 (옵션)",
                                           keyboardType: .default,
                                           secureEntry: false)
    
    private var completeButton: CustomButton
    private let disposeBag = DisposeBag()
    private var viewTitle: String
    
    init(viewTitle: String) {
        self.viewTitle  = viewTitle
        self.completeButton = CustomButton(title: "생성")
        super.init(nibName: nil, bundle: nil)
        setupCompleteButtonForChannelCreation()
    }
    
    init(viewTitle: String, channelInfo: Channels) {
        self.viewTitle = viewTitle
        self.channelInfo = channelInfo
        self.completeButton = CustomButton(title: "완료")
        super.init(nibName: nil, bundle: nil)
        bindForChannelEdit()
        setupCompleteButtonForChannelEdit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
        bind()
        keyboardSetting(target: self,
                        view: completeButton,
                        tableView: nil,
                        scrollView: nil,
                        disposeBag: disposeBag)
    }
    
    private func bind() {
        
        channelName.textField.rx.text.orEmpty
            .bind(to: viewModel.channelNameSubject)
            .disposed(by: disposeBag)
        
        channelDescription.textField.rx.text.orEmpty
            .bind(to: viewModel.channelDescriptionSubject)
            .disposed(by: disposeBag)
        
        viewModel.channelNameSubject
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, name in
                let validation = owner.center.checkLength(target: name)
                owner.completeButton.validationBinder.onNext(validation)
            }
            .disposed(by: disposeBag)
        
        viewModel.errorReceiver
            .bind(with: self) { owner, notify in
                switch notify {
                case .createChannels(let notify):
                    let message = notify.toastMessage
                    owner.makeToastAboveView(message: message,
                                             backgroundColor: Colors.Brand.error,
                                             aboveView: owner.completeButton)
                    
                default: break
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.completionSubject
            .bind(with: self) { owner, notify in
                switch notify {
                case .InviteMember(let notify):
                    let message = notify.toastMessage
                    owner.makeToastAboveView(message: message,
                                             backgroundColor: Colors.Brand.green,
                                             aboveView: owner.completeButton)
                default: break
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func setupCompleteButtonForChannelCreation() {
        completeButton.rx.tap
            .withLatestFrom(viewModel.form)
            .bind(with: self) { owner, form in
                owner.viewModel.createNewChannel(form: form)
            }
            .disposed(by: disposeBag)
    }
    
    private func setupCompleteButtonForChannelEdit() {
        completeButton.rx.tap
            .withLatestFrom(viewModel.form)
            .bind(with: self) { owner, form in
                guard let safe = owner.channelInfo else { return }
                owner.viewModel.fetchEditChannelInfo(name: safe.name, form: form)
                self.dismiss(animated: true)
            }.disposed(by: disposeBag)
    }
    
    private func configure() {
        view.backgroundColor = Colors.Background.primary
        view.addSubview(channelName)
        view.addSubview(channelDescription)
        view.addSubview(completeButton)
        navigationController?.setCloseableNavigation(title: viewTitle,
                                                     target: self,
                                                     action: #selector(self.dismissTriggerNonAnimated))
        viewModel.dismissTrigger = { [weak self] in
            self?.dismissTrigger()
        }
    }
    
    private func setConstraints() {
        channelName.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(76)
        }

        channelDescription.snp.makeConstraints { make in
            make.top.equalTo(channelName.snp.bottom).offset(24)
            make.height.equalTo(channelName.textField.snp.height)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        completeButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bindForChannelEdit() {
        guard let safe = channelInfo else { return }
        channelName.textField.text = safe.name
        channelDescription.textField.text = safe.description
    }
}
