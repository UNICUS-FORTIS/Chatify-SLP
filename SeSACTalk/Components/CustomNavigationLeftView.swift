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
    
    var data: ChannelInfoResponse? {
        didSet {
            guard let safe = data else { return }
            let url = EndPoints.baseURL + safe.thumbnail
            guard let urlString = URL(string: url) else { return }
            print(url)
            self.leftItem.kf.setImage(with: urlString)
            print("이미지 설정됨")
            self.naviTitle.text = safe.name
        }
    }
    
    private let leftItem = UIImageView(image: .dummy)
    private let naviTitle = CustomTitleLabel("No Workspace",
                                     textColor: .black,
                                     font: Typography.title1 ??
                                     UIFont.systemFont(ofSize: 22))    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.addSubview(leftItem)
        self.addSubview(naviTitle)
        
        leftItem.layer.cornerRadius = 8
        leftItem.clipsToBounds = true
        leftItem.contentMode = .scaleAspectFill
        naviTitle.textAlignment = .left
    }
    
    private func setConstraints() {
        
        leftItem.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.size.equalTo(32)
            make.centerY.equalToSuperview()
        }
        
        naviTitle.snp.makeConstraints { make in
            make.leading.equalTo(leftItem.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
            make.height.equalTo(35)
        }
    }
    
    func setView(imageURL: String, title: String) {
        let url = EndPoints.baseURL + imageURL
        guard let urlString = URL(string: url) else { return }
        print(url)
        self.leftItem.kf.setImage(with: urlString)
        print("이미지 설정됨")
        self.naviTitle.text = title
    }
    
}
