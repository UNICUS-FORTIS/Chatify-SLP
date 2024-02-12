//
//  ProfileTableCell.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/9/24.
//

import UIKit
import SnapKit



final class ProfileTableCell: UITableViewCell {
    
    private var cellTitle = CustomTitleLabel("",
                                             textColor: .black,
                                             font: Typography.bodyBold ??
                                             UIFont.systemFont(ofSize: 13))
    
    private var coinValue = CustomTitleLabel("",
                                             textColor: Colors.Brand.green,
                                             font: Typography.bodyBold ??
                                             UIFont.systemFont(ofSize: 13))
    
    private var cellValue = CustomTitleLabel("",
                                             textColor: Colors.Text.secondary,
                                             font: Typography.body ??
                                             UIFont.systemFont(ofSize: 13))
    
    private let moreButton = CustomButton(.chevronRightGray)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview()
        setConstraints()
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubview() {
        contentView.addSubview(cellTitle)
        contentView.addSubview(cellValue)
        contentView.addSubview(moreButton)
    }
    
    func setConstraints() {
        cellTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview().inset(13)
        }
        
        moreButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.width.equalTo(22)
        }
        
        cellValue.snp.makeConstraints { make in
            make.trailing.equalTo(moreButton.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
        }
    }
    
    func setTitle(value: String) {
        cellTitle.text = value
    }
    
    func setCellValue(value: String) {
        cellValue.text = value
    }
    
    func setCoinValue(coin: String) {
        contentView.addSubview(coinValue)
        coinValue.text = coin
        coinValue.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(cellTitle.snp.trailing).offset(6)
            make.height.equalTo(cellTitle)
        }
    }
}
