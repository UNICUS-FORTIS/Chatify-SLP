//
//  ChannelFooterCell.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/12/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


final class ChannelFooterCell: UITableViewHeaderFooterView {
    
    
    private let symbolIcon = UIImageView(image: .plus)
    private let name = CustomTitleLabel("", 
                                        textColor: Colors.Text.primary,
                                        font: Typography.body ??
                                        UIFont.systemFont(ofSize: 13))
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        name.text = nil
    }
    
    private func configure() {
        self.addSubview(symbolIcon)
        self.addSubview(name)
        self.backgroundColor = .clear
    }
    
    private func setConstraints() {
        symbolIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(18)
            make.leading.equalToSuperview().inset(16)
        }
        
        name.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(symbolIcon.snp.trailing).offset(16)
            make.height.equalTo(28)
        }
    }
    
    func setLabel(text: String) {
        self.name.text = text
    }
}
