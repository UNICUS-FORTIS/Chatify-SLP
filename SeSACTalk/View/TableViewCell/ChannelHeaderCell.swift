//
//  ChannelHeaderCell.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/13/24.
//

import UIKit
import SnapKit


final class ChannelHeaderCell: UITableViewHeaderFooterView {
    
    
    private let name = CustomTitleLabel("",
                                        textColor: .black,
                                        font: Typography.createTitle2())
    
    private let moreButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = .chevronDown
        configuration.imagePlacement = .all
        configuration.baseForegroundColor = .clear
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.contentHorizontalAlignment = .leading
        return button
    }()
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
        setConstraints()
    }
    
    private func configure() {
        self.addSubview(name)
        self.addSubview(moreButton)
        self.backgroundColor = .clear
    }
    
    private func setConstraints() {
        name.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
            make.height.equalTo(28)
        }
        
        moreButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(24)
            make.width.equalTo(26.79)
            make.trailing.equalToSuperview().inset(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHeaderTitle(title: String) {
        self.name.text = title
    }
}
