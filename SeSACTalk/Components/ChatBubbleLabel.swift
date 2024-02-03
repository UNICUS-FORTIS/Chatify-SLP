//
//  ChatBubbleLabel.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/3/24.
//

import UIKit


final class ChatBubbleLabel: UILabel {
    
    private var padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    
    convenience init(text: String) {
        self.init(frame: .zero)
        self.text = text
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        
        return contentSize
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.textColor = .black
        self.font = Typography.body
        self.textAlignment = .left
        self.numberOfLines = 10
        self.lineBreakMode = .byCharWrapping
        self.layer.borderColor = Colors.Brand.inactive.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
    }
}
