//
//  ChannelMemberFeatureClass.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/21/24.
//

import UIKit
import RxSwift

final class ChannelMemberFeatureClass: ListingViewControllerProtocol {
        
    var session: LoginSession
    var tableView: UITableView
    var viewModel: ChannelSettingViewModel
    var disposeBag = DisposeBag()
    
    init(viewModel: ChannelSettingViewModel) {
        self.session = LoginSession.shared
        self.tableView = UITableView()
        self.viewModel = viewModel
        
    }
    
    func bind(target: UIViewController) {
        viewModel.userModelsRelay
            .bind(to: tableView.rx.items(cellIdentifier: MemberListCell.identifier,
                                         cellType: MemberListCell.self)) {
                _, item, cell in
                cell.channelUserData.onNext(item)
            }.disposed(by: disposeBag)
    }
    
    func setNavigationController(target: UIViewController) {
        target.navigationController?.setDefaultNavigation(target: target,
                                                          title: "채널 관리자 변경")
    }
    
    func registerTableViewCell() {
        tableView.register(MemberListCell.self,
                           forCellReuseIdentifier: MemberListCell.identifier)
    }
    
    func setTableViewRowheight() {
        tableView.rowHeight = 60
    }
    
    func showActionSheet(target: UIViewController, currendUserID: Int, workspace: WorkSpace) { }
}
