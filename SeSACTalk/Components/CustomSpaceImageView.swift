//
//  CustomSpaceImageView.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/12/24.
//

import UIKit
import SnapKit
import Kingfisher


final class CustomSpaceImageView: UIImageView {
    
    private let spaceImage = UIImageView()
    private let cameraImage = UIImageView(image: .camera)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraints()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.addSubview(spaceImage)
        self.addSubview(cameraImage)
        self.isUserInteractionEnabled = true
        spaceImage.backgroundColor = Colors.Brand.identity
        spaceImage.image = .chatBubble
        spaceImage.contentMode = .scaleAspectFit
        spaceImage.layer.cornerRadius = 4
        spaceImage.clipsToBounds = true
    }
    
    private func setConstraints() {
        spaceImage.snp.makeConstraints { make in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        }
        cameraImage.snp.makeConstraints { make in
            make.centerX.equalTo(spaceImage.snp.trailing).offset(-6)
            make.centerY.equalTo(spaceImage.snp.bottom).offset(-6)
        }
    }
    
    func setImage(image: UIImage) {
        self.spaceImage.image = image
    }
    
    func setImageWithThumbnail(thumbnail: String, completion: @escaping (UIImage)->Void ) {
        let url = EndPoints.imageBaseURL + thumbnail
        guard let urlString = URL(string: url) else { return }
        self.spaceImage.contentMode = .scaleAspectFill
        self.spaceImage.kf.setImage(with: urlString)
        if let image = spaceImage.image {
            completion(image)
        }
    }
    
    func setContentMode(mode: ContentMode) {
        self.spaceImage.contentMode = mode
    }
    
    func setProfileImage(thumbnail: String) {
        let url = EndPoints.imageBaseURL + thumbnail
        guard let urlString = URL(string: url) else { return }
        self.spaceImage.contentMode = .scaleAspectFill
        self.spaceImage.kf.setImage(with: urlString)
    }
    
    func inactiveCameraIcon() {
        cameraImage.removeFromSuperview()
    }
}
