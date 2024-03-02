//
//  DMListTableCell.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/28/24.
//

import UIKit
import SnapKit


final class DMListTableCell: UITableViewCell {
    
    private let profileImage = CustomSpaceImageView(frame: .zero)
    private let name = CustomTitleLabel("",
                                        textColor: .black,
                                        font: Typography.createCaption())
    private let latestChat = CustomTitleLabel("",
                                        textColor: Colors.Text.secondary,
                                        font: Typography.createCaption2())
    
    private let receivedTime = CustomTitleLabel("",
                                               textColor: Colors.Text.secondary,
                                               font: Typography.createCaption2())
    
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
        profileImage.image = nil
        name.text = nil
        latestChat.text = nil
        receivedTime.text = nil
        badge.text = nil
    }
    
    private func configure() {
        contentView.addSubview(profileImage)
        contentView.addSubview(name)
        contentView.addSubview(latestChat)
        contentView.addSubview(receivedTime)
        contentView.addSubview(badge)
        self.badge.isHidden = true
        self.selectionStyle = .none
        name.textAlignment = .left
        latestChat.textAlignment = .left
        latestChat.numberOfLines = 2
        receivedTime.textAlignment = .right
        profileImage.setImage(image: .dummyTypeA)
        profileImage.inactiveCameraIcon()
    }
    
    private func setConstraints() {
        profileImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(34)
            make.leading.equalToSuperview().inset(16)
        }
        
        name.snp.makeConstraints { make in
            make.top.equalTo(profileImage)
            make.leading.equalTo(profileImage.snp.trailing).offset(8)
            make.trailing.equalTo(receivedTime.snp.leading)
            make.height.equalTo(18)
        }
        
        latestChat.snp.makeConstraints { make in
            make.top.equalTo(name.snp.bottom).offset(6)
            make.leading.equalTo(name)
            make.trailing.lessThanOrEqualTo(badge.snp.leading)
        }
        
        receivedTime.snp.makeConstraints { make in
            make.top.equalTo(name)
            make.trailing.equalToSuperview().inset(24)
            make.height.equalTo(name)
            make.width.equalTo(receivedTime.snp.width)
        }
        
        badge.snp.makeConstraints { make in
            make.top.equalTo(latestChat)
            make.height.equalTo(18)
            make.width.greaterThanOrEqualTo(20)
            make.trailing.equalTo(receivedTime)
        }
    }
    
    func bind(data: DMs, badgeCount: Int) {
        if let safeImage = data.user.profileImage {
            let url = EndPoints.baseURL + safeImage
            let urlString = URL(string: url)
            profileImage.kf.setImage(with: urlString)
        }
        name.text = data.user.nickname
        latestChat.text = "안녕하세요 테스트입니다."
        receivedTime.text = data.createdAt.chatDateString()
        if badgeCount == 0 {
            self.name.font = Typography.createBody()
            self.name.textColor = Colors.Text.secondary
            self.badge.isHidden = true
        } else {
            self.badge.isHidden = false
            self.badge.text = "\(badgeCount)"
            self.name.font = Typography.createBodyBold()
            self.name.textColor = .black
        }
    }
}
