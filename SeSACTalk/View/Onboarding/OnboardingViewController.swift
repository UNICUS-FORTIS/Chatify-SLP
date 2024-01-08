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


final class OnboardingViewController: UIViewController {
    
    
    private let mainImage = UIImageView(image: .onboarding)
    private let mainTitle = CustomTitleLabel(ScreenTitles.Onboarding.mainTitle)
    private let startButton = CustomButton(title: ScreenTitles.Onboarding.startButton)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
    }
    
    
    private func configure() {
        view.backgroundColor = Colors.Background.primary
        view.addSubview(mainImage)
        view.addSubview(mainTitle)
        view.addSubview(startButton)
        mainImage.contentMode = .scaleAspectFit
        startButton.validationBinder.onNext(true)
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
