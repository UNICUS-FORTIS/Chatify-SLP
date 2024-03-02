//
//  MemberListFeatureClass.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/26/24.
//

import UIKit
import RxSwift
import RxCocoa


final class MemberListFeatureClass: ListingViewControllerProtocol {
    
    var session: LoginSession
    var tableView: UITableView
    var disposeBag = DisposeBag()
    var mode: MemberListingMode
    
    init(mode: MemberListingMode) {
        self.mode = mode
        self.session = LoginSession.shared
        self.tableView = UITableView()
    }
    
    func bind(target: UIViewController) {
        session.workspaceMember
            .map { member -> WorkspaceMemberResponse in
                print(member)
                if member.count < 1 {
                    switch self.mode {
                    case .handoverWorkspaceManager:
                        let vc = BackdropViewController(boxType: .confirm(.modifyWorkspaceMember),
                                                        workspaceID: nil)
                        vc.modalTransitionStyle = .coverVertical
                        vc.modalPresentationStyle = .overFullScreen
                        target.present(vc, animated: false)
                    case .dm:
                        let vc = BackdropViewController(boxType: .confirm(.findDmTarget),
                                                        workspaceID: nil)
                        vc.modalTransitionStyle = .coverVertical
                        vc.modalPresentationStyle = .overFullScreen
                        target.present(vc, animated: false)
                    }
                    return []                    
                } else {
                    return member
                }
            }
            .bind(to: tableView.rx.items(cellIdentifier: MemberListCell.identifier,
                                         cellType: MemberListCell.self)) {
                _ , item, cell in
                
                cell.data.onNext(item)
                
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(with: self) { owner, indexPath in
                let currentWorkspace = try? owner.session.currentWorkspaceSubject.value()
                let member = try? owner.session.workspaceMember.value()

                switch owner.mode {
                case .handoverWorkspaceManager:
                    guard let workspace = currentWorkspace,
                          let member = member else { return }
                    let vc = BackdropViewController(boxType: .cancellable(.handoverWorkspaceManager(name: member[indexPath.row].nickname)), workspaceID: workspace.workspaceID, receiver: member[indexPath.row].userID)
                    vc.modalTransitionStyle = .coverVertical
                    vc.modalPresentationStyle = .overFullScreen
                    target.present(vc, animated: false)
            
                    print("관리자 변경 to", member[indexPath.row].userID)
                case .dm:
                    guard let workspace = currentWorkspace,
                          let member = member else { return }
                    let previous = target.presentingViewController as? UINavigationController
                    let manager = DMSocketManager(targetUserID: member[indexPath.row].userID,
                                                  workspaceID: workspace.workspaceID,
                                                  nickname: member[indexPath.row].nickname)
                    let vc = DMChatViewController(manager: manager)
                    target.dismiss(animated: true) {
                        previous?.pushViewController(vc, animated: true)
                    }
                }
                
            }
            .disposed(by: disposeBag)
    }
    
    func setNavigationController(target: UIViewController) {
        
        var title = ""
        
        switch mode {
        case .handoverWorkspaceManager:
            title = "워크스페이스 관리자"
        case .dm:
            title = "DM"
        }
        
        target.navigationController?.setCloseableNavigation(title: title,
                                                            target: target,
                                                            action: #selector(target.dismissTrigger))
    }
    
    func setTableViewRowheight() {
        tableView.rowHeight = 60
    }
    
    func showActionSheet(target: UIViewController, currendUserID: Int, workspace: WorkSpace) { }
}
