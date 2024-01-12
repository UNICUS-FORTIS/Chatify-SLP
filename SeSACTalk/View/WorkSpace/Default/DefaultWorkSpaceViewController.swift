//
//  DefaultWorkSpaceViewController.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/12/24.
//

import UIKit
import SnapKit


final class DefaultWorkSpaceViewController: UIViewController {
    
    private let tableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setConstraints()
    }
    
    
    private func configure() {
        view.backgroundColor = Colors.Background.primary
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        
        tableView.register(ChannelTableViewCell.self,
                           forCellReuseIdentifier: ChannelTableViewCell.identifier)
        
        tableView.register(ChannelHeaderCell.self,
                           forHeaderFooterViewReuseIdentifier: ChannelHeaderCell.identifier)
        
        tableView.register(ChannelFooterCell.self,
                           forHeaderFooterViewReuseIdentifier: ChannelFooterCell.identifier)
        
    }
    
    private func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
}

extension DefaultWorkSpaceViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ChannelLayoutSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = ChannelLayoutSection.allCases[section]
        switch sections {
        case .channel : return 1
        case .directMessage: return 1
        case .addNewMember: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.identifier,
                                                       for: indexPath) as? ChannelTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
    
}
