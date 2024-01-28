//
//  UIAlertController+Extension.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/20/24.
//

import UIKit


extension UIViewController {
    
    func showWorkspaceSheet(workspace: WorkSpace) {
        
        let sheet = UIAlertController(title: "", message: "",
                                      preferredStyle: .actionSheet)
        
        let edit = UIAlertAction(title: "워크스페이스 편집", style: .default) { [weak self] action in
            
            let vc = WorkSpaceEditViewController(viewModel: EmptyWorkSpaceViewModel(editMode: .edit,
                                                                                    workspaceInfo: workspace))
            let navVC = UINavigationController(rootViewController: vc)
            vc.modalTransitionStyle = .coverVertical
            self?.present(navVC, animated: true)
        }
        
        let exit = UIAlertAction(title: "워크스페이스 나가기", style: .default) { [weak self] action in
            let id = session.makeUserID()
            if id == workspace.ownerID {
                let vc = BackdropViewController(boxType: .confirm(.exitFromWorkspace),
                                                id: id)
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .overFullScreen
                self?.present(vc, animated: false)
            } else {
                let vc = BackdropViewController(boxType: .cancellable(.exitFromWorkspace),
                                                id: id)
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .overFullScreen
                self?.present(vc, animated: false)
            }
        }
        
        let changeOwner = UIAlertAction(title: "워크스페이스 관리자 변경", style: .default) { action in
            session.loadWorkspaceMember(id: workspace.workspaceID)
            let feature = MemberListFeatureClass()
            let vc = ListingViewController(feature: feature)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .currentContext
            self.present(navVC, animated: true)
        }
        
        let delete = UIAlertAction(title: "워크스페이스 삭제", style: .destructive) { [weak self] action in
            let vc = BackdropViewController(boxType: .cancellable(.removeWorkspace),
                                            id: workspace.workspaceID)
            
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .overFullScreen
            self?.present(vc, animated: false)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel) { action in
            print("취소")
        }
        
        sheet.addAction(edit)
        sheet.addAction(exit)
        sheet.addAction(changeOwner)
        sheet.addAction(delete)
        sheet.addAction(cancel)
        present(sheet, animated: true)
    }
    
    @objc func dismissTrigger() {
        self.dismiss(animated: true)
    }
}
