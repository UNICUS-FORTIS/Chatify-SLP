//
//  MemberListFeatureClass.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/26/24.
//

import UIKit
import RxSwift


final class MemberListFeatureClass: ListingViewControllerProtocol {
    
    weak var session = LoginSession.shared
    let tableView = UITableView(frame: .zero, style: .plain)
    let disposeBag = DisposeBag()

    
    func bind(target: UIViewController) {
        guard let session = session else { return }
        session.workspaceMember
            .map { member -> WorkspaceMemberResponse in
                guard let member = member else { return [] }
                return member
            }
            .bind(to: tableView.rx.items(cellIdentifier: MemberListCell.identifier,
                                         cellType: MemberListCell.self)) {
                row , item, cell in
                cell.data.onNext(item)

            }.disposed(by: disposeBag)
    }
    
    func configure(target: UIViewController) {
        target.view.backgroundColor = .white
        target.view.layer.cornerRadius = 25
        target.view.clipsToBounds = true
        target.view.addSubview(tableView)
        tableView.register(WorkspaceListingCell.self,
                           forCellReuseIdentifier: WorkspaceListingCell.identifier)
        tableView.rowHeight = 72
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.contentInset = .init(top: 8, left: 0, bottom: 0, right: 0)
        tableView.contentInsetAdjustmentBehavior = .never
        
        target.navigationController?.setWorkSpaceListNavigation()
    }
    
    func setConstraints(target: UIViewController) {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func showActionSheet(target: UIViewController, workspace: WorkSpace) { }
}
