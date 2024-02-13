//
//  CustomInputView.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/3/24.
//

import UIKit
import SnapKit
import RxSwift

final class CustomInputView: UIView {

    private let placeHolder: String
    private let secureEntry: Bool
    private let keyboardType: UIKeyboardType
    let validationBinder = PublishSubject<Bool>()
    
    private let label = UILabel()
    lazy var textField = CustomTextField(placeHolder: placeHolder,
                                                 secureEntry: secureEntry
                                         ,keyboardType: keyboardType)
    private let disposeBag = DisposeBag()
    
    init(label:String, placeHolder: String, keyboardType:UIKeyboardType, secureEntry: Bool) {
        self.label.text = label
        self.placeHolder = placeHolder
        self.secureEntry = secureEntry
        self.keyboardType = keyboardType
        super.init(frame: .zero)
        configure()
        setConstraints()
        bindValidationColor()
    }
    
    convenience init(label: String, placeHolder: String, keyboardType:UIKeyboardType ) {
        self.init(label: label,
                  placeHolder: placeHolder,
                  keyboardType: keyboardType,
                  secureEntry: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.addSubview(label)
        self.addSubview(textField)
        label.textColor = .black
        label.font = Typography.title2
        if label.text == "" {
            self.label.isHidden = true
        }
    }
    
    private func setConstraints() {
        
        label.snp.makeConstraints { make in
            make.leading.top.width.equalToSuperview()
            make.height.equalTo(20)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(44)
        }
    }
    
    private func bindValidationColor() {
        validationBinder
            .subscribe(with: self) { owner, validation in
                owner.label.textColor = validation ? .black : Colors.Brand.error
            }
            .disposed(by: disposeBag)
    }
}
