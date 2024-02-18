//
//  CustomInputAccView.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/5/24.
//

import UIKit
import SnapKit
import RxSwift



final class CustomInputAccView: UIView {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.textAlignment = .left
        tv.layer.cornerRadius = 8
        tv.textContainer.maximumNumberOfLines = 0
        tv.clipsToBounds = true
        tv.backgroundColor = .clear
        tv.textContainer.lineBreakMode = .byWordWrapping
        tv.font = Typography.body
        tv.text = "메세지를 입력하세요"
        tv.textColor = Colors.Text.secondary
        tv.sizeToFit()
        return tv
    }()
    
    private let leftButton = ChatButton(.plus)
    var rightButton = ChatButton(.chatIcon)
    private let disposeBag = DisposeBag()
    
    private lazy var textObservable = textView.rx.text.orEmpty.map { !$0.isEmpty }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.backgroundColor = Colors.Background.primary
        self.addSubview(textView)
        self.addSubview(leftButton)
        self.addSubview(rightButton)
    }
    
    func setConstraints() {
        leftButton.snp.makeConstraints { make in
            make.size.equalTo(22)
            make.leading.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(9)
        }
        
        rightButton.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(7)
        }
        
        textView.snp.makeConstraints { make in
            make.leading.equalTo(leftButton.snp.trailing).offset(8)
            make.trailing.equalTo(rightButton.snp.leading).inset(-8)
            make.top.bottom.equalToSuperview().inset(4)
        }
    }
    
    private func bind() {
        textObservable
            .map { text in
                return text ?
                    .chatIconColored :
                    .chatIcon
            }
            .bind(to: rightButton.rx.image(for: .normal))
            .disposed(by: disposeBag)
    }
}
