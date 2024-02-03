//
//  ChatViewController.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/31/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import MessageKit
import InputBarAccessoryView


final class ChatViewController: UIViewController {
    
    private var manager = ChatManager()
    private let session = LoginSession.shared
    private let tableView = UITableView(frame: .zero,
                                        style: .grouped)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
        bind()
        setUp()
        manager.mockUP()
    }
    
    private func configure() {
        view.backgroundColor = .white
        navigationController?.setChannelChatNavigation(target: self,
                                                       rightAction: #selector(setNavigationRightAction))
        view.addSubview(tableView)
        tableView.register(MessageTableCell.self,
                           forCellReuseIdentifier: MessageTableCell.identifier)
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
    private func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setUp() {
        manager.loadChatLog()
        manager.fetchUnreadDatas()
        manager.startSocketConnect()
    }
    
    private func bind() {
        print("바인드")
        manager.chatDatasRelay
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: MessageTableCell.identifier,
                                         cellType: MessageTableCell.self)) {
                _, item, cell in
                
                cell.datas.accept(item)
                
            }.disposed(by: disposeBag)
    }
    
    @objc private func setNavigationRightAction() {
        print("메롱")
    }
}
