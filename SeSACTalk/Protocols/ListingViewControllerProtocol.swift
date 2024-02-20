//
//  ListingViewControllerType.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/26/24.
//

import UIKit
import SnapKit

protocol ListingViewControllerProtocol: AnyObject {
    
    var session: LoginSession { get }
    var tableView: UITableView { get }
    
    func bind(target: UIViewController)
    func configure(target: UIViewController)
    func setConstraints(target: UIViewController)
    func setNavigationController(target: UIViewController)
    func registerTableViewCell()
    func setTableViewRowheight()
    func showActionSheet(target: UIViewController, workspace: WorkSpace)
}

extension ListingViewControllerProtocol {
    
    func setConstraints(target: UIViewController) {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(target.view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    func configure(target: UIViewController) {
        target.view.backgroundColor = Colors.Background.primary
        target.view.layer.cornerRadius = 25
        target.view.clipsToBounds = true
        target.view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.contentInset = .init(top: 8, left: 0, bottom: 0, right: 0)
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
    func registerTableViewCell() {
        tableView.register(MemberListCell.self,
                           forCellReuseIdentifier: MemberListCell.identifier)
    }
    
}
