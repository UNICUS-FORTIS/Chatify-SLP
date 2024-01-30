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
    
    init() {
        guard let session = session else { return }
        session.fetchChannelList()
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response):
                    owner.channelList.accept(response)
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
    
    
    
    
    
    
}


