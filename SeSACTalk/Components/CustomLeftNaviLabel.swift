//
//  TestView.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/25/24.
//

import UIKit
import SnapKit
import RxSwift


final class CustomLeftNaviLabel: UILabel {
    
    var buttonTitle = BehaviorSubject<String>(value: "No WorkSpace")
    let button = UIButton()
    private let disposeBag = DisposeBag()
    
    
    override init(frame: CGRect) {
        super.init(frame: .init(x: 0, y: 0, width: 200, height: 0))
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.isUserInteractionEnabled = true
        self.font = Typography.title1 ?? UIFont.systemFont(ofSize: 22)
        self.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    private func bind() {
        buttonTitle
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, title in
                self.text = title
                owner.configure()
            }
            .disposed(by: disposeBag)
    }
    
    
}
