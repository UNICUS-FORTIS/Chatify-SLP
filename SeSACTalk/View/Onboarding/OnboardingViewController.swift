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


final class OnboardingViewController: UIViewController {
    
    private let mainImage = UIImageView(image: .onboarding)
    private let mainTitle = CustomTitleLabel(ScreenTitles.Onboarding.mainTitle,
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
        
    private func configure() {
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
            if let strongSelf = self {
                strongSelf.setAfterLoginSucceed()
                let vc = EmailLogInViewController(viewModel: strongSelf.viewModel)
                let NavVC = UINavigationController(rootViewController: vc)
                if let sheet = NavVC.presentationController as? UISheetPresentationController {
                    sheet.detents = [.large()]
                    sheet.prefersGrabberVisible = true
                    self?.present(NavVC, animated: true, completion: nil)
                }
            }
        }
        
        viewModel.appleLoginPushTrigger = { [weak self] in
            let vc = LoginGateViewController(loginMethod: .apple)
            vc.setInfoByLoginMethod(target: self)
        }
    }
    
    @objc private func presentBottomSheet() {

        self.present(fpc, animated: true, completion: nil)
    }
    
    private func setAfterLoginSucceed() {
        viewModel.afterLoginSucceedTrigger = { [weak self] in
            if let strongSelf = self {
                strongSelf.viewModel.fetchLoadWorkSpace()
                    .subscribe(with: strongSelf) { owner, result in
                        switch result {
                        case .success(let response):
                            if response.count == 0 {
                                let vc = HomeEmptyViewController()
                                strongSelf.navigationController?.setViewControllers([vc], animated: true)
                            } else if response.count == 1 {
                                let vc = DefaultWorkSpaceViewController.shared
                                owner.session.assignWorkspace(spaces: response)
                                UserDefaults.createRecentWorkspace(workspaces: response)
                                strongSelf.navigationController?.setViewControllers([vc], animated: true)
                            } else {
                                let vc = DefaultWorkSpaceViewController.shared
                                let sortedReponse  = owner.viewModel.sortResponseByDate(response)
                                owner.session.assignWorkspace(spaces: sortedReponse)
                                strongSelf.navigationController?.setViewControllers([vc], animated: true)
                            }
                                
                        case .failure(let error):
                            print("로그인망함",error.errorCode)
                        }
                    }
                    .disposed(by: strongSelf.disposeBag)
            }
        }
    }
    
    private func setConstraints() {
        
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
