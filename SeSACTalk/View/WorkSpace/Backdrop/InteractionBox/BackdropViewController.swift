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
    
    private let repository = RealmRepository.shared
    private let session = LoginSession.shared
    private var boxType: InteractionType?
    private var channel: Channels?
    private var workspaceID: Int?
    private var workspaceManagerReceiverID: Int?
    
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
    
    convenience init(boxType: InteractionType, workspaceID: Int, receiver: Int) {
        self.init(nibName: nil, bundle: nil)
        self.boxType = boxType
        self.workspaceID = workspaceID
        self.workspaceManagerReceiverID = receiver
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
                
            case .handoverWorkspaceManager(_):
                box.setConfirmButtonAction(target: self, action: #selector(confirmHandoverWorkspaceManager))
                
            case .loadChannels:
                box.setConfirmButtonAction(target: self, action: #selector(confirmJoinToChannel))
                
            case .exitFromChannel:
                box.setConfirmButtonAction(target: self, action: #selector(leaveFromChannel))
                
            case .removeChannel:
                box.setConfirmButtonAction(target: self, action: #selector(removeChannel))
                
            case .logout:
                box.setConfirmButtonAction(target: self, action: #selector(logoutAction))
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
        guard let id = workspaceID else { return }
        session.removeWorkspaceDatabase(workspaceID: id)
        let prestingVC = self.presentingViewController
        self.dismiss(animated: false) {
            prestingVC?.dismissTrigger()
        }
    }
    
    @objc func confirmHandoverWorkspaceManager() {
        guard let id = workspaceID,
        let receiver = workspaceManagerReceiverID else { return }
        session.handoverWorkspaceManager(id: id, receiverID: receiver)
        let prestingVC = self.presentingViewController
        self.dismiss(animated: false) {
            prestingVC?.dismissTrigger()
        }
    }
    
    @objc func exitFromWorkspaceTrigger() {
        guard let id = workspaceID else { return }
        session.leaveFromWorkspace(id: id)
        self.dismiss(animated: false)
    }
    
    @objc func confirmJoinToChannel() {
        print(#function)
        guard let channel = channel else { return }
        
        guard let presentingVC = self.presentingViewController?.presentingViewController as? UINavigationController else { return }
        self.presentingViewController?
            .presentingViewController?.dismiss(animated: false) {
                let socketManager = ChatSocketManager(channelInfo: channel)
                let vc = ChannelChatViewController(manager: socketManager)
                presentingVC.pushViewController(vc, animated: true)
            }
    }
    
    @objc func leaveFromChannel() {
        guard let channel = channel else { return }
        session.fetchLeaveFromChannel(channelInfo: channel)
        repository.removeChannelChatting(workspaceID: channel.workspaceID,
                                         channelID: channel.channelID)
        guard let presentingVC = self.presentingViewController as? UINavigationController else { return }
        self.dismiss(animated: false) {
            presentingVC.popToRootViewController(animated: true)
        }
    }
    
    @objc func removeChannel() {
        guard let channel = channel else { return }
        session.removeChannel(channel: channel)
        guard let presentingVC = self.presentingViewController as? UINavigationController else { return }
        self.dismiss(animated: false) {
            presentingVC.popToRootViewController(animated: true)
        }
    }
    
    @objc func logoutAction() {
        UserdefaultManager.setLogout()
        session.setViewControllerActor?()
        guard let previous = self.presentingViewController as? UINavigationController else { return }
            session.fetchLogout { [weak self] in
                self?.dismiss(animated: false) {
                    previous.popToRootViewController(animated: false)
                    print("로그아웃 완료")
            }
        }
    }
    
    deinit {
        print("백드롭 뷰컨트롤러 Deinit됨")
    }
}

