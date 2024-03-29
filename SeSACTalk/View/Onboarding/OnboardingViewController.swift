//
//  OnboardingViewController.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/8/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import FloatingPanel


class OnboardingViewController: UIViewController {
    
    let mainImage = UIImageView(image: .onboarding)
    let mainTitle = CustomTitleLabel(ScreenTitles.Onboarding.mainTitle,
                                             textColor: .black,
                                             font: Typography.createTitle1())
    private let startButton = CustomButton(title: ScreenTitles.Onboarding.startButton)
    private var fpc: FloatingPanelController!
    private let viewModel = OnboardingViewModel()
    private let session = LoginSession.shared
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
        setFloatingPanel()
        setTriggers()
    }
        
    func configure() {
        view.backgroundColor = Colors.Background.primary
        view.addSubview(mainImage)
        view.addSubview(mainTitle)
        view.addSubview(startButton)
        mainImage.contentMode = .scaleAspectFit
        startButton.validationBinder.onNext(true)
        startButton.addTarget(self, action: #selector(presentBottomSheet), for: .touchUpInside)
        navigationController?.setOnboardingNavigation()
    }
    
    private func setFloatingPanel() {
        fpc = FloatingPanelController()
        let appearance = SurfaceAppearance()
        
        let contentVC = OnboadingBottomSheetViewController(viewModel: self.viewModel)
        contentVC.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: 300)
        
        appearance.cornerRadius = 10
        fpc.isRemovalInteractionEnabled = true
        fpc.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        fpc.layout = OnboardingFloatingPanelLayout()
        fpc.surfaceView.appearance = appearance
        fpc.set(contentViewController: contentVC)
        
    }
  
    
    private func setTriggers() {
        viewModel.joinPagePushTrigger = { [weak self] in
            let vc = SignInViewController()
            vc.delegate = self
            
            let NavVC = UINavigationController(rootViewController: vc)
            if let sheet = NavVC.presentationController as? UISheetPresentationController {
                sheet.detents = [.large()]
                sheet.prefersGrabberVisible = true
                self?.present(NavVC, animated: true, completion: nil)
            }
        }
        
        viewModel.emailLoginPushTrigger = { [weak self] in
            let vc = LoginGateViewController(loginMethod: .email)
            vc.gateAction(target: self)
        }
        
        viewModel.appleLoginPushTrigger = { [weak self] in
            let vc = LoginGateViewController(loginMethod: .apple)
            vc.gateAction(target: self)
        }
        
        viewModel.kakaoLoginPushTrigger = { [weak self] in
            let vc = LoginGateViewController(loginMethod: .kakao)
            vc.gateAction(target: self)
        }
    }
    
    @objc private func presentBottomSheet() {

        self.present(fpc, animated: true, completion: nil)
    }

    func setConstraints() {
        
        mainTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(39)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
        }
        
        mainImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-45)
        }
    }
}

extension OnboardingViewController: ToWorkSpaceTriggerProtocol {
    
    func pushToWorkSpace() {
        let vc = HomeEmptyViewController()
        self.navigationController?.setViewControllers([vc], animated: true)
    }
}
