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
    private let mainTitle = CustomTitleLabel(ScreenTitles.Onboarding.mainTitle)
    private let startButton = CustomButton(title: ScreenTitles.Onboarding.startButton)
    private var fpc: FloatingPanelController!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
        setFloatingPanel()
    }
    
    
    private func configure() {
        view.backgroundColor = Colors.Background.primary
        view.addSubview(mainImage)
        view.addSubview(mainTitle)
        view.addSubview(startButton)
        mainImage.contentMode = .scaleAspectFit
        startButton.validationBinder.onNext(true)
        
        startButton.addTarget(self, action: #selector(presentBottomSheet), for: .touchUpInside)
    }
    
    private func setFloatingPanel() {
        fpc = FloatingPanelController()
        let appearance = SurfaceAppearance()
        let contentVC = OnboadingBottomSheetViewController()
        contentVC.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: 300)
        
        appearance.cornerRadius = 10
        fpc.isRemovalInteractionEnabled = true
        fpc.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        fpc.layout = OnboardingFloatingPanelLayout()
        fpc.surfaceView.appearance = appearance
        fpc.set(contentViewController: contentVC)
    }

    
    @objc private func presentBottomSheet() {
        self.present(fpc, animated: true, completion: nil)
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
