//
//  CustomTitleLabel.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/8/24.
//

import UIKit



final class CustomTitleLabel: UILabel {
    
    
    convenience init(_ text: String, textColor: UIColor, font: UIFont) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = Colors.Text.primary
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        self.textAlignment = .center
        self.numberOfLines = 0
        
    }
}


