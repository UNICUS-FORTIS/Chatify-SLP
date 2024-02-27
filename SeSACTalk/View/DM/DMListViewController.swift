//
//  DMListViewController.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/27/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit


final class DMListViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewLayout())
    private let separatorView = UIView()
    private let session = LoginSession.shared
    private let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setWorkSpaceNavigation(target: self,
                                                     leftAction: #selector(workSpaceTitleTapped),
                                                     rightActoin: #selector(profileImageTapped))
    }
    
    private func configure() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(separatorView)
        separatorView.backgroundColor = Colors.Border.naviShadow
        tableView.rowHeight = UIScreen.main.bounds.height * 0.08
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = .clear
        tableView.register(DMListTableCell.self,
                           forCellReuseIdentifier: DMListTableCell.identifier)
        collectionView.register(UserProfileCVCell.self,
                                forCellWithReuseIdentifier: UserProfileCVCell.identifier)
    }
    
    private func bind() {
        session.DmsInfo
            .bind(to: tableView.rx.items(cellIdentifier: DMListTableCell.identifier,
                                         cellType: DMListTableCell.self)) {
                _ , item, cell in
                print(item.createdAt.chatDateString())
                cell.bind(data: item, badgeCount: 4)
                
            }.disposed(by: disposeBag)
        
        session.workspaceMember
            .bind(to: collectionView.rx.items(cellIdentifier: UserProfileCVCell.identifier,
                                              cellType: UserProfileCVCell.self)) {
                _, member, cell in
                
                cell.bind(workspaceUser: member)
            }.disposed(by: disposeBag)
    }
    
    private func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.11)
        }
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(1.0))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 5)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 16, leading: 0, bottom: 0, trailing: 0)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
        
    @objc func workSpaceTitleTapped() { }
    
    @objc func profileImageTapped() {
        let vc = ProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
