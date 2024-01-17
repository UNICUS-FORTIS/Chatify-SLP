//
//  WorkSpaceAddButton.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/18/24.
//

import UIKit
import SnapKit

final class SideMenuButton: UIButton {
    
    private let symbolIcon = UIImageView(image: .plus)
    private let name = CustomTitleLabel("",
                                        textColor: Colors.Text.secondary,
                                        font: Typography.body ??
                                        UIFont.systemFont(ofSize: 13))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraints()
    }
    
    convenience init(title: String, icon: UIImage) {
        self.init(frame: .zero)
        self.name.text = title
        self.symbolIcon.image = icon
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.addSubview(symbolIcon)
        self.addSubview(name)
        self.backgroundColor = .clear
    }
    
    private func setConstraints() {
        symbolIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(18)
            make.leading.equalToSuperview().inset(16)
        }
        
        name.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(symbolIcon.snp.trailing).offset(16)
            make.height.equalTo(28)
        }
    }
}
