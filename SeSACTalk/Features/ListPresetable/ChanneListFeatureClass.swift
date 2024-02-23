//
//  ChanneListFeatureClass.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/31/24.
//

import UIKit
import RxSwift
import RxCocoa


final class ChannelListFeatureClass: ListingViewControllerProtocol {
    
    var session: LoginSession
    var tableView: UITableView
    private let disposeBag = DisposeBag()
    private let channelList = PublishRelay<[Channels]>()
    private let errorReceiver = PublishRelay<Notify>()
    private var channelListArray:[Channels] = []
    
    init() {
        self.session = LoginSession.shared
        self.tableView = UITableView()
        
        session.fetchChannelList()
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    owner.channelList.accept(response)
                    owner.channelListArray.append(contentsOf: response)
                case .failure(let error):
                    print(error.errorCode)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func bind(target: UIViewController) {
        channelList
            .bind(to: tableView.rx.items(cellIdentifier: ChannelTableViewCell.identifier,
                                         cellType: ChannelTableViewCell.self)) {
                _, item, cell in
                
                cell.setLabel(text: item.name,
                              badgeCount: 0)
                
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                let targetChannel = owner.channelListArray[indexPath.row]
                owner.checkJoinedChannel(target: target,
                                         workspaceID: targetChannel.workspaceID,
                                         channel: targetChannel)
            }
            .disposed(by: disposeBag)
        
    }
    
    func configure(target: UIViewController) {
        target.view.backgroundColor = .white
        target.view.layer.cornerRadius = 25
        target.view.clipsToBounds = true
        target.view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.contentInset = .init(top: 8, left: 0, bottom: 0, right: 0)
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
    func setNavigationController(target: UIViewController) {
        target.navigationController?.setCloseableNavigation(title: "채널 탐색",
                                                            target: target,
                                                            action: #selector(target.dismissTrigger))
    }
    
    func registerTableViewCell() {
        tableView.register(ChannelTableViewCell.self,
                           forCellReuseIdentifier: ChannelTableViewCell.identifier)
    }
    
    func setTableViewRowheight() {
        tableView.rowHeight = 41
    }
    
    func showActionSheet(target: UIViewController, currendUserID: Int, workspace: WorkSpace) { }
    
    func checkJoinedChannel(target: UIViewController, workspaceID: Int, channel: Channels) {
        session.channelsInfo.map { $0.contains(where: {$0.channelID == channel.channelID }) }
            .subscribe(with: self) { owner, isJoined in
                if isJoined {
                    let socketManager = SocketIOManager(channelInfo: channel)
                    let vc = ChannelChatViewController(manager: socketManager)
                    target.navigationController?.pushViewController(vc,
                                                                    animated: true)
                } else {
                    let vc =
                    BackdropViewController(boxType: .cancellable(.loadChannels(name: channel.name)),
                                           workspaceID: workspaceID,
                                           channel: channel)
                    
                    vc.modalPresentationStyle = .overFullScreen
                    target.present(vc, animated: false)
                }
            }
            .disposed(by: disposeBag)
    }
}

