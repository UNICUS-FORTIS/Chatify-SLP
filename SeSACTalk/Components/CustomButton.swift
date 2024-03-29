//
//  CustomButton.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/3/24.
//

import UIKit
import RxSwift
import RxCocoa


final class CustomButton: UIButton {
    
    
    private var title = BehaviorRelay<String>(value: "")
    private var attrTitle: NSAttributedString?
    private var buttonImage: UIImage?
    var validationBinder = PublishSubject<Bool>()
    var buttonEnabler = PublishSubject<Bool>()
    private let disposeBag = DisposeBag()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(channelEditTitle: String, color: UIColor) {
        self.init(frame: .zero)
        var configuration = UIButton.Configuration.plain()

        var attrTitle = AttributedString(channelEditTitle)
        attrTitle.font = Typography.title2
        attrTitle.foregroundColor = color
        configuration.attributedTitle = attrTitle
        
        var background = UIBackgroundConfiguration.listPlainCell()
        background.backgroundColor = .white
        configuration.background = background
        self.configuration = configuration
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.clipsToBounds = true
    }
    
    convenience init(title: String) {
        self.init(frame: .zero)
        self.title.accept(title)
        configure()
        bindColor()
    }
    
    convenience init(title: NSAttributedString) {
        self.init(frame: .zero)
        configure()
        bindColor()
    }
    
    convenience init(_ image: UIImage) {
        self.init(title: "")
        var configuration = UIButton.Configuration.plain()
        var background = UIBackgroundConfiguration.listPlainCell()
        background.backgroundColor = .clear
        configuration.background = background
        configuration.image = image
        self.configuration = configuration
    }
    
    convenience init(title: String, _ image: UIImage) {
        self.init(title: title)
        self.buttonImage = image
        configure()
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
                background.backgroundColor = Colors.Brand.inactive
                
                if let image = self.buttonImage {
                    configuration.image = image
                    configuration.imagePadding = 4
                }
                
                configuration.background = background
                configuration.background.cornerRadius = 8
                configuration.baseForegroundColor = .white
                
                self.configuration = configuration
                self.contentHorizontalAlignment = .center
            }
            .disposed(by: disposeBag)
    }
    
    private func bindColor() {
        
        validationBinder
            .subscribe(with: self) { owner, validation in
                var updatedConfiguration = self.configuration
                updatedConfiguration?.background.backgroundColor = validation ?
                Colors.Brand.identity :
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
    
    func defineTitle(title: String) {
        self.title.accept(title)
    }
    
    func setIcon(image: UIImage) {
        var configuration = UIButton.Configuration.plain()
        var background = UIBackgroundConfiguration.listPlainCell()
        background.backgroundColor = .clear
        configuration.background = background
        configuration.image = image
        self.configuration = configuration
    }
}
