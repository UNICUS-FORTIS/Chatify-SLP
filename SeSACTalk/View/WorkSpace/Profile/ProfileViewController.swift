//
//  ProfileViewController.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/9/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class ProfileViewController: UIViewController {

    private let profileImage = CustomSpaceImageView()
    private let tableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
    }
    
    private func configure() {
        view.backgroundColor = Colors.Background.primary
        view.addSubview(profileImage)
        view.addSubview(tableView)
        navigationController?.setDefaultNavigation()
        
        tableView.backgroundColor = .white
    }
    
    
    private func setConstraints() {
        profileImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(70)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(23)
            make.top.equalTo(profileImage.snp.bottom).offset(35)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

}
