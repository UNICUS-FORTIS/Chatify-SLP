//
//  CustomCoinView.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 3/1/24.
//

import UIKit
import SnapKit

final class CustomCoinView: UIView {
    
    private let titleLabel = CustomTitleLabel("현재 보유한 코인",
                                              textColor: .black,
                                              font: Typography.createBodyBold())
    
    private let coinCountLabel = CustomTitleLabel("",
                                          textColor: Colors.Brand.identity,
                                          font: Typography.createBodyBold())
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.addSubview(titleLabel)
        self.addSubview(coinCountLabel)
        self.backgroundColor = .clear
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        coinCountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(titleLabel.snp.trailing).offset(4)
        }
    }
    
    func manageCoinCount(coin: Int) {
        coinCountLabel.text = "\(coin)개"
    }
}
