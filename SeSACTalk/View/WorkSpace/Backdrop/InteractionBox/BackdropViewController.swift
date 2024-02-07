//
//  BackdropViewController.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/24/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


final class BackdropViewController: UIViewController {
    
    
    private weak var session = LoginSession.shared
    private var boxType: InteractionType?
    private var channel: Channels?
    private var workspaceID: Int?
    
    convenience init(boxType: InteractionType, workspaceID: Int?) {
        self.init(nibName: nil, bundle: nil)
        self.boxType = boxType
        self.workspaceID = workspaceID
    }
    
    convenience init(boxType: InteractionType, workspaceID: Int, channel: Channels) {
        self.init(nibName: nil, bundle: nil)
        self.boxType = boxType
        self.workspaceID = workspaceID
        self.channel = channel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        view.backgroundColor = .black.withAlphaComponent(0.5)
        
        switch boxType {
            
        case .confirm(let acceptable):
            let box = OnlyConfirmBox(type: acceptable)
            box.setConfirmButtonAction(target: self, action: #selector(self.dismissTriggerNonAnimated))
            view.addSubview(box)
            setConstraints(box: box)
            
            
        case .cancellable(let cancellable):
            let box = CancellableBox(type: cancellable)
            box.setCancelButtonAction(target: self, action: #selector(dismissTriggerNonAnimated))
            view.addSubview(box)
            setConstraints(box: box)
            
            switch cancellable {
                
            case .exitFromWorkspace:
                box.setConfirmButtonAction(target: self, action: #selector(exitFromWorkspaceTrigger))
                
            case .removeWorkspace:
                box.setConfirmButtonAction(target: self, action: #selector(confirmRemoveWorkspaceTrigger))
                
            case .loadChannels:
                box.setConfirmButtonAction(target: self, action: #selector(confirmJoinToChannel))
            }
            
        default: break
        }
    }
    
    
    private func setConstraints(box: UIView) {
        box.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(25)
        }
    }
    
    @objc func confirmRemoveWorkspaceTrigger() {
        guard let id = workspaceID,
              let session = session else { return }
        session.removeWorkSpace(id: id)
        self.dismiss(animated: false)
    }
    
    @objc func exitFromWorkspaceTrigger() {
        guard let id = workspaceID,
              let session = session else { return }
        print(id, "현재 워크스페이스 아이디")
        session.leaveFromWorkspace(id: id)
        self.dismiss(animated: false)
    }
    
    @objc func confirmJoinToChannel() {
        print(#function)
        guard let channel = channel,
              let workspace = workspaceID else { return }
        
        session?.pushChatPageTrigger = {
            let manager = ChatManager(iD: workspace,
                                      channelName: channel.name,
                                      channelID: channel.channelID)
            
            let vc = ChatViewController(manager: manager)
            let navVC = UINavigationController(rootViewController: vc)
            let rootVC = DefaultWorkSpaceViewController.shared
            rootVC.navigationController?.pushViewController(navVC, animated: true)
        }
        
        self.presentingViewController?
            .presentingViewController?.dismiss(animated: true) { [weak self] in
                self?.session?.pushChatPageTrigger?()
            }
    }
    deinit {
        print("백드롭 뷰컨트롤러 Deinit됨")
    }
}

