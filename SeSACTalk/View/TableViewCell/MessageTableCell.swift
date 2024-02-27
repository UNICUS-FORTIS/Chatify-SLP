//
//  MessageCVCell.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher



final class MessageTableCell: UITableViewCell {
        
    private let profileImage = UIImageView(image: .dummyTypeA)
    
    private let nickname = CustomTitleLabel("",
                                            textColor: Colors.Brand.inactive,
                                            font: Typography.body ??
                                            UIFont.systemFont(ofSize: 13))
    
    private let sentTime = CustomTitleLabel("",
                                            textColor: Colors.Text.secondary,
                                            font: Typography.caption2 ??
                                            UIFont.systemFont(ofSize: 11))
    
    private let communications = ChatBubbleLabel(text: "")
    
    private let pictureContainer = UIView(frame: .zero)
    
    // MARK: - 프로파일 컨테이너 생성안함.
    // MARK: - 채팅 / 사진 컨테이너
    private lazy var bodyContainer: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [communications, pictureContainer])
        sv.axis = .vertical
        sv.spacing = 5
        sv.alignment = .leading
        sv.distribution = .fill
        return sv
    }()
    
    // MARK: - 시간 컨테이너
    private lazy var sentTimeContainer: UIView = {
        let view = UIView()
        view.addSubview(sentTime)
        return view
    }()
    
    // MARK: - 채팅 / 사진 컨테이너 + 타임 컨테이너
    private lazy var bottomContainer: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [bodyContainer, sentTimeContainer])
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .leading
        sv.distribution = .fill
        return sv
    }()
    
    // MARK: - 닉네임 + 채팅/사진 컨테이너
    private lazy var contentsContainer: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [nickname, bottomContainer])
        sv.axis = .vertical
        sv.spacing = 5
        sv.alignment = .leading
        sv.distribution = .fill
        return sv
    }()
    
    private lazy var mainStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [profileImage,
                                                contentsContainer])
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 8
        sv.alignment = .leading
        return sv
    }()
    
    private var disposeBag = DisposeBag()
    
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
        nickname.text = nil
        communications.text = nil
        sentTime.text = nil   
    }
    
    private func configure() {
        contentView.addSubview(mainStackView)
        self.selectionStyle = .none
        
        profileImage.layer.cornerRadius = 8
        profileImage.clipsToBounds = true
        sentTime.numberOfLines = 1

    }
    
    private func setConstraints() {
        
        profileImage.snp.makeConstraints { make in
            make.size.equalTo(34)
        }
        
        nickname.snp.makeConstraints { make in
            make.top.equalTo(profileImage)
            make.height.equalTo(nickname.font.lineHeight)
        }
       
        sentTime.snp.makeConstraints { make in
            make.bottom.equalTo(contentsContainer.snp.bottom).inset(6)
            make.width.equalToSuperview()
        }
        
        sentTimeContainer.snp.makeConstraints { make in
            make.height.equalTo(bodyContainer)
            make.width.greaterThanOrEqualTo(sentTime.intrinsicContentSize.width).priority(999)
        }
        
        contentsContainer.snp.makeConstraints { make in
            DispatchQueue.main.async {
                make.width.lessThanOrEqualTo(self.contentsContainer.intrinsicContentSize.width).priority(999)
                make.height.equalTo(self.contentsContainer.intrinsicContentSize.height)
            }
        }
        
        mainStackView.snp.makeConstraints { make in
            make.leading.equalTo(self)
            make.trailing.equalTo(self).inset(30)
            make.top.bottom.equalToSuperview().inset(8)
        }
    }
    
    func bind(chatData: ChannelDataSource) {
        nickname.text = chatData.user.nickname
        communications.text = chatData.content
        sentTime.text = chatData.createdAt.chatDateString()
        
        guard let profileImgURL = chatData.user.profileImage else { return }
        let urlString = EndPoints.imageBaseURL + profileImgURL
        let url = URL(string: urlString)
        profileImage.kf.setImage(with: url)
        profileImage.contentMode = .scaleAspectFill
    }
    
    func bind(dmData: DMDataSource) {
        nickname.text = dmData.user.nickname
        communications.text = dmData.content
        sentTime.text = dmData.createdAt.chatDateString()
        
        guard let profileImgURL = dmData.user.profileImage else { return }
        let urlString = EndPoints.imageBaseURL + profileImgURL
        let url = URL(string: urlString)
        profileImage.kf.setImage(with: url)
        profileImage.contentMode = .scaleAspectFill
    }
}
