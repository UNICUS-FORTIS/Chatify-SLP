//
//  CustomNavigationView.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/11/24.
//

import UIKit
import SnapKit
import Kingfisher


final class CustomNavigationLeftView: UIView {
    
    var data: String? {
        didSet {
            guard let safe = data else { return }
            let url = EndPoints.imageBaseURL + safe
            guard let urlString = URL(string: url) else { return }
            self.leftItem.kf.setImage(with: urlString)
        }
    }
    
    private let leftItem = UIImageView(image: .dummy)

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.addSubview(leftItem)
//        self.addSubview(naviTitle)
        self.isUserInteractionEnabled = true
        leftItem.layer.cornerRadius = 8
        leftItem.clipsToBounds = true
        leftItem.contentMode = .scaleAspectFill
//        naviTitle.textAlignment = .left
    }
    
    private func setConstraints() {
        
        leftItem.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.size.equalTo(32)
            make.centerY.equalToSuperview()
        }
    }
}
