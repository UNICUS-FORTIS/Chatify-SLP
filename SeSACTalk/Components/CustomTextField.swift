//
//  CustomTextField.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/3/24.
//

import UIKit


final class CustomTextField: UITextField {
    
    let fontStyle = Typegraphy.body
    let color = Colors.Brand.gray
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(placeHolder: String, secureEntry: Bool, keyboardType: UIKeyboardType) {
        self.init()
        configure(placeHolder: placeHolder)
        self.isSecureTextEntry = secureEntry
        self.keyboardType = keyboardType
    }
    
    private func configure(placeHolder: String) {
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.size.height))
        self.leftView = leftPaddingView
        self.leftViewMode = .always
        
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? placeHolder,
                                                        attributes: [
                                                            NSAttributedString.Key.foregroundColor: color,
                                                            NSAttributedString.Key.font: fontStyle ??
                                                            UIFont.systemFont(ofSize: 25)])
        
        self.backgroundColor = .white
        self.textColor = .black
        self.layer.cornerRadius = 8
        self.autocorrectionType = .no
        self.smartQuotesType = .no
        self.textContentType = .oneTimeCode
    }
    
    
    
    
}
