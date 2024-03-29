//
//  UIAlertController+Extension.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/20/24.
//

import UIKit
import SnapKit
import RxSwift
import RxKeyboard


extension UIViewController {
    
    func showWorkspaceSheet(currendUserID: Int, workspace: WorkSpace) {
        
        let sheet = UIAlertController(title: "", message: "",
                                      preferredStyle: .actionSheet)
        
        let edit = UIAlertAction(title: "워크스페이스 편집", style: .default) { [weak self] action in
            
            if currendUserID == workspace.ownerID {
                let vc = WorkSpaceEditViewController(viewModel: EmptyWorkSpaceViewModel(editMode: .edit,
                                                                                        workspaceInfo: workspace))
                let navVC = UINavigationController(rootViewController: vc)
                vc.modalTransitionStyle = .coverVertical
                self?.present(navVC, animated: true)
            } else {
                let vc = BackdropViewController(boxType: .confirm(.editWorkspace), workspaceID: nil)
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .overFullScreen
                self?.present(vc, animated: false)
            }
            
        }
        
        let exit = UIAlertAction(title: "워크스페이스 나가기", style: .default) { [weak self] action in
            let id = session.makeUserID()
            if id == workspace.ownerID {
                let vc = BackdropViewController(boxType: .confirm(.exitFromWorkspace),
                                                workspaceID: workspace.workspaceID)
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .overFullScreen
                self?.present(vc, animated: false)
            } else {
                let vc = BackdropViewController(boxType: .cancellable(.exitFromWorkspace),
                                                workspaceID: workspace.workspaceID)
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .overFullScreen
                self?.present(vc, animated: false)
            }
        }
        
        let changeOwner = UIAlertAction(title: "워크스페이스 관리자 변경", style: .default) { [weak self] action in
            if currendUserID == workspace.ownerID {
                DispatchQueue.main.async {
                    session.loadWorkspaceMember(id: workspace.workspaceID) {
                        let feature = MemberListFeatureClass(mode: .handoverWorkspaceManager)
                        let vc = ListingViewController(feature: feature)
                        let navVC = UINavigationController(rootViewController: vc)
                        navVC.modalTransitionStyle = .coverVertical
                        vc.modalPresentationStyle = .currentContext
                        self?.present(navVC, animated: true)
                    }
                }
            } else {
                let vc = BackdropViewController(boxType: .confirm(.modifyWorkspaceManager),
                                                workspaceID: nil)
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .overFullScreen
                self?.present(vc, animated: false)
            }
            
        }
        
        let delete = UIAlertAction(title: "워크스페이스 삭제", style: .destructive) { [weak self] action in
            if currendUserID == workspace.ownerID {
                let vc = BackdropViewController(boxType: .cancellable(.removeWorkspace),
                                                workspaceID: workspace.workspaceID)
                
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .overFullScreen
                self?.present(vc, animated: false)
            } else {
                let vc = BackdropViewController(boxType: .confirm(.removeWorkspace), workspaceID: nil)
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .overFullScreen
                self?.present(vc, animated: false)
            }
            
            
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
    
    func showActionSheetForChannelFooter() {
        
        let sheet = UIAlertController(title: nil, message: nil,
                                      preferredStyle: .actionSheet)
        
        let create = UIAlertAction(title: "채널 생성", style: .default) { [weak self] action in
            
            let vc = ChannelAddViewController(viewTitle: "채널 생성")
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalTransitionStyle = .coverVertical
            self?.present(navVC, animated: true)
        }
        
        let search = UIAlertAction(title: "채널 탐색", style: .default) { [weak self] action in
            
            let feature = ChannelListFeatureClass()
            let vc = ListingViewController(feature: feature)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalTransitionStyle = .coverVertical
            navVC.modalPresentationStyle = .fullScreen
            self?.present(navVC, animated: true)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        sheet.addAction(create)
        sheet.addAction(search)
        sheet.addAction(cancel)
        present(sheet, animated: true)
    }
    
    @objc func dismissTrigger() {
        self.dismiss(animated: true)
    }
    
    @objc func dismissTriggerNonAnimated() {
        self.dismiss(animated: false)
    }
    
    func keyboardSetting<T: UIView>(target: UIViewController,
                                    view: T,
                                    tableView: UITableView?,
                                    scrollView: UIScrollView?,
                                    disposeBag: DisposeBag) {
        
        RxKeyboard.instance.visibleHeight
            .drive(with: target) { owner, height in
                UIView.animate(withDuration: 0.25) {
                    view.snp.updateConstraints { make in
                        let bottomInset = max(0, height - owner.view.safeAreaInsets.bottom)
                        make.bottom.equalTo(owner.view.safeAreaLayoutGuide).inset(bottomInset + 12)
                    }
                    if let tableView = tableView {
                        tableView.contentOffset.y += height
                    }
                }
                owner.view.layoutIfNeeded()
            }
            .disposed(by: disposeBag)
    }
    
}
