//
//  OnlyConfirmBox.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/25/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


final class OnlyConfirmBox: UIView {
    
    private let interactionType = PublishSubject<InteractionConfirmAcceptable>()
    private let boxTitle = CustomTitleLabel("",
                                            textColor: .black,
                                            font: Typography.title2 ??
                                            UIFont.systemFont(ofSize: 13))
    private let boxDescriprion = CustomTitleLabel("",
                                                  textColor: Colors.Text.secondary,
                                                  font: Typography.body ??
                                                  UIFont.systemFont(ofSize: 13))
    
    private let confirmButton = CustomButton(title: "")
    
    private lazy var informationStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [boxTitle, boxDescriprion])
        sv.axis = .vertical
        sv.distribution = .fill
        sv.spacing = 8
        sv.alignment = .center
        return sv
    }()
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraints()
        bind()
    }
    
    convenience init(type: InteractionConfirmAcceptable) {
        self.init(frame: .zero)
        self.interactionType.onNext(type)
        self.confirmButton.validationBinder.onNext(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
        self.addSubview(informationStackView)
        self.addSubview(confirmButton)
    }
    
    private func setConstraints() {
        informationStackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(informationStackView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
    }
    
    private func bind() {
        interactionType
            .subscribe(with: self) { owner, type in
                owner.boxTitle.text = type.title
                owner.boxDescriprion.text = type.description
                owner.confirmButton.defineTitle(title: type.confirmButton)
            }
            .disposed(by: disposeBag)
    }
    
    func setConfirmButtonAction(target: UIViewController,action: Selector) {
        confirmButton.addTarget(target, action: action, for: .touchUpInside)
    }

}
