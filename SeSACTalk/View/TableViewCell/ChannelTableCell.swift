//
//  ChannelTableCell.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/12/24.
//

import UIKit
import SnapKit



final class ChannelTableViewCell: UITableViewCell {
    
    
    private let symbolIcon = UIImageView(image: .hashTagThin)
    private let name = CustomTitleLabel("", 
                                        textColor: Colors.Text.primary,
                                        font: Typography.body ??
                                        UIFont.systemFont(ofSize: 13))
    private var badge = UIView(frame: .zero)
    private let badgeCount = CustomTitleLabel("",
                                              textColor: .white,
                                              font: Typography.caption ??
                                              UIFont.systemFont(ofSize: 12))
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        symbolIcon.image = nil
        name.text = nil
        name.font = Typography.body
        name.textColor = Colors.Text.primary
    }
    
    private func configure() {
        self.addSubview(symbolIcon)
        self.addSubview(name)
        self.addSubview(badge)
        badge.addSubview(badgeCount)
        badge.backgroundColor = Colors.Brand.green
        badge.layer.cornerRadius = 8
        badge.clipsToBounds = true
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
        
        badgeCount.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(badgeCount.font.lineHeight).multipliedBy(1.26)
        }
        
        badge.snp.makeConstraints { make in
            make.width.equalTo(badgeCount.snp.width).multipliedBy(1.5)
            make.height.equalTo(18)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(17)
        }
    }
    
    func setLabel(text: String,
                  textColor: UIColor,
                  symbol: UIImage,
                  font: UIFont,
                  badgeCount: Int?) {
        self.symbolIcon.image = symbol
        self.name.text = text
        self.name.textColor = textColor
        self.name.font = font
        guard let count = badgeCount else { return }
        if count == 0 {
            self.badge.isHidden = true
        } else {
            self.badge.isHidden = false
        }
    }
}
