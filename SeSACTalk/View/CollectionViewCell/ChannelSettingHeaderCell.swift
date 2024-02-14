//
//  ChannelSettingHeaderCell.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/14/24.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

final class ChannelSettingHeaderCell: UICollectionReusableView {
    
    private let memberLabel = CustomLabel("", font: Typography.createTitle2())
    private let morebutton = CustomButton(.chevronDown)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        self.addSubview(memberLabel)
        self.addSubview(morebutton)

    }
    
    
    private func setConstraints() {
        
        memberLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
        
        morebutton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
}
