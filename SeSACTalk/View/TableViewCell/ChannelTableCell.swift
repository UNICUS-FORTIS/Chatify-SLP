//
//  ChannelTableCell.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/12/24.
//

import UIKit
import SnapKit
import Kingfisher



final class ChannelTableViewCell: UITableViewCell {
    
    
    private let symbolIcon = UIImageView(image: .hashTagThin)
    private let name = CustomTitleLabel("", 
                                        textColor: Colors.Text.primary,
                                        font: Typography.body ??
                                        UIFont.systemFont(ofSize: 13))
    private var badge = ChatBadgeLabel()

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
        name.text = nil
        name.font = Typography.body
        name.textColor = Colors.Text.primary
    }
    
    private func configure() {
        self.addSubview(symbolIcon)
        self.addSubview(name)
        self.addSubview(badge)
        self.selectionStyle = .none
        self.badge.isHidden = true
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
        
        badge.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(17)
        }
    }
    
    func setLabel(text: String,
                  badgeCount: Int) {
        self.name.text = text
        if badgeCount == 0 {
            self.symbolIcon.image = .hashTagThin
            self.name.font = Typography.createBody()
            self.name.textColor = Colors.Text.secondary
            self.badge.isHidden = true
        } else {
            self.badge.isHidden = false
            self.symbolIcon.image = .hashTag
            self.badge.text = "\(badgeCount)"
            self.name.font = Typography.createBodyBold()
            self.name.textColor = .black
        }
    }
}
