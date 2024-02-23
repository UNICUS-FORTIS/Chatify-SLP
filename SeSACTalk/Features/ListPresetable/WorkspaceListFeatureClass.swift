//
//  WorkspaceListFeatureClass.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/26/24.
//

import UIKit
import RxSwift


final class WorkspaceListFeatureClass: ListingViewControllerProtocol {
    
    
    var session: LoginSession
    var tableView: UITableView
    private let addNewWorkSpaceButton = SideMenuButton(title: "워크스페이스 추가", icon: .plus)
    private let helpButton = SideMenuButton(title: "도움말", icon: .help)
    private let disposeBag = DisposeBag()
    
    init() {
        self.session = LoginSession.shared
        self.tableView = UITableView()
    }
    
    func bind(target: UIViewController) {
        session.workSpacesSubject
            .map { workSpaces -> WorkSpaces in
                guard let workSpaces = workSpaces else { return [] }
                return workSpaces
            }
            .bind(to: tableView.rx.items(cellIdentifier: WorkspaceListingCell.identifier,
                                         cellType: WorkspaceListingCell.self)) {
                row , item, cell in
                cell.setWorkspaceData(workspace: item)
                cell.showWorkspaceSheet = {
                    self.showActionSheet(target: target,
                                         currendUserID: self.session.makeUserID(),
                                         workspace: item)
                }
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(with: self) { owner, indexPath in
                guard let selectedCell = owner.tableView.cellForRow(at: indexPath) as? WorkspaceListingCell else { return }
                selectedCell.selection.onNext(true)
                self.session.modifyCurrentWorkspace(path: indexPath)
                target.dismissTrigger()
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemDeselected
            .subscribe(with: self) { owner, indexPath in
                guard let selectedCell = owner.tableView.cellForRow(at: indexPath) as? WorkspaceListingCell else { return }
                selectedCell.selection.onNext(false)
            }
            .disposed(by: disposeBag)
        
        addNewWorkSpaceButton.rx.tap
            .subscribe(with: target) { owner, _ in
                let vc = WorkSpaceEditViewController(viewModel: EmptyWorkSpaceViewModel(editMode: .create,
                                                                                        workspaceInfo: nil))
                let navVC = UINavigationController(rootViewController: vc)
                vc.modalTransitionStyle = .coverVertical
                owner.present(navVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func configure(target: UIViewController) {
        target.view.backgroundColor = .white
        target.view.layer.cornerRadius = 25
        target.view.clipsToBounds = true
        target.view.addSubview(tableView)
        target.view.addSubview(addNewWorkSpaceButton)
        target.view.addSubview(helpButton)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.contentInset = .init(top: 8, left: 0, bottom: 0, right: 0)
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
    func setConstraints(target: UIViewController) {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(target.view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(addNewWorkSpaceButton.snp.top)
        }
        
        helpButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(target.view.safeAreaLayoutGuide).inset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(41)
        }
        
        addNewWorkSpaceButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(helpButton.snp.top)
            make.centerX.equalToSuperview()
            make.height.equalTo(41)
        }
    }
    
    func setNavigationController(target: UIViewController) { }
    
    func registerTableViewCell() {
        tableView.register(WorkspaceListingCell.self,
                           forCellReuseIdentifier: WorkspaceListingCell.identifier)
    }
    
    func setTableViewRowheight() {
        tableView.rowHeight = 72
    }
    
    func showActionSheet(target: UIViewController, currendUserID: Int, workspace: WorkSpace) {
        target.showWorkspaceSheet(currendUserID:currendUserID, workspace: workspace)
    }
    
//    private func guideToInitialViewController() {
//        let vc = WorkSpaceInitialViewController()
//        let navVC = UINavigationController(rootViewController: vc)
//        navVC.modalPresentationStyle = .fullScreen
//        navVC.modalTransitionStyle = .coverVertical
//        navigationController?.present(navVC, animated: true)
//    }
}
