//
//  DMTableCell.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/16/24.
//

import UIKit
import SnapKit
import Kingfisher



final class DMTableCell: UITableViewCell {
    
    
    private let symbolIcon = UIImageView(image: .dummyTypeA)
    private let name = CustomTitleLabel("",
                                        textColor: Colors.Text.primary,
                                        font: Typography.createBody())
    private var badge = UIView(frame: .zero)
    private let badgeCount = CustomTitleLabel("",
                                              textColor: .white,
                                              font: Typography.createCaption())
    
    
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
        name.textColor = Colors.Text.primary
        badgeCount.text = ""
    }
    
    private func configure() {
        self.addSubview(symbolIcon)
        self.addSubview(name)
        self.addSubview(badge)
        self.selectionStyle = .none
        badge.addSubview(badgeCount)
        badge.backgroundColor = Colors.Brand.green
        badge.layer.cornerRadius = 8
        badge.clipsToBounds = true
        symbolIcon.layer.cornerRadius = 4
        symbolIcon.clipsToBounds = true
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
    
    func setDms(data: DMs) {
        if let safeImage = data.user.profileImage {
            let url = EndPoints.baseURL + safeImage
            let urlString = URL(string: url)
            symbolIcon.kf.setImage(with: urlString)
        }
        
        name.text = data.user.nickname
        badgeCount.text = "\(5)"
    }
}
