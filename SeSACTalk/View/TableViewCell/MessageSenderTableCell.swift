//
//  MessageSenderTableCell.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/4/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher



final class MessageSenderTableCell: UITableViewCell {
    
    var datas = PublishRelay<ChatModel?>()
    
    
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
        sv.alignment = .trailing
        sv.distribution = .fill
        return sv
    }()
    
    // MARK: - 시간 컨테이너
    private lazy var sentTimeContainer: UIView = {
        let view = UIView()
        view.addSubview(sentTime)
        return view
    }()
    
//    // MARK: - 닉네임 + 채팅/사진 컨테이너
    private lazy var contentsContainer: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [sentTimeContainer, bodyContainer])
        sv.axis = .horizontal
        sv.spacing = 5
        sv.alignment = .trailing
        sv.distribution = .fill
        return sv
    }()
    

    private lazy var mainStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [contentsContainer])
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.spacing = 8
        sv.alignment = .trailing
        return sv
    }()
    
    private var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func configure() {
        contentView.addSubview(mainStackView)
        self.selectionStyle = .none
        sentTime.numberOfLines = 1
    }
    
    
    private func setConstraints() {
       
        sentTime.snp.makeConstraints { make in
            make.bottom.equalTo(bodyContainer.snp.bottom).inset(6)
            make.width.equalToSuperview()
        }
        
        sentTimeContainer.snp.makeConstraints { make in
            make.height.equalTo(bodyContainer)
            make.width.greaterThanOrEqualTo(sentTime.intrinsicContentSize.width).priority(999)
        }
        
        bodyContainer.snp.makeConstraints { make in
            DispatchQueue.main.async {
                make.width.lessThanOrEqualTo(self.bodyContainer.intrinsicContentSize.width).priority(999)
                make.height.equalTo(self.bodyContainer.intrinsicContentSize.height)
            }
        }
        
        mainStackView.snp.makeConstraints { make in
            make.trailing.equalTo(self)
            make.leading.equalTo(self).inset(30)
            make.top.bottom.equalToSuperview().inset(8)
        }
    }
    
    private func bind() {
        print("셀 바인드")
        datas
            .asDriver(onErrorJustReturn: nil)
            .drive(with: self) { owner, data in
                guard let data = data else { return }
                owner.communications.text = data.content
                owner.sentTime.text = "08:16 오전"
                owner.setConstraints()
                owner.self.sizeToFit()
            }
            .disposed(by: disposeBag)
    }
}



