//
//  CustomLeftNaviButton.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/19/24.
//

import UIKit


final class CustomLeftNaviButton: UIButton {
    
    var buttonTitle = "No WorkSpace"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        var attString = AttributedString(buttonTitle)
        attString.font = Typography.title1 ?? UIFont.systemFont(ofSize: 22)
        attString.foregroundColor = .black
        
        var configuration = UIButton.Configuration.filled()
        configuration.attributedTitle = attString
        configuration.imagePadding = 8
        configuration.imagePlacement = .leading
        configuration.baseBackgroundColor = .clear
        configuration.baseForegroundColor = .black

        self.configuration = configuration
    }
    
    
}
