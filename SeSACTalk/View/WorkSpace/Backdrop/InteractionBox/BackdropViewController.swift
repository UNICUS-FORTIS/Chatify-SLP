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
    private var workspaceID: Int?
    
    convenience init(boxType: InteractionType, id: Int?) {
        self.init(nibName: nil, bundle: nil)
        self.boxType = boxType
        self.workspaceID = id
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
            box.setCancelButtonAction(target: self, action: #selector(dismissTrigger))
            view.addSubview(box)
            setConstraints(box: box)
            
            switch cancellable {
                
            case .exitFromWorkspace:
                box.setConfirmButtonAction(target: self, action: #selector(exitFromWorkspaceTrigger))
                
            case .removeWorkspace:
                box.setConfirmButtonAction(target: self, action: #selector(confirmRemoveWorkspaceTrigger))
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
}
