//
//  CustomNavigationRightView.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/11/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa


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
    
    
}
