//
//  WorkSpaceInitialViewController.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/10/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class WorkSpaceInitialViewController: UIViewController {

    private let viewModel = EmptyWorkSpaceViewModel()
    private let screenTitle = CustomTitleLabel(ScreenTitles.WorkSpaceInitial.mainTitle, 
                                               textColor: .black,
                                               font: Typography.title1 ??
                                               UIFont.systemFont(ofSize: 22))
    
    private lazy var screenSubTitle = CustomTitleLabel(viewModel.storedNickname +
                                                       ScreenTitles.WorkSpaceInitial.subTitle,
                                                       textColor: .black,
                                                  font: Typography.body ??
                                                  UIFont.systemFont(ofSize: 13))
    
    private let createWorkSpaceButton = CustomButton(title: ScreenTitles.WorkSpaceInitial.createWorkSpace)
    
    private let mainImage = UIImageView(image: .launching)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()

    }

    private func configure() {
        view.backgroundColor = Colors.Background.primary
        view.addSubview(screenTitle)
        view.addSubview(screenSubTitle)
        view.addSubview(mainImage)
        view.addSubview(createWorkSpaceButton)

        mainImage.contentMode = .scaleAspectFit
        createWorkSpaceButton.validationBinder.onNext(true)
        navigationController?.setStartingAppearance(title: "시작하기",
                                                  target: self,
                                                  action: #selector(dismissTrigger))
        
    }
    
    @objc private func dismissTrigger() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setConstraints() {
        
        screenTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(35)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(30)
        }
        
        screenSubTitle.snp.makeConstraints { make in
            make.top.equalTo(screenTitle.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(25)
            make.height.equalTo(60)
        }
        
        mainImage.snp.makeConstraints { make in
            make.top.equalTo(screenSubTitle.snp.bottom).offset(15)
            make.horizontalEdges.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
        }
        
        createWorkSpaceButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            make.height.equalTo(44)
        }
    }
    
    
    

}