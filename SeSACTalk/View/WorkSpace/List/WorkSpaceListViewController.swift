//
//  WorkSpaceListViewController.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/18/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa



final class WorkSpaceListViewController: UIViewController {

    
    private let mainTitle = CustomTitleLabel(ScreenTitles.WorkspaceList.mainTitle,
                                               textColor: .black,
                                               font: Typography.title1 ??
                                               UIFont.systemFont(ofSize: 22))
    private let subTitle = CustomTitleLabel(ScreenTitles.WorkSpaceInitial.requireNewWorkSpace,
                                                  textColor: .black, 
                                                  font: Typography.body ??
                                                  UIFont.systemFont(ofSize: 13))
    
    private let createWorkSpaceButton = CustomButton(title: ScreenTitles.WorkSpaceInitial.createWorkSpace)

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        setConstraints()
    }
    
    private func configure() {
        view.backgroundColor = .white
        navigationController?.setWorkSpaceListNavigation()
        view.addSubview(mainTitle)
        view.addSubview(subTitle)
        view.addSubview(createWorkSpaceButton)
        createWorkSpaceButton.validationBinder.onNext(true)
    }
    
    private func setConstraints() {
        mainTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(183)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(60)
        }
        
        subTitle.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(mainTitle)
            make.top.equalTo(mainTitle.snp.bottom).offset(19)
            make.height.equalTo(75)
        }
        
        createWorkSpaceButton.snp.makeConstraints { make in
            make.top.equalTo(subTitle.snp.bottom)
            make.horizontalEdges.equalTo(mainTitle)
            make.height.equalTo(44)
        }
    }

}
