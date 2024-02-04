//
//  ChatButton.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/5/24.
//

import UIKit

final class ChatButton: UIButton {
    
    private var buttonImage: UIImage?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(_ image: UIImage) {
        self.init(frame: .zero)
        self.setImage(image, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
