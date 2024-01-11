//
//  CustomNavigationView.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/11/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


final class CustomNavigationLeftView: UIView {
    
    let leftItem = UIImageView()
    
    
    let naviTitle = CustomTitleLabel("No Workspace",
                                     font: Typography.title1 ??
                                     UIFont.systemFont(ofSize: 22))
    let rightItem = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.addSubview(leftItem)
        self.addSubview(naviTitle)
        
        leftItem.layer.cornerRadius = 8
        leftItem.backgroundColor = .cyan
        naviTitle.textAlignment = .left
    }
    
    private func setConstraints() {
        
        leftItem.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.size.equalTo(32)
            make.centerY.equalToSuperview()
        }
        
        naviTitle.snp.makeConstraints { make in
            make.leading.equalTo(leftItem.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
            make.height.equalTo(35)
        }
        
        
    }
}
