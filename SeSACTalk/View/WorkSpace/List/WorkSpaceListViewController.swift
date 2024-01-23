//
//  WorkSpaceViewController.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/19/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


final class WorkSpaceListViewController: UIViewController {
    
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private let addNewWorkSpaceButton = SideMenuButton(title: "워크스페이스 추가", icon: .plus)
    private let helpButton = SideMenuButton(title: "도움말", icon: .help)
    private let session = LoginSession.shared
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setConstraints()
        bind()
    }
    
    private func bind() {
        
        session.workSpacesSubject
            .map { workSpaces -> WorkSpaces in
                guard let workSpaces = workSpaces else { return [] }
                return workSpaces
            }
            .bind(to: tableView.rx.items(cellIdentifier: WorkSpaceListingCell.identifier,
                                         cellType: WorkSpaceListingCell.self)) {
                _ , item, cell in
                cell.data.onNext(item)
                cell.showWorkspaceSheet = {
                    self.showWorkspaceSheet(workspace: item)
                }
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(with: self) { owner, indexPath in
                guard let selectedCell = owner.tableView.cellForRow(at: indexPath) as? WorkSpaceListingCell else { return }
                selectedCell.selection.onNext(true)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemDeselected
            .subscribe(with: self) { owner, indexPath in
                guard let selectedCell = owner.tableView.cellForRow(at: indexPath) as? WorkSpaceListingCell else { return }
                selectedCell.selection.onNext(false)
            }
            .disposed(by: disposeBag)
        
        addNewWorkSpaceButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let vc = WorkSpaceEditViewController(viewModel: EmptyWorkSpaceViewModel(editMode: .create,
                                                                                        workspaceInfo: nil))
                let navVC = UINavigationController(rootViewController: vc)
                vc.modalTransitionStyle = .coverVertical
                owner.present(navVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func guideToInitialViewController() {
        let vc = WorkSpaceInitialViewController()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        navVC.modalTransitionStyle = .coverVertical
        navigationController?.present(navVC, animated: true)
    }
    
    private func configure() {
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        view.clipsToBounds = true
        view.addSubview(tableView)
        view.addSubview(addNewWorkSpaceButton)
        view.addSubview(helpButton)
        tableView.register(WorkSpaceListingCell.self,
                           forCellReuseIdentifier: WorkSpaceListingCell.identifier)
        tableView.rowHeight = 72
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.contentInset = .init(top: 8, left: 0, bottom: 0, right: 0)
        tableView.contentInsetAdjustmentBehavior = .never
        
        navigationController?.setWorkSpaceListNavigation()
    }
    
    
    
    private func setConstraints() {
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(addNewWorkSpaceButton.snp.top)
        }
        
        helpButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
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
    
}


