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
    
    
    private let profileImage = CustomSpaceImageView(frame: .zero)
    private let name = CustomTitleLabel("",
                                        textColor: Colors.Text.primary,
                                        font: Typography.createBody())
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
        profileImage.image = .dummyTypeA
        name.text = nil
        name.textColor = Colors.Text.primary
        badge.text = ""
        badge.isHidden = true
    }
    
    private func configure() {
        self.addSubview(profileImage)
        self.addSubview(name)
        self.addSubview(badge)
        self.selectionStyle = .none
        profileImage.setImage(image: .dummyTypeA)
        profileImage.inactiveCameraIcon()
    }
    
    private func setConstraints() {
        profileImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(18)
            make.leading.equalToSuperview().inset(16)
        }
        
        name.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(profileImage.snp.trailing).offset(16)
            make.height.equalTo(28)
        }
        
        badge.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(17)
        }
    }
    
    func setDms(data: DMs, badgeCount: Int) {
        if let safeImage = data.user.profileImage {
            let url = EndPoints.baseURL + safeImage
            let urlString = URL(string: url)
            profileImage.kf.setImage(with: urlString)
        }
        
        name.text = data.user.nickname
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
