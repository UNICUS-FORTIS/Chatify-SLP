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
    
    private var viewModel: ChannelSettingViewModel
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
    
    private let disposeBag = DisposeBag()
    
    init(channelInfo: Channels) {
        self.viewModel = ChannelSettingViewModel(channelInfo: channelInfo)
        
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.channelInfoRelay
            .subscribe(with: self) { owner, channel in
                self.descriptionTitle.text = channel.name
                self.descriptionLabel.text = channel.description
            }
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
        bind()
        setupButtonVisibility()
        setupButtonActions()
        makeInitialChannelDesctription()
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
                        
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(60))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitem: item,
                                                           count: 5)
            
            group.interItemSpacing = .fixed(16)
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .absolute(56))
            
            let sectionHeader =
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                        alignment: .top)
            sectionHeader.pinToVisibleBounds = true
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 25
            section.contentInsets = .init(top: 16, leading: 16, bottom: 0, trailing: 16)
            section.boundarySupplementaryItems = [sectionHeader]

            return section
        }
        
        return layout
    }
    
    private func makeInitialChannelDesctription() {
        descriptionTitle.text = viewModel.channelInfo.name
        descriptionLabel.text = viewModel.channelInfo.description
    }
    
    private func configure() {
        view.backgroundColor = Colors.Background.primary
        view.addSubview(descriptionTitle)
        view.addSubview(descriptionLabel)
        view.addSubview(collectionView)
        view.addSubview(buttonStackView)
        collectionView.collectionViewLayout = createCollectionViewLayout()
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        descriptionLabel.numberOfLines = 0
        collectionView.register(UserProfileCVCell.self, forCellWithReuseIdentifier: UserProfileCVCell.identifier)
        collectionView.register(ChannelSettingHeaderCell.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: ChannelSettingHeaderCell.identifier)
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        navigationController?.setDefaultNavigation(target: self, title: "채널 설정")
    }
    
    private func setConstraints() {
        descriptionTitle.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(18)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionTitle.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(descriptionTitle)
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
            make.top.equalTo(descriptionLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(7)
            make.bottom.equalTo(buttonStackView.snp.top).offset(-8)
        }
    }
    
    private func setupButtonVisibility() {
        if viewModel.checkChannelOwner() == false {
            editChannelButton.isHidden = true
            editChannelButton.isEnabled = false
            modifyChannelManagerButton.isHidden = true
            modifyChannelManagerButton.isEnabled = false
            removeChannelButton.isHidden = true
            removeChannelButton.isEnabled = false
        }
    }
    
    private func bind() {
        viewModel.userModelsRelay
            .bind(with: self) { owner, _ in
                owner.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
        
    }
    
    private func setupButtonActions() {
        editChannelButton.addTarget(self,
                                    action: #selector(editChannelAction),
                                    for: .touchUpInside)
        exitChannelButton.addTarget(self,
                                    action: #selector(exitChannelAction),
                                    for: .touchUpInside)
        modifyChannelManagerButton.addTarget(self, 
                                             action: #selector(modifyChannelManagerAction),
                                             for: .touchUpInside)
        removeChannelButton.addTarget(self, 
                                      action: #selector(removeChannelAction),
                                      for: .touchUpInside)
    }
    
    @objc func editChannelAction() {
        let vc = ChannelAddViewController(viewTitle: "채널 편집",
                                          channelInfo: viewModel.makeChannelInfo())
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overFullScreen
        vc.viewModel.completionHandeler =  { [weak self] channels in
            self?.viewModel.acceptChannelInfoRelay(channel: channels)
            self?.makeSuccessToastView(message: ToastMessages.Channel.editComplted.description,
                                       backgroundColor: Colors.Brand.green,
                                       target: self ?? UIViewController() )
        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
    @objc func exitChannelAction() {
        let vc = BackdropViewController(boxType: .cancellable(.exitFromChannel),
                                        workspaceID: viewModel.makeWorkspaceID(),
                                        channel: viewModel.makeChannelInfo())
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false)
    }
    
    @objc func modifyChannelManagerAction() {
        if viewModel.checkChannelManagerModifiable() {
            let feature = ChannelMemberFeatureClass(viewModel: self.viewModel)
            let vc = ListingViewController(feature: feature)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = BackdropViewController(boxType: .confirm(.modifyChannelManager),
                                            workspaceID: nil)
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false)
        }
        
    }
    
    @objc func removeChannelAction() {
        if viewModel.checkChannelManagerModifiable() {
            
        }
    }
    
    deinit{
        print("채널 세팅 뷰컨 Deinit")
    }
}

extension ChannelSettingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.makeMemberCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfileCVCell.identifier, for: indexPath) as? UserProfileCVCell else { return UICollectionViewCell() }
        
        cell.bind(model: viewModel.userModelsRelay.value[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ChannelSettingHeaderCell.identifier, for: indexPath) as? ChannelSettingHeaderCell else { return UICollectionReusableView() }
        viewModel.sectionExpender ?
        header.morebutton.setIcon(image: .chevronDown) :
        header.morebutton.setIcon(image: .chevronRight)
        header.bindData(memberCount: viewModel.makeNumberOfItemInsection())
        header.expendor = { [weak self] in
            self?.viewModel.toggleExpender()
            UIView.animate(withDuration: 0.3) {
                self?.collectionView.reloadSections([0], animationStyle: .automatic)
            }
        }
        
        return header
    }
}

extension ChannelSettingViewController: ToastPresentableProtocol { }
