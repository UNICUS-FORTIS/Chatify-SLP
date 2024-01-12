//
//  NewWorkSpaceViewController.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/12/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


final class WorkSpaceEditViewController: UIViewController {


    private let spaceImage = CustomSpaceImageView()
    private let spaceName = CustomInputView(label: "워크스페이스 이름", placeHolder: "", keyboardType: .default)
    private let spaceDescription = CustomInputView(label: "워크스페이스 설명", placeHolder: "", keyboardType: .default)
    private let createButton = CustomButton(title: "완료")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setConstraints()
    }
    
    private func configure() {
        navigationController?.setStartingAppearance(title: "워크스페이스 생성",
                                                    target: self,
                                                    action: nil)
        view.addSubview(spaceImage)
        view.addSubview(spaceName)
        view.addSubview(spaceDescription)
        view.addSubview(createButton)
        view.backgroundColor = Colors.Background.primary
        
    }
    
    private func setConstraints() {
        spaceImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.size.equalTo(70)
            make.centerX.equalToSuperview()
        }
        
        spaceName.snp.makeConstraints { make in
            make.top.equalTo(spaceImage.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(76)
            make.centerX.equalToSuperview()
        }
        
        spaceDescription.snp.makeConstraints { make in
            make.top.equalTo(spaceName.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(76)
            make.centerX.equalToSuperview()
        }
        
        createButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-45)
        }
    }

}
