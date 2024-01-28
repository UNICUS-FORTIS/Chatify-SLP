//
//  WorkspaceListFeatureClass.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/26/24.
//

import UIKit
import RxSwift


final class WorkspaceListFeatureClass: ListingViewControllerProtocol {

    weak var session = LoginSession.shared
    let tableView = UITableView(frame: .zero, style: .plain)
    let addNewWorkSpaceButton = SideMenuButton(title: "워크스페이스 추가", icon: .plus)
    let helpButton = SideMenuButton(title: "도움말", icon: .help)
    private let disposeBag = DisposeBag()
    
    func bind(target: UIViewController) {
        guard let session = session else { return }
        session.workSpacesSubject
            .map { workSpaces -> WorkSpaces in
                guard let workSpaces = workSpaces else { return [] }
                return workSpaces
            }
            .bind(to: tableView.rx.items(cellIdentifier: WorkspaceListingCell.identifier,
                                         cellType: WorkspaceListingCell.self)) {
                row , item, cell in
                cell.data.onNext(item)
                cell.showWorkspaceSheet = {
                    self.showActionSheet(target: target, workspace: item)
                }
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(with: self) { owner, indexPath in
                guard let selectedCell = owner.tableView.cellForRow(at: indexPath) as? WorkspaceListingCell else { return }
                selectedCell.selection.onNext(true)
                session.modifyCurrentWorkspace(path: indexPath)
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
        print("실행됨 컨피규어")
        target.view.backgroundColor = .white
        target.view.layer.cornerRadius = 25
        target.view.clipsToBounds = true
        target.view.addSubview(tableView)
        target.view.addSubview(addNewWorkSpaceButton)
        target.view.addSubview(helpButton)
        tableView.register(WorkspaceListingCell.self,
                           forCellReuseIdentifier: WorkspaceListingCell.identifier)
        tableView.rowHeight = 72
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
    
    func showActionSheet(target: UIViewController, workspace: WorkSpace) {
        target.showWorkspaceSheet(workspace: workspace)
    }
    
//    private func guideToInitialViewController() {
//        let vc = WorkSpaceInitialViewController()
//        let navVC = UINavigationController(rootViewController: vc)
//        navVC.modalPresentationStyle = .fullScreen
//        navVC.modalTransitionStyle = .coverVertical
//        navigationController?.present(navVC, animated: true)
//    }
}
