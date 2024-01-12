//
//  ChannelTableCell.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/12/24.
//

import UIKit
import SnapKit



final class ChannelTableViewCell: UITableViewCell {
    
    
    private let symbolIcon = UIImageView(image: .hashTagThin)
    private let name = CustomTitleLabel("", 
                                        textColor: Colors.Text.primary,
                                        font: Typography.body ??
                                        UIFont.systemFont(ofSize: 13))
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        symbolIcon.image = nil
        name.text = nil
        name.font = Typography.body
        name.textColor = Colors.Text.primary
    }
    
    private func configure() {
        self.addSubview(symbolIcon)
        self.addSubview(name)
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
    
    func setLabel(text: String, textFolor: UIColor, symbol: UIImage, font: UIFont) {
        self.symbolIcon.image = symbol
        self.name.text = text
        self.name.textColor = textFolor
        self.name.font = font
    }
}
