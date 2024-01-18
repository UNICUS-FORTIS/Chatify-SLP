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

    static let shared = WorkSpaceListViewController()
    
    private let mainTitle = CustomTitleLabel(ScreenTitles.WorkspaceList.mainTitle,
                                               textColor: .black,
                                               font: Typography.title1 ??
                                               UIFont.systemFont(ofSize: 22))
    private let subTitle = CustomTitleLabel(ScreenTitles.WorkSpaceInitial.requireNewWorkSpace,
                                                  textColor: .black, 
                                                  font: Typography.body ??
                                                  UIFont.systemFont(ofSize: 13))
    
    private let createWorkSpaceButton = CustomButton(title: ScreenTitles.WorkSpaceInitial.createWorkSpace)
    
    private let addNewWorkSpaceButton = SideMenuButton(title: "워크스페이스 추가", icon: .plus)
    private let helpButton = SideMenuButton(title: "도움말", icon: .help)

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        setConstraints()
    }
    
    private func configure() {
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        view.layer.masksToBounds = true
        navigationController?.setWorkSpaceListNavigation()
        view.addSubview(mainTitle)
        view.addSubview(subTitle)
        view.addSubview(createWorkSpaceButton)
        view.addSubview(addNewWorkSpaceButton)
        view.addSubview(helpButton)

        createWorkSpaceButton.validationBinder.onNext(true)

    
    }
    
    private func setConstraints() {
        mainTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(183)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
        }
        
        subTitle.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(mainTitle)
            make.top.equalTo(mainTitle.snp.bottom).offset(19)
            make.centerX.equalToSuperview()
            make.height.equalTo(75)
        }
        
        createWorkSpaceButton.snp.makeConstraints { make in
            make.top.equalTo(subTitle.snp.bottom)
            make.horizontalEdges.equalTo(mainTitle)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
        }
        
        helpButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(41)
        }
        
        addNewWorkSpaceButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(helpButton.snp.top)
            make.centerX.equalToSuperview()
            make.height.equalTo(41)
        }
    }

}
