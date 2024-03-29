//
//  DefaultWorkSpaceViewController.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/12/24.
//

import UIKit
import SnapKit
import SideMenu
import RxSwift
import RxCocoa
import RxDataSources


final class DefaultWorkSpaceViewController: UIViewController {
    
    static let shared = DefaultWorkSpaceViewController()
    private init() {
        super.init(nibName: nil, bundle: nil)
    }
    private let session = LoginSession.shared
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let newMessageButton = NewMessageButton(frame: .zero)
    private var sideMenu: SideMenuNavigationController?
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setConstraints()
        bind()
        session.setViewControllerActor = {
            self.navigationController?.setViewControllers([OnboardingViewController()], animated: true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sideMenuSetup()
        navigationController?.setWorkSpaceNavigation(target: self,
                                                     leftAction: #selector(workSpaceTitleTapped),
                                                     rightActoin: #selector(profileImageTapped))
    }
    
    private func bind() {
        let dataSource =
        RxTableViewSectionedReloadDataSource<MultipleSectionModel>(configureCell: {
            dataSource,
            tableView,
            indexPath,
            item in
            
            switch item {
            case let .channel(channels) :
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.identifier, for: indexPath) as? ChannelTableViewCell else { return UITableViewCell() }
                
                self.session.fetchUnreadChannelChats(targetChannel: channels) { unread in
                    cell.setLabel(text: channels.name,
                                  badgeCount: unread)
                }
                
                return cell
                
            case let .dms(dms):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DMTableCell.identifier) as? DMTableCell else { return UITableViewCell() }
                
                self.session.fetchUnreadDMChats(dm: dms) { unread in
                    cell.setDms(data: dms, badgeCount: unread)
                }
                
                return cell
                
            case .member: break
            }
            return UITableViewCell()
        })
        
        session.layout
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(SectionItem.self)
            .subscribe(with: self) { owner, section in
                switch section {
                case .channel(let item):
                    let socketManager = ChatSocketManager(channelInfo: item)
                    let vc = ChannelChatViewController(manager: socketManager)
                    
                    if let indexPath = owner.tableView.indexPathForSelectedRow,
                       let cell = owner.tableView.cellForRow(at: indexPath) as? ChannelTableViewCell {
                        cell.setBadgeToHidden()
                    }
                    
                    owner.navigationController?.pushViewController(vc, animated: true)
                    
                case .dms(let dm):
                    let manager = DMSocketManager(dmInfo: dm)
                    let vc = DMChatViewController(manager: manager)
                    
                    if let indexPath = owner.tableView.indexPathForSelectedRow,
                       let cell = owner.tableView.cellForRow(at: indexPath) as? DMTableCell {
                        cell.setBadgeToHidden()
                    }
                    owner.navigationController?.pushViewController(vc, animated: true)
                    
                default: break
                }
            }
            .disposed(by: disposeBag)
        
        session.workSpacesSubject
            .subscribe(with: self) { owner, workspaces in
                if workspaces?.count == 0 {
                    owner.sideMenu = nil
                    owner.navigationController?.setViewControllers([HomeEmptyViewController()], animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func configure() {
        
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(newMessageButton)
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 41
        tableView.bounces = false
        
        tableView.register(ChannelTableViewCell.self,
                           forCellReuseIdentifier: ChannelTableViewCell.identifier)
        
        tableView.register(DMTableCell.self,
                           forCellReuseIdentifier: DMTableCell.identifier)
        
        tableView.register(ChannelHeaderCell.self,
                           forHeaderFooterViewReuseIdentifier: ChannelHeaderCell.identifier)
        
        tableView.register(ChannelFooterCell.self,
                           forHeaderFooterViewReuseIdentifier: ChannelFooterCell.identifier)
    }
    
    @objc func workSpaceTitleTapped() {
        present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
    }
    
    @objc func profileImageTapped() {
        let vc = ProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
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
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(channelFooterTapped))
            cell.addGestureRecognizer(tapGesture)
            
        case .directMessage:
            cell.setLabel(text: "새 메시지 시작")
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(newMessageFooterTapped))
            cell.addGestureRecognizer(tapGesture)
            
        case .addNewMember:
            cell.setLabel(text: "팀원 추가")
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(newMemberFooterTapped))
            cell.addGestureRecognizer(tapGesture)
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
    
    @objc private func channelFooterTapped() {
        self.showActionSheetForChannelFooter()
    }
    
    @objc private func newMessageFooterTapped() {
        session.loadWorkspaceMember(id: session.makeWorkspaceID()) { [weak self] in
            let feature = MemberListFeatureClass(mode: .dm)
            let vc = ListingViewController(feature: feature)
            let navVC = UINavigationController(rootViewController: vc)
            self?.present(navVC, animated: true)
        }
    }
    
    @objc private func newMemberFooterTapped() {
        print("새로운 팀원 추가")
        let vc = InviteMemberViewController()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalTransitionStyle = .coverVertical
        present(navVC, animated: true)
    }
}
