//
//  CustomLeftNaviButton.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/19/24.
//

//import UIKit
//import RxSwift


//final class CustomLeftNaviButton: UIButton {
//    
//    
//    var buttonTitle = BehaviorSubject<String>(value: "No WorkSpace")
//    private let disposeBag = DisposeBag()
//
//    override init(frame: CGRect) {
//        super.init(frame: .init(x: 0, y: 0, width: 200, height: 0))
//        configure()
//        self.contentHorizontalAlignment = .leading
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func configure() {
//        
//        buttonTitle
//            .subscribe(with: self) { owner, title in
//                var buttonConfiguration = UIButton.Configuration.plain()
//                var attString = AttributedString(title)
//                attString.font = Typography.title1 ?? UIFont.systemFont(ofSize: 22)
//                attString.foregroundColor = .black
//                
//                buttonConfiguration.attributedTitle = attString
//                buttonConfiguration.titleAlignment = .leading
//                buttonConfiguration.baseBackgroundColor = .clear
//                buttonConfiguration.baseForegroundColor = .black
//
//                self.configuration = buttonConfiguration
//            }
//            .disposed(by: disposeBag)
//    }
//}
