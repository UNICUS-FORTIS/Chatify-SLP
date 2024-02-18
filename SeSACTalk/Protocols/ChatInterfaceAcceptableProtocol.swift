//
//  ChatInterfaceAcceptableProtocol.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/18/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


protocol ChatInterfaceAcceptableProtocol {
    
    var socketManager: ChatProtocol { get }
    var session: LoginSession { get }
    var tableView: UITableView { get }
    var accView: CustomInputAccView { get }
    var lastIndexPath: IndexPath? { get }
    var disposeBag: DisposeBag { get }
    
    init(manager: ChatProtocol)
    
    func configure()
    func setConstraints()
    func setTextViewDelegate()
    func scrollToNewestChat()
    func setupTapGesture()
    func setupNavigation()
    func bindTableView()
    func bindAccView()
    func bindTableViewScrollable()
    func setupSendButton()
    func scrollToEnd()
    func setInitialIconColor()
}

extension ChatInterfaceAcceptableProtocol where Self: UIViewController {
    
    func configure() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(accView)
        tableView.register(MessageTableCell.self,
                           forCellReuseIdentifier: MessageTableCell.identifier)
        tableView.register(MessageSenderTableCell.self,
                           forCellReuseIdentifier: MessageSenderTableCell.identifier)
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsVerticalScrollIndicator = false
    }
    
    func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(accView.snp.top)
        }
        
        accView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func scrollToNewestChat() {
        socketManager.loadChatLog {
            if self.socketManager.checkRelayIsEmpty() == false {
                self.scrollToEnd()
            }
        }
    }
    
    func bindAccView() {
        accView.textView.rx.observe(CGSize.self, "contentSize")
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, size in
                guard let height = size?.height else { return }
                if owner.accView.textView.numberOfLines < 3 {
                    owner.accView.snp.updateConstraints { make in
                        make.height.equalTo(height + 8)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    func bindTableViewScrollable() {
        socketManager.channelChatRelay
            .bind(with: self) { owner, _ in
                owner.scrollToEnd()
            }
            .disposed(by: disposeBag)
    }

    func setInitialIconColor() {
        accView.rightButton = ChatButton(.chatIcon)
    }
}
