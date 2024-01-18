//
//  WorkSpaceListingCell.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/19/24.
//

import UIKit
import SnapKit
import Kingfisher


final class WorkSpaceListingCell: UITableViewCell {
    
    var data: WorkSpace? {
        didSet {
            guard let safe = data else { return }
            let url = EndPoints.imageBaseURL + safe.thumbnail
            guard let urlString = URL(string: url) else { return }
            workspaceImage.kf.setImage(with: urlString)
            
            workspaceName.text = safe.name
            createdDate.text = safe.createdAt.convertDateString()
        }
    }
    
    var selection: Bool? {
        didSet {
            guard let safe = selection else { return }
            container.backgroundColor = safe ? Colors.Brand.gray : .clear
        }
    }

    
    private let container = UIView()
    private let workspaceImage = UIImageView()
    private let workspaceName = CustomTitleLabel("",
                                                 textColor: .black,
                                                 font: Typography.bodyBold ??
                                                 UIFont.systemFont(ofSize: 13))
    private let createdDate = CustomTitleLabel("",
                                                 textColor: .black,
                                                 font: Typography.body ??
                                                 UIFont.systemFont(ofSize: 13))
    
    private let moreIcon: UIImageView = UIImageView(image: .threeDotsBlack)
    
    private lazy var detailStackView = {
       let sv = UIStackView(arrangedSubviews: [workspaceName, createdDate])
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .leading
        sv.spacing = 0
        return sv
    }()
    
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
        container.backgroundColor = .clear
        workspaceImage.image = nil
        workspaceName.text = nil
        createdDate.text = nil
    }
    
    private func configure() {
        self.addSubview(container)
        container.addSubview(workspaceImage)
        container.addSubview(detailStackView)
        container.addSubview(moreIcon)
        container.layer.cornerRadius = 8
        container.clipsToBounds = true
        self.backgroundColor = .clear
        workspaceImage.layer.cornerRadius = 8
        workspaceImage.clipsToBounds = true
        createdDate.textColor = Colors.Text.secondary
        self.selectionStyle = .none
    }
    
    private func setConstraints() {
        
        container.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(7)
            make.trailing.equalToSuperview().inset(5)
            make.height.equalToSuperview().inset(6)
            make.centerY.equalToSuperview()
        }
        
        workspaceImage.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
        }
        
        detailStackView.snp.makeConstraints { make in
            make.centerY.equalTo(workspaceImage)
            make.height.equalTo(36)
            make.leading.equalTo(workspaceImage.snp.trailing).offset(8)
            make.trailing.equalTo(moreIcon.snp.leading).inset(18)
        }
        
        moreIcon.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(12)
        }
    }
    
    
    
}
