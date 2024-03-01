//
//  ProductListCell.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 3/1/24.
//

import UIKit
import SnapKit

final class ProductListCell: UITableViewCell {
    
    private let titleLabel = CustomTitleLabel("",
                                              textColor: .black,
                                              font: Typography.createBodyBold())
    
    private var purchaseButton = PurchaseButton(title: "")
    var buttonAction: ( () -> Void )?
    
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
        titleLabel.text = nil
        buttonAction = nil
    }
    
    private func configure() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(purchaseButton)
        self.selectionStyle = .none
        purchaseButton.addTarget(self, action: #selector(doButtonAction), for: .touchUpInside)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
        }
        
        purchaseButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview().inset(8)
        }
    }
    
    func bindData(product: ProductListResponse) {
        titleLabel.text = product.item
        purchaseButton.defineTitle(title: "₩\(product.amount)")
    }
    
    @objc func doButtonAction() {
        buttonAction?()
    }

}
