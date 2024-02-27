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
                                            font: Typography.createCaption2())
    
    private let communications = ChatBubbleLabel(text: "")
    
    private let pictureContainer = UIView(frame: .zero)
    
    private lazy var bodyContainer: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [communications, pictureContainer])
        sv.axis = .vertical
        sv.spacing = 5
        sv.alignment = .trailing
        sv.distribution = .fill
        return sv
    }()
    
    private lazy var sentTimeContainer: UIView = {
        let view = UIView()
        view.addSubview(sentTime)
        return view
    }()
    
    private lazy var bottomContainer: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [sentTimeContainer, bodyContainer])
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .trailing
        sv.distribution = .fill
        return sv
    }()
    
    private lazy var contentsContainer: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [bottomContainer])
        sv.axis = .vertical
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
        setConstraints()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        communications.text = nil
        sentTime.text = nil
    }
    
    private func configure() {
        contentView.addSubview(mainStackView)
        self.selectionStyle = .none

        sentTime.numberOfLines = 1
    }
    
    
    private func setConstraints() {
       
        sentTime.snp.makeConstraints { make in
            make.bottom.equalTo(contentsContainer.snp.bottom).inset(6)
            make.width.equalToSuperview()
        }
        
        sentTimeContainer.snp.makeConstraints { make in
            make.height.equalTo(bodyContainer)
            make.width.greaterThanOrEqualTo(sentTime.intrinsicContentSize.width).priority(999)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.leading.equalTo(self)
            make.trailing.equalTo(self).inset(30)
            make.top.bottom.equalToSuperview().inset(8)
        }
    }
    
    func bind(channelData: ChannelDataSource) {
        communications.text = channelData.content
        sentTime.text = channelData.createdAt.chatDateString()
    }
    
    func bind(dmData: DMDataSource) {
        communications.text = dmData.content
        sentTime.text = dmData.createdAt.chatDateString()
    }
}



