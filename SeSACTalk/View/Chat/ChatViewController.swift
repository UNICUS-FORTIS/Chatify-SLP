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
    
    private var manager = ChatManager()
    private let session = LoginSession.shared
    private let tableView = UITableView(frame: .zero,
                                        style: .plain)
    private let disposeBag = DisposeBag()
    private let accView = CustomInputAccView()
    
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
        view.addSubview(accView)
        
        tableView.register(MessageSenderTableCell.self,
                           forCellReuseIdentifier: MessageSenderTableCell.identifier)
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.keyboardDismissMode = .onDrag
        accView.textView.delegate = self
    }
    
    private func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
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
        manager.startSocketConnect()
    }
    
    private func bind() {
        manager.chatDatasRelay
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: MessageSenderTableCell.identifier,
                                         cellType: MessageSenderTableCell.self)) {
                _, item, cell in
                
                cell.datas.accept(item)
                
            }.disposed(by: disposeBag)
        
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
    
    @objc private func setNavigationRightAction() {
        print("메롱")
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


