//
//  PurchaseButton.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 3/1/24.
//

import UIKit
import RxSwift
import RxCocoa

final class PurchaseButton: UIButton {
    
    private var title = BehaviorRelay<String>(value: "")
    private let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(title: String) {
        self.init(frame: .zero)
        self.title.accept(title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.layer.cornerRadius = 8
        title
            .subscribe(with: self) { owner, title in
                var configuration = UIButton.Configuration.plain()
                var attrTitle = AttributedString(title)
                attrTitle.font = Typography.title2
                configuration.attributedTitle = attrTitle
                
                var background = UIBackgroundConfiguration.listPlainCell()
                background.backgroundColor = Colors.Brand.identity
                
                configuration.background = background
                configuration.background.cornerRadius = 8
                configuration.baseForegroundColor = .white
                
                self.configuration = configuration
                self.contentHorizontalAlignment = .center
            }
            .disposed(by: disposeBag)
    }
    
    func defineTitle(title: String) {
        self.title.accept(title)
    }
}
