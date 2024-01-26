//
//  DefaultWorkSpaceViewController.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/12/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import SideMenu


final class DefaultWorkSpaceViewController: UIViewController {
    
    private let session = LoginSession.shared
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let newMessageButton = NewMessageButton(frame: .zero)
    private var sideMenu: SideMenuNavigationController?
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setConstraints()
        sideMenuSetup()
        bind()
    }
    
    private func bind() {
        Observable
            .combineLatest(session.channelInfo.asObservable(), session.DmsInfo.asObservable())
            .map { channel, dms -> Bool in
                guard let dmsValue = dms else { return false }
                return channel != nil && (!dmsValue.isEmpty || dmsValue.isEmpty)
            }
            .asDriver(onErrorJustReturn: false)
            .filter { $0 }
            .drive(with: self) { owner, modified in
                if modified {
                    owner.tableView.reloadData()
                    print("테이블뷰 리로드됨")
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func configure() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(newMessageButton)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 41
        
        tableView.register(ChannelTableViewCell.self,
                           forCellReuseIdentifier: ChannelTableViewCell.identifier)
        
        tableView.register(DMTableCell.self,
                           forCellReuseIdentifier: DMTableCell.identifier)
        
        tableView.register(ChannelHeaderCell.self,
                           forHeaderFooterViewReuseIdentifier: ChannelHeaderCell.identifier)
        
        tableView.register(ChannelFooterCell.self,
                           forHeaderFooterViewReuseIdentifier: ChannelFooterCell.identifier)
        
        navigationController?.setWorkSpaceNavigation(target: self, action: #selector(workSpaceTitleTapped))
    }
    
    @objc func workSpaceTitleTapped() {
        present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
    }
    
    
    private func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        
        newMessageButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.trailing.equalToSuperview().inset(18)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(18)
        }
    }
    
    private func sideMenuSetup() {
        let feature = WorkspaceListFeatureClass()
        let menu = ListingViewController(feature: feature)
        sideMenu = SideMenuNavigationController(rootViewController: menu)
        sideMenu?.setWorkSpaceListNavigation()
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        sideMenu?.leftSide = true
        sideMenu?.presentationStyle = .menuSlideIn
        sideMenu?.presentationStyle.presentingEndAlpha = 0.5
        sideMenu?.menuWidth = view.frame.width * 0.8
    }
    
}

extension DefaultWorkSpaceViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ChannelLayoutSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = ChannelLayoutSection.allCases[section]
        switch sections {
        case .channel : return session.numberOfChannelInfoCount()
        case .directMessage: return session.numberOfDmsCount()
        case .addNewMember: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sections = ChannelLayoutSection.allCases[indexPath.section]
        
        switch sections {
        case .channel :
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.identifier) as? ChannelTableViewCell else { return UITableViewCell() }
            
            self.session.channelInfo
                .asObservable()
                .bind(with: self) { owner, channelInfo in
                    guard let safe = channelInfo else { return }
                    let channelPath = safe.channels[indexPath.row]
                    let text = channelPath.name
                    
                    cell.setLabel(text: text,
                                  textColor: Colors.Text.secondary,
                                  symbol: .hashTagThin,
                                  font: Typography.body ??
                                  UIFont.systemFont(ofSize: 13),
                                  badgeCount: 5)
                }
                .disposed(by: self.disposeBag)
            
            return cell
        case .directMessage:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DMTableCell.identifier) as? DMTableCell else { return UITableViewCell() }
            
            self.session.DmsInfo
                .asObservable()
                .bind(with: self) { owner, dms in
                    guard let safe = dms else {
                        return }
                    if safe.count > 0 {
                        let safePath = safe[indexPath.row]
                        let username = safePath.user.nickname
                        let profileImage = safePath.user.profileImage
                        cell.setDms(username: username,
                                    profileImage: profileImage ?? nil,
                                    count: 5)
                    }
                }
                .disposed(by: self.disposeBag)
            
            return cell
            
        case .addNewMember:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.identifier) as? ChannelTableViewCell else { return UITableViewCell() }
            
            return cell
        }
    }
}

extension DefaultWorkSpaceViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sections = ChannelLayoutSection.allCases[section]
        guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: ChannelHeaderCell.identifier) as? ChannelHeaderCell else { return UITableViewHeaderFooterView() }
        
        switch sections {
        case .channel:
            cell.setHeaderTitle(title: "채널")
            return cell
            
        case .directMessage:
            cell.setHeaderTitle(title: "다이렉트 메시지")
            return cell
            
        case .addNewMember: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sections = ChannelLayoutSection.allCases[section]
        guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: ChannelFooterCell.identifier) as? ChannelFooterCell else { return UITableViewHeaderFooterView() }
        
        switch sections {
        case .channel:
            cell.setLabel(text: "채널 추가")
            
        case .directMessage:
            cell.setLabel(text: "새 메시지 시작")
            
        case .addNewMember:
            cell.setLabel(text: "팀원 추가")
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sections = ChannelLayoutSection.allCases[section]
        switch sections {
        case .channel, .directMessage : return 41
        case .addNewMember: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sections = ChannelLayoutSection.allCases[section]
        switch sections {
        default: return 41
        }
    }
}
