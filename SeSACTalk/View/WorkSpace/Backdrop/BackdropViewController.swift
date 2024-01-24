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
    
    
    private let session = LoginSession.shared
    private var backdropMode: BackdropMode?
    private var boxType: InteractionTypeCancellable?
    private var workspaceID: Int?
    
    convenience init(mode: BackdropMode, boxType: InteractionTypeCancellable, id: Int) {
        self.init(nibName: nil, bundle: nil)
        self.backdropMode = mode
        self.boxType = boxType
        self.workspaceID = id
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    private func configure() {
        view.backgroundColor = .black.withAlphaComponent(0.5)
        switch backdropMode {
        case .requireOnlyConfirm:
            break
            
        case .requireWithCancel:
            guard let safe = boxType else { return }
            let box = CancellableBox(type: safe)
            box.setCancelButtonAction(target: self, action: #selector(dismissTrigger))
            view.addSubview(box)
            setConstraints(box: box)
            
            switch boxType {
            case .workspaceExit:
                break
                
            case .removeWorkspace:
                box.setConfirmButtonAction(target: self, action: #selector(confirmButtonTrigger))
                
            case nil:
                break
            }
            
        case nil:
            break
        } 
    }
    
    
    private func setConstraints(box: UIView) {
        box.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(25)
        }
    }
    
    @objc func dismissTrigger() {
    }
    
    @objc func confirmButtonTrigger() {
        guard let id = workspaceID else { return }
        session.removeWorkSpace(id: id)
        self.dismiss(animated: false)
    }
}
