//
//  CustomLabel.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/3/24.
//

import UIKit


final class CustomLabel: UILabel {
    
    private var labelText: NSAttributedString

    
    override init(frame: CGRect) {
        self.labelText = NSAttributedString(string: "")
        super.init(frame: frame)
    }
    
    convenience init(_ text: NSAttributedString, font: UIFont) {
        self.init(frame: .zero)
        self.attributedText = text
        self.font = font
        self.textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
