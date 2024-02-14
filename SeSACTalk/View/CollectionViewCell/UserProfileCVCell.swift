//
//  UserProfileCVCell.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/14/24.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

final class UserProfileCVCell: UICollectionViewCell {
    
    
    private let profileImage = CustomSpaceImageView(frame: .zero)
    private let usernameLabel = CustomLabel("", font: Typography.createBody())
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.backgroundColor = .clear
        contentView.addSubview(profileImage)
        contentView.addSubview(usernameLabel)
    }
    
    
    private func setConstraints() {
        
        profileImage.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
}
