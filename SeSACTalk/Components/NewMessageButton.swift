//
//  NewMessageButton.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/16/24.
//

import UIKit


final class NewMessageButton: UIButton {
    
    private let messageIcon:UIImage = .newMessageButton
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeShadow()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.setImage(messageIcon, for: .normal)
        self.contentMode = .scaleToFill
        DispatchQueue.main.async {
            self.layer.cornerRadius = self.frame.width / 2
        }
    }
    
    private func makeShadow() {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor

        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 7.6
        self.layer.shadowOffset = CGSize(width: 0, height: 3.8)
    }
}
