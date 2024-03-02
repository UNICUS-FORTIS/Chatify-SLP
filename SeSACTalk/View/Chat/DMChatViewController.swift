//
//  DMChatViewController.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/27/24.
//

import UIKit
import RxSwift
import RxCocoa


final class DMChatViewController: UIViewController {
    
    var socketManager: ChatProtocol
    var session: LoginSession
    var tableView: UITableView
    var accView: CustomInputAccView
    var disposeBag: DisposeBag
    
    var lastIndexPath: IndexPath? {
        guard let lastRow = tableView.numberOfRows(inSection: 0) > 1 ?
                tableView.numberOfRows(inSection: 0) :
                    nil else { return nil }
        return IndexPath(row: lastRow, section: 0)
    }
    
    init(manager: ChatProtocol) {
        self.socketManager = manager
        self.session = LoginSession.shared
        self.tableView = UITableView()
        self.accView = CustomInputAccView()
        self.disposeBag = DisposeBag()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
        setTextViewDelegate()
        setupNavigation()
        setupSendButton()
        setupTapGesture()
        bindTableView()
        bindTableViewScrollable()
        setTextViewDelegate()
        scrollToNewestChat()
        keyboardSetting(target: self,
                        view: accView,
                        tableView: tableView,
                        scrollView: nil,
                        disposeBag: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        socketManager.connectSocket()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        socketManager.disconnectSocket()
    }
        
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    deinit {
        print("DM 챗 뷰컨트롤러 deinit 됨")
    }
}

extension DMChatViewController: ChatInterfaceAcceptableProtocol {
    
    
    func setTextViewDelegate() {
        accView.textView.delegate = self
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tableView.addGestureRecognizer(tapGesture)
    }
    
    func setupNavigation() {
        socketManager.titlenameRelay
            .bind(with: self) { owner, title in
                owner.navigationController?.setDefaultNavigation(target: self, title: title)
            }
            .disposed(by: disposeBag)
    }
    
    func bindTableView() {
        socketManager.dmChatRelay
            .map  { chats in
                chats.sorted { $0.createdAt < $1.createdAt }
            }
            .bind(to: tableView.rx.items) { [weak self] (tableView, row, item) -> UITableViewCell in
                if self?.socketManager.judgeSender(sender: self?.session.makeUserID() ?? 00,
                                                   userID: item.user?.userID ?? 00) ?? true {
                    
                    guard let senderCell = tableView.dequeueReusableCell(withIdentifier: MessageSenderTableCell.identifier) as? MessageSenderTableCell else { return UITableViewCell() }
                    
                    senderCell.bind(dmData: item)
                    return senderCell
                    
                } else {
                    
                    guard let otherUserCell = tableView.dequeueReusableCell(withIdentifier: MessageTableCell.identifier) as? MessageTableCell else { return UITableViewCell() }
                    
                    otherUserCell.bind(dmData: item)
                    return otherUserCell
                }
            }
            .disposed(by: disposeBag)
    }
    
    func setupSendButton() {
        accView.rightButton.rx.tap
            .bind(with: self) { owner, _ in
                let message = owner.accView.textView.text ?? ""
                let files: [Data] = []
                let request = ChatBodyRequest(content: message, files: files)
                owner.socketManager.messageSender(request: request)
                owner.accView.textView.text = ""
            }
            .disposed(by: disposeBag)
    }
    
    func scrollToNewestChat() {
        socketManager.scroller = { [weak self] in
            if self?.socketManager.checkRelayIsEmpty() == false {
                self?.scrollToEnd()
            }
        }
    }
    
    func scrollToEnd() {
        let count = socketManager.dmChatRelay.value.count
        if count > 1 {
            let last = count - 1
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: last, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
    
    func bindTableViewScrollable() {
        socketManager.dmChatRelay
            .bind(with: self) { owner, _ in
                owner.scrollToEnd()
            }
            .disposed(by: disposeBag)
    }
}

extension DMChatViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.textColor = .black
        textView.text = nil
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "메세지를 입력하세요"
            textView.textColor = UIColor.lightGray
            setInitialIconColor()
        }
    }
}
