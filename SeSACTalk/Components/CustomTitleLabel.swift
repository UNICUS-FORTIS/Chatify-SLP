//
//  CustomTitleLabel.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/8/24.
//

import UIKit



final class CustomTitleLabel: UILabel {
    
    
    convenience init(_ text: String) {
        self.init()
        self.text = text
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        self.textColor = .black
        self.font = Typography.title1
        self.textAlignment = .center
        self.numberOfLines = 0
        
    }
}


