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
import RxKeyboard


final class ChatViewController: UIViewController {
    
    private var manager: ChatManager
    private let session = LoginSession.shared
    private lazy var sender = session.makeUserID()
    private let tableView = UITableView(frame: .zero,
                                        style: .plain)
    private let disposeBag = DisposeBag()
    private let accView = CustomInputAccView()
    
    
    private var lastIndexPath: IndexPath? {
        guard let lastRow = tableView.numberOfRows(inSection: 0) > 1 ?
                tableView.numberOfRows(inSection: 0) :
                    nil else { return nil }
        return IndexPath(row: lastRow, section: 0)
    }
    
    init(manager: ChatManager) {
        self.manager = manager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
        bind()
        setUp()
        keyboardSetting()
        setUpSendButton()
        manager.socketManager.startConnect(channelID: manager.createChannelID())
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        manager.socketManager.closeWebSocket()
    }
    
    private func configure() {
        view.backgroundColor = .white
        navigationController?.setChannelChatNavigation(target: self,
                                                       rightAction: #selector(setNavigationRightAction))
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
        tableView.keyboardDismissMode = .onDrag
        accView.textView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tableView.addGestureRecognizer(tapGesture)
    }
    
    private func setConstraints() {
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
    
    private func setUp() {
        manager.loadChatLog()
        manager.fetchUnreadDatas()
    }
    
    private func bind() {
//        manager.chatDatasRelay
//            .observe(on: MainScheduler.instance)
//            .bind(to: tableView.rx.items(cellIdentifier: MessageSenderTableCell.identifier,
//                                         cellType: MessageSenderTableCell.self)) {
//                _, item, cell in
//                
//                cell.datas.accept(item)
//                
//            }.disposed(by: disposeBag)
        
        manager.chatDatasRelay
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items) { [weak self] (tableView, row, item) -> UITableViewCell in
                guard let strongSelf = self else { return UITableViewCell() }
                
                if strongSelf.manager.judgeSender(sender: strongSelf.sender, userID: item.user.userID) {
                    
                    guard let senderCell = tableView.dequeueReusableCell(withIdentifier: MessageSenderTableCell.identifier) as? MessageSenderTableCell else { return UITableViewCell() }
                    senderCell.datas.accept(item)
                    
                    return senderCell
                    
                } else {
                    
                    guard let otherUserCell = tableView.dequeueReusableCell(withIdentifier: MessageTableCell.identifier) as? MessageTableCell else { return UITableViewCell() }
                    
                    otherUserCell.datas.accept(item)
                    return otherUserCell
                }
            }
            .disposed(by: disposeBag)
        
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
    
    private func keyboardSetting() {
        
        RxKeyboard.instance.visibleHeight
            .drive(with: self) { owner, height  in
                owner.accView.snp.updateConstraints { make in
                    let bottomInset = max(0, height - self.view.safeAreaInsets.bottom)
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(bottomInset)
                }
                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func setNavigationRightAction() {
        print("메롱")
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setUpSendButton() {
        accView.rightButton.rx.tap
            .bind(with: self) { owner, _ in
                let message = owner.accView.textView.text
                let files: [Data] = []
                let request = ChatBodyRequest(content: message, files: files)
                owner.manager.messageSender(request: request)
            }
            .disposed(by: disposeBag)
    }
    
    deinit {
        print("채팅 뷰컨트롤러 Deinit")
    }
}

extension ChatViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.textColor = .black
        textView.text = nil
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "메세지를 입력하세요"
            textView.textColor = UIColor.lightGray
        }
    }
}


