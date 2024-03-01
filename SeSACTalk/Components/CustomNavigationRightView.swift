//
//  CustomNavigationRightView.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/11/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher


final class CustomNavigationRightView: UIView {
    
    let profileImage = PublishRelay<String>()
    let dummyImage = PublishRelay<UIImage>()
    private let disposeBag = DisposeBag()

    
    var button = UIButton()
    
    private let image = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.addSubview(image)
        self.addSubview(button)
        self.isUserInteractionEnabled = true
        image.layer.cornerRadius = 16
        image.clipsToBounds = true
        image.image = .dummyTypeA
        image.layer.borderColor = Colors.Border.border.cgColor
        image.layer.borderWidth = 2
    }
    
    private func setConstraints() {
        image.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
    }
    
    func bind() {
        profileImage
            .bind(with: self) { owner, profile in
                let url = URL(string: EndPoints.imageBaseURL + profile)
                self.image.kf.setImage(with: url)
                self.contentMode = .scaleAspectFill
            }
            .disposed(by: disposeBag)
        
        dummyImage
            .bind(with: self) { owner, dummy in
                self.image.image = dummy
            }
            .disposed(by: disposeBag)
    }
}
