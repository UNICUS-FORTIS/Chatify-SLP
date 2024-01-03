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
    private let validationBinder = PublishSubject<Bool>()
    
    private let label = UILabel()
    lazy var textField = CustomTextField(placeHolder: placeHolder,
                                                 secureEntry: secureEntry)
    private let disposeBag = DisposeBag()
    
    init(label:String, placeHolder: String, secureEntry: Bool, validation: Bool) {
        self.label.text = label
        self.placeHolder = placeHolder
        self.secureEntry = secureEntry
        super.init(frame: .zero)
        configure()
        setConstraints()
        bindValidationColor()
    }
    
    convenience init(label: String, placeHolder: String ) {
        self.init(label: label, placeHolder: placeHolder, secureEntry: false, validation: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.addSubview(label)
        self.addSubview(textField)
        label.textColor = .black
        label.font = Typegraphy.title2
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
