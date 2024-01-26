//
//  MemberListCell.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/26/24.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift


final class MemberListCell: UITableViewCell {
    
    var data = PublishSubject<WorkspaceMember>()
    
    private let container = UIView()
    private let profileImage = UIImageView()
    private let nameLabel = CustomTitleLabel("",
                                                 textColor: .black,
                                                 font: Typography.bodyBold ??
                                                 UIFont.systemFont(ofSize: 13))
    private let emailLabel = CustomTitleLabel("",
                                               textColor: .black,
                                               font: Typography.body ??
                                               UIFont.systemFont(ofSize: 13))
    
    private lazy var detailStackView = {
        let sv = UIStackView(arrangedSubviews: [nameLabel, emailLabel])
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .leading
        sv.spacing = 0
        return sv
    }()
    
    private var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        bind()
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func configure() {
        contentView.addSubview(container)
        contentView.backgroundColor = .clear
        self.selectionStyle = .none
        container.addSubview(profileImage)
        container.addSubview(detailStackView)
        container.layer.cornerRadius = 8
        container.clipsToBounds = true
        profileImage.layer.cornerRadius = 8
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFill
        emailLabel.textColor = Colors.Text.secondary
    }
    
    private func setConstraints() {
        
        container.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(14)
            make.trailing.equalToSuperview().inset(8)
            make.height.equalToSuperview().inset(3)
            make.centerY.equalToSuperview()
        }
        
        profileImage.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        detailStackView.snp.makeConstraints { make in
            make.centerY.equalTo(profileImage)
            make.height.equalTo(36)
            make.leading.equalTo(profileImage.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
        }
    }
    
    private func bind() {
        data.subscribe(with: self) { owner, data in
            guard let profileImage = data.profileImage else { return }
            let url = EndPoints.imageBaseURL + profileImage
            guard let urlString = URL(string: url) else { return }
            owner.profileImage.kf.setImage(with: urlString)
            owner.nameLabel.text = data.nickname
            owner.emailLabel.text = data.email
        }
        .disposed(by: disposeBag)
    }

}
