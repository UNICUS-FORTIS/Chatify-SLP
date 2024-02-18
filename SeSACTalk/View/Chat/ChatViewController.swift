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


final class ChatViewController: UIViewController {
    
    private var socketManager: ChatProtocol?
    private let session = LoginSession.shared
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
    
    init(manager: ChatProtocol) {
        self.socketManager = manager
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
        setUpSendButton()
        keyboardSetting(target: self,
                        view: accView,
                        tableView: tableView,
                        scrollView: nil, 
                        disposeBag: disposeBag)
        scrollToNewestChat()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        socketManager?.connectSocket()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        socketManager?.disconnectSocket()
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
        tableView.showsVerticalScrollIndicator = false
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
    
    private func scrollToNewestChat() {
        socketManager?.loadChatLog { [weak self] in
            guard let safeManager = self?.socketManager else { return }
            if safeManager.checkRelayIsEmpty() == false {
                self?.scrollToEnd()
            }
        }
    }
    
    private func bind() {

        socketManager?.channelChatRelay
            .map  { chats in
                chats.sorted { $0.createdAt < $1.createdAt }
            }
            .bind(to: tableView.rx.items) { [weak self] (tableView, row, item) -> UITableViewCell in
                if self?.socketManager?.judgeSender(sender: self?.session.makeUserID() ?? 00,
                                               userID: item.user?.userID ?? 00) ?? true {
                    
                    guard let senderCell = tableView.dequeueReusableCell(withIdentifier: MessageSenderTableCell.identifier) as? MessageSenderTableCell else { return UITableViewCell() }
                    
                    senderCell.bind(data: item)
                    return senderCell
                    
                } else {
                    
                    guard let otherUserCell = tableView.dequeueReusableCell(withIdentifier: MessageTableCell.identifier) as? MessageTableCell else { return UITableViewCell() }
                    
                    otherUserCell.bind(data: item)
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
        
        socketManager?.channelChatRelay
            .bind(with: self) { owner, _ in
                owner.scrollToEnd()
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func setNavigationRightAction() {
        print("메롱")
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setUpSendButton() {
        accView.rightButton.rx.tap
            .bind(with: self) { owner, _ in
                let message = owner.accView.textView.text ?? ""
                let files: [Data] = []
                let request = ChatBodyRequest(content: message, files: files)
                owner.socketManager?.messageSender(request: request)
                owner.accView.textView.text = ""
            }
            .disposed(by: disposeBag)
    }
    
    private func scrollToEnd() {
        print(#function)
        guard let count = socketManager?.channelChatRelay.value.count else { return }
        if count > 1 {
            let last = count - 1
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: last, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
    
    private func initialIconColor() {
        accView.rightButton = ChatButton(.chatIcon)
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
            initialIconColor()
        }
    }
}


