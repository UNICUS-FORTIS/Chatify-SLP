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
    
    private weak var session = LoginSession.shared
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let disposeBag = DisposeBag()
    private let channelList = PublishRelay<[Channels]>()
    private let errorReceiver = PublishRelay<Notify>()
    private var channelListArray:[Channels] = []
    
    init() {
        guard let session = session else { return }
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
                              textColor: .black,
                              symbol: .hashTag,
                              font: Typography.bodyBold ??
                              UIFont.systemFont(ofSize: 13),
                              badgeCount: nil)
                
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
        target.navigationController?.setCloseableNavigation(title: "채널 탐색",
                                                            target: target,
                                                            action: #selector(target.dismissTrigger))
        tableView.register(ChannelTableViewCell.self,
                           forCellReuseIdentifier: ChannelTableViewCell.identifier)
        tableView.rowHeight = 41
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.contentInset = .init(top: 8, left: 0, bottom: 0, right: 0)
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
    func setConstraints(target: UIViewController) {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(target.view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    func showActionSheet(target: UIViewController, workspace: WorkSpace) { }
    
    func checkJoinedChannel(target: UIViewController, workspaceID: Int, channel: Channels) {
        guard let session = session else { return }
        session.channelsInfo.map { $0.contains(where: {$0.channelID == channel.channelID }) }
            .subscribe(with: self) { owner, isJoined in
                if isJoined {
                    let manager = ChatManager(iD: channel.workspaceID,
                                              channelName: channel.name,
                                              channelID: channel.channelID)
                    let vc = ChatViewController(manager: manager)
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

