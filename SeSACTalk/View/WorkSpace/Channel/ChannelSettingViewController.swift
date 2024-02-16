//
//  ChannelSettingViewController.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/14/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ChannelSettingViewController: UIViewController {

    private let descriptionTitle = CustomLabel("", font: Typography.createBodyBold())
    private let descriptionLabel = CustomLabel("", font: Typography.createBody())
    private let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewLayout() )
    private let editChannelButton = CustomButton(channelEditTitle: "채널 편집", color: .black)
    private let exitChannelButton = CustomButton(channelEditTitle: "채널 나가기", color: .black)
    private let modifyChannelManagerButton = CustomButton(channelEditTitle: "채널 관리자 변경", color: .black)
    private let removeChannelButton = CustomButton(channelEditTitle: "채널 삭제", color: Colors.Brand.error)
    private lazy var buttonStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [editChannelButton,
                                               exitChannelButton,
                                               modifyChannelManagerButton,
                                               removeChannelButton])
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        sv.spacing = 8
        sv.isUserInteractionEnabled = true
        return sv
    }()
    private lazy var buttonArray = [editChannelButton,
                                    exitChannelButton,
                                    modifyChannelManagerButton,
                                    removeChannelButton]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
        collectionView.collectionViewLayout = createCollectionViewLayout()
        collectionView.backgroundColor = .gray
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(44),
                                                   heightDimension: .absolute(58))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitem: item,
                                                           count: 5)
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .fractionalHeight(0.05))
            
            let sectionHeader =
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                        alignment: .top)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 16, leading: 16, bottom: 0, trailing: 16)
            section.boundarySupplementaryItems = [sectionHeader]

            return section
        }
        return layout
    }
    
    private func configure() {
        view.backgroundColor = Colors.Background.primary
        view.addSubview(descriptionTitle)
        view.addSubview(descriptionLabel)
        view.addSubview(collectionView)
        view.addSubview(buttonStackView)
        collectionView.register(UserProfileCVCell.self, forCellWithReuseIdentifier: UserProfileCVCell.identifier)
        collectionView.register(ChannelSettingHeaderCell.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: ChannelSettingHeaderCell.identifier)
        
    }
    
    private func setConstraints() {
        descriptionLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(18)
            make.centerX.equalToSuperview()
        }
        
        descriptionTitle.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(descriptionLabel)
            make.centerX.equalToSuperview()
        }
        
        buttonArray.forEach { button in
            button.snp.makeConstraints { make in
                make.height.equalTo(44)
            }
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(descriptionTitle.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(7)
            make.bottom.equalTo(buttonStackView.snp.top).offset(-8)
        }
    }
}

//extension ChannelSettingViewController: UICollectionViewDataSource {
//    
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        
//    }
//    
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//    }
//
//    
//    
//    
//}
