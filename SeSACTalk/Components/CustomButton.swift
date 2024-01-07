//
//  CustomButton.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/3/24.
//

import UIKit
import RxSwift


final class CustomButton: UIButton {
    
    
    private let title: String
    var validationBinder = PublishSubject<Bool>()
    var buttonEnabler = PublishSubject<Bool>()
    private let disposeBag = DisposeBag()
    
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        configure()
        bindColor()
    }
    
    private func configure() {
        self.layer.cornerRadius = 8
        
        var configuration = UIButton.Configuration.plain()
        var title = AttributedString(title)
        title.font = Typegraphy.title2
        
        var background = UIBackgroundConfiguration.listPlainCell()
        background.backgroundColor = Colors.Brand.inactive
        
        configuration.background = background
        configuration.background.cornerRadius = 8
        configuration.baseForegroundColor = .white
        configuration.attributedTitle = title

        self.configuration = configuration
        self.contentHorizontalAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindColor() {
        
        validationBinder
            .subscribe(with: self) { owner, validation in
                var updatedConfiguration = self.configuration
                updatedConfiguration?.background.backgroundColor = validation ?
                Colors.Brand.green :
                Colors.Brand.inactive
                self.configuration = updatedConfiguration
            }
            .disposed(by: disposeBag)
        
        buttonEnabler
            .subscribe(with: self) { owner, validation in
                self.isEnabled = validation
            }
            .disposed(by: disposeBag)
            
    }
}
