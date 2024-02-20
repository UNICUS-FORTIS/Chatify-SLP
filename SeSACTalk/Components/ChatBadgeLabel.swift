//
//  ChatBadgeLabel.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/20/24.
//

import UIKit


final class ChatBadgeLabel: UILabel {
    
    private var padding = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
    
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
        self.textColor = .white
        self.backgroundColor = Colors.Brand.green
        self.font = Typography.createCaption()
        self.textAlignment = .center
        self.numberOfLines = 1
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
}
