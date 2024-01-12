//
//  HomeEmptyViewController.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/11/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HomeEmptyViewController: UIViewController {
    
    private let screenTitle = CustomTitleLabel(ScreenTitles.WorkSpaceInitial.notFoundWorkSpace,
                                               font: Typography.title1 ??
                                               UIFont.systemFont(ofSize: 22))
    private let screenSubTitle = CustomTitleLabel(ScreenTitles.WorkSpaceInitial.requireNewWorkSpace,
                                                  font: Typography.body ??
                                                  UIFont.systemFont(ofSize: 13))
    private let mainImage = UIImageView(image: .workspaceEmpty)
    private let createWorkSpaceButton = CustomButton(title: ScreenTitles.WorkSpaceInitial.createWorkSpace)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setConstraints()
    }
    
    private func configure() {
        
        view.backgroundColor = .white
        view.addSubview(screenTitle)
        view.addSubview(screenSubTitle)
        view.addSubview(mainImage)
        view.addSubview(createWorkSpaceButton)
        mainImage.contentMode = .scaleAspectFit
        createWorkSpaceButton.validationBinder.onNext(true)
        navigationController?.setWorkSpaceNavigation()
      
    }
    
    
    private func setConstraints() {
        screenTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(35)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
        }
        
        screenSubTitle.snp.makeConstraints { make in
            make.top.equalTo(screenTitle.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(25)
        }
        
        mainImage.snp.makeConstraints { make in
            make.top.equalTo(screenSubTitle.snp.bottom).offset(15)
            make.horizontalEdges.equalToSuperview().inset(13)
        }
        
        createWorkSpaceButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            make.height.equalTo(44)
        }
    }
    
    
}
