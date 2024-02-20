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
    
    init() {
        self.session = LoginSession.shared
        self.tableView = UITableView()
    }
    
    func bind(target: UIViewController) {
        session.workspaceMember
            .map { member -> WorkspaceMemberResponse in
                if member.count <= 1 {
                    let vc = BackdropViewController(boxType: .confirm(.modifyWorkspaceMember),
                                                    workspaceID: nil)
                    vc.modalTransitionStyle = .coverVertical
                    vc.modalPresentationStyle = .overFullScreen
                    target.present(vc, animated: false)
                    return []
                } else {
                    return member.filter { self.session.makeUserID() != $0.userID }
                }
            }
            .bind(to: tableView.rx.items(cellIdentifier: MemberListCell.identifier,
                                         cellType: MemberListCell.self)) {
                _ , item, cell in
                
                cell.data.onNext(item)
                
            }.disposed(by: disposeBag)
    }
    
    func setNavigationController(target: UIViewController) {
        target.navigationController?.setCloseableNavigation(title: "워크스페이스 관리자",
                                                            target: target,
                                                            action: #selector(target.dismissTrigger))
    }
    
    func setTableViewRowheight() {
        tableView.rowHeight = 60
    }
    
    func showActionSheet(target: UIViewController, workspace: WorkSpace) { }
}
