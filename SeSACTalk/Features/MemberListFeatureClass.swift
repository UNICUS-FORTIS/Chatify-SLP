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
    
    weak var session = LoginSession.shared
    let tableView = UITableView(frame: .zero, style: .plain)
    let disposeBag = DisposeBag()
    
    
    func bind(target: UIViewController) {
        guard let session = session else { return }
        session.workspaceMember
            .map { member -> WorkspaceMemberResponse in
                guard let member = member else { return [] }
                if member.count <= 1 {
                    let vc = BackdropViewController(boxType: .confirm(.modifyWorkspaceMember),
                                                    id: nil)
                    vc.modalTransitionStyle = .coverVertical
                    vc.modalPresentationStyle = .overFullScreen
                    target.present(vc, animated: false)
                    return []
                } else {
                    return member.filter { session.makeUserID() != $0.userID }
                }
            }
            .bind(to: tableView.rx.items(cellIdentifier: MemberListCell.identifier,
                                         cellType: MemberListCell.self)) {
                _ , item, cell in
                
                cell.data.onNext(item)
                
            }.disposed(by: disposeBag)
    }
    
    func configure(target: UIViewController) {
        target.view.backgroundColor = Colors.Background.primary
        target.view.layer.cornerRadius = 25
        target.view.clipsToBounds = true
        target.view.addSubview(tableView)
        target.navigationController?.setCloseableNavigation(title: "워크스페이스 관리자",
                                                            target: target,
                                                            action: #selector(target.dismissTrigger))
        tableView.register(MemberListCell.self,
                           forCellReuseIdentifier: MemberListCell.identifier)
        tableView.rowHeight = 60
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.contentInset = .init(top: 8, left: 0, bottom: 0, right: 0)
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
    func setConstraints(target: UIViewController) {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(target.view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    func showActionSheet(target: UIViewController, workspace: WorkSpace) { }
}
