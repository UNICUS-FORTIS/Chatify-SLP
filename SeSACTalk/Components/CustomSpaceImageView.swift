//
//  CustomSpaceImageView.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/12/24.
//

import UIKit
import SnapKit


final class CustomSpaceImageView: UIImageView {
    
    private let spaceImage = UIImageView()
    private let cameraImage = UIImageView(image: .camera)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraints()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.addSubview(spaceImage)
        self.addSubview(cameraImage)
        self.isUserInteractionEnabled = true
        spaceImage.backgroundColor = Colors.Brand.green
        spaceImage.image = .chatBubble
        spaceImage.contentMode = .scaleAspectFit
        spaceImage.layer.cornerRadius = 8
        spaceImage.clipsToBounds = true
    }
    
    private func setConstraints() {
        spaceImage.snp.makeConstraints { make in
            make.size.equalTo(70)
            make.center.equalToSuperview()
        }
        cameraImage.snp.makeConstraints { make in
            make.centerX.equalTo(spaceImage.snp.trailing).offset(-6)
            make.centerY.equalTo(spaceImage.snp.bottom).offset(-6)
        }
    }
    
    func setImage(image: UIImage) {
        self.spaceImage.image = image
    }
    
    func setContentMode(mode: ContentMode) {
        self.spaceImage.contentMode = mode
    }
}
