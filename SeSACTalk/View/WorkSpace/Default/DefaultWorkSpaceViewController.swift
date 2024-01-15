//
//  DefaultWorkSpaceViewController.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/12/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources


final class DefaultWorkSpaceViewController: UIViewController {
    
    private let session = LoginSession.shared
    private let tableView = UITableView()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setConstraints()
        navigationController?.setWorkSpaceNavigation()
        bind()
    }
    
    private func bind() {
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel>(configureCell: { dataSource, tableView, indexPath, item in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.identifier) as? ChannelTableViewCell else { return UITableViewCell() }
            
            switch item.sectionType {
            case .channel:

                self.session.channelInfo
                    .bind(with: self) { owner, response in
                        let symbol: UIImage = .hashTagThin
                        let text = response.name
                        print("텍스트", text , "------------입력됨")
                        cell.setLabel(text: text,
                                      textColor: Colors.Text.secondary,
                                      symbol: symbol,
                                      font: Typography.body ??
                                      UIFont.systemFont(ofSize: 13),
                                      badgeCount: 5)
                    }
                    .disposed(by: self.disposeBag)
                
                return cell
                
            case .directMessage:
                
  
                
                return cell
                
            case .memberManagement:
                
                return cell
            }
            
        })
        
        session.layoutSections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    
    private func configure() {
        view.backgroundColor = Colors.Background.primary
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        
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
