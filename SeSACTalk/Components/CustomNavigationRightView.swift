//
//  CustomNavigationRightView.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/11/24.
//

import UIKit
import SnapKit
import Kingfisher


final class CustomNavigationRightView: UIView {
    
    private let image = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.addSubview(image)
        image.layer.cornerRadius = 16
        image.clipsToBounds = true
        image.image = .dummyTypeA
        image.layer.borderColor = Colors.Border.border.cgColor
        image.layer.borderWidth = 2
    }
    
    private func setConstraints() {
        image.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    func setImage(imageURL: String) {
        let url = URL(string: EndPoints.baseURL+imageURL)
        self.image.kf.setImage(with: url)
    }
    
    func setDummyImage(image: UIImage) {
        self.image.image = image
    }
    
    
}
