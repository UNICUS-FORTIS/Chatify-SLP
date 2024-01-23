//
//  WorkSpaceListingCell.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/19/24.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift


final class WorkSpaceListingCell: UITableViewCell {
    
    var data = PublishSubject<WorkSpace>()
    
    var selection = PublishSubject<Bool>()
    
    var showWorkspaceSheet: ( () -> Void )?
    
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
    
    private let moreIcon:UIButton = {
        let btn = UIButton()
        btn.setImage(.threeDotsBlack, for: .normal)
        return btn
    }()
    
    private lazy var detailStackView = {
        let sv = UIStackView(arrangedSubviews: [workspaceName, createdDate])
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .leading
        sv.spacing = 0
        return sv
    }()
    
    private var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        showWorkspaceSheet = nil
    }
    
    private func configure() {
        contentView.addSubview(container)
        contentView.backgroundColor = .clear
        self.selectionStyle = .none
        container.addSubview(workspaceImage)
        container.addSubview(detailStackView)
        container.addSubview(moreIcon)
        container.layer.cornerRadius = 8
        container.clipsToBounds = true
        workspaceImage.layer.cornerRadius = 8
        workspaceImage.clipsToBounds = true
        workspaceImage.contentMode = .scaleAspectFill
        createdDate.textColor = Colors.Text.secondary
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
    
    private func bind() {
        data.subscribe(with: self) { owner, data in
            let url = EndPoints.imageBaseURL + data.thumbnail
            guard let urlString = URL(string: url) else { return }
            owner.workspaceImage.kf.setImage(with: urlString)
            owner.workspaceName.text = data.name
            owner.createdDate.text = data.createdAt.convertDateString()
            owner.moreIcon.addTarget(self,
                                     action: #selector(owner.moreIconTapped),
                                     for: .touchUpInside)
        }
        .disposed(by: disposeBag)
        
        selection.subscribe(with: self) { owner, selection in
            owner.container.backgroundColor = selection ? Colors.Brand.gray : .clear
        }
        .disposed(by: disposeBag)
    }
    
    @objc private func moreIconTapped() {
        guard let safe = showWorkspaceSheet else { return }
        safe()
    }
}
