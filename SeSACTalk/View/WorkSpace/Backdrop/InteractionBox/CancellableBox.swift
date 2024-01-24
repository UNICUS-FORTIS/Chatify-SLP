//
//  ConfirmBox.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/24/24.
//

import UIKit
import SnapKit
import RxSwift


final class CancellableBox: UIView {
    
    private let interactionType = PublishSubject<InteractionTypeCancellable>()
    private let boxTitle = CustomTitleLabel("",
                                            textColor: .black,
                                            font: Typography.title2 ??
                                            UIFont.systemFont(ofSize: 13))
    private let boxDescriprion = CustomTitleLabel("",
                                                  textColor: Colors.Text.secondary,
                                                  font: Typography.body ??
                                                  UIFont.systemFont(ofSize: 13))
    
    private let leftButton = CustomButton(title: "")
    private let rightButton = CustomButton(title: "")
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
    
    convenience init(type: InteractionTypeCancellable) {
        self.init(frame: .zero)
        self.interactionType.onNext(type)
        self.rightButton.validationBinder.onNext(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
        self.addSubview(informationStackView)
        self.addSubview(leftButton)
        self.addSubview(rightButton)
    }
    
    
    private func setConstraints() {
        informationStackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        
        leftButton.snp.makeConstraints { make in
            make.top.equalTo(informationStackView.snp.bottom).offset(16)
            make.bottom.equalToSuperview().inset(16)
            make.leading.equalTo(informationStackView.snp.leading)
            make.trailing.equalTo(self.snp.centerX).inset(4)
            make.height.equalTo(44)
        }
        
        rightButton.snp.makeConstraints { make in
            make.top.equalTo(informationStackView.snp.bottom).offset(16)
            make.bottom.equalToSuperview().inset(16)
            make.leading.equalTo(self.snp.centerX).offset(4)
            make.trailing.equalTo(informationStackView.snp.trailing)
            make.height.equalTo(44)
        }
    }
    
    private func bind() {
        interactionType
            .subscribe(with: self) { owner, type in
                owner.boxTitle.text = type.title
                owner.boxDescriprion.text = type.description
                owner.leftButton.defineTitle(title: type.leftButton)
                owner.rightButton.defineTitle(title: type.rightButton)
            }
            .disposed(by: disposeBag)
    }
    
    func setCancelButtonAction(target: UIViewController,action: Selector) {
        leftButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setConfirmButtonAction(target: UIViewController,action: Selector) {
        rightButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
