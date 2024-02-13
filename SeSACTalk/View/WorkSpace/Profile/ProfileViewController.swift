//
//  ProfileViewController.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/9/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import PhotosUI


final class ProfileViewController: UIViewController {

    private let profileImage = CustomSpaceImageView()
    private let viewModel = ProfileViewModel()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let tapGesture = UITapGestureRecognizer()
    private let disposeBag = DisposeBag()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
        setProfileImage()
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        profileImage.removeGestureRecognizer(tapGesture)
    }
    
    private func configure() {
        view.backgroundColor = Colors.Background.primary
        view.addSubview(profileImage)
        view.addSubview(tableView)
        navigationController?.setDefaultNavigation(target: self, title: "내 정보 수정")
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = 44
        tableView.isScrollEnabled = false
        tableView.register(ProfileTableCell.self,
                           forCellReuseIdentifier: ProfileTableCell.identifier)
        profileImage.addGestureRecognizer(tapGesture)
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
    
    private func bind() {
        tapGesture.rx.event
            .subscribe(with: self) { owner, _ in
                owner.setupImagePicker()
            }
            .disposed(by: disposeBag)
    }
    
    private func setupImagePicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    private func setProfileImage() {

        guard let profileImgURL = viewModel.makeProfileURL() else {
            profileImage.setImage(image: .dummyTypeA)
            return
        }
        profileImage.setProfileImage(thumbnail: profileImgURL)
    }
}

extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ProfileMenuSelector.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let section = ProfileMenuSelector.allCases[section]
        
        switch section {
        case .accountInfo:
            return AccountInformation.allCases.count
            
        case .systemMenu:
            return SystemMenu.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = ProfileMenuSelector.allCases[indexPath.section]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableCell.identifier) as? ProfileTableCell else { return UITableViewCell() }
        
        switch section {
        case .accountInfo:
            
            let index = AccountInformation.allCases[indexPath.row]
            let data = viewModel.makeProfileData()[indexPath.row]

            switch index {
            case .myCoin :
                
                cell.setTitle(value: data.title)
                cell.setCoinValue(coin: data.value)
                cell.setCellValue(value: "충전하기")

                return cell
            
            default:
                
                cell.setTitle(value: data.title)
                cell.setCellValue(value: data.value)
                
                return cell
            }

        case .systemMenu:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableCell.identifier) as? ProfileTableCell else { return UITableViewCell() }
            
            let index = SystemMenu.allCases[indexPath.row]
            cell.setTitle(value: index.title)
            cell.setCellValue(value: "테스트다")
            
            return cell
        }
    }
}

extension ProfileViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        let downSampledImage = image.downSample(size: CGSize(width: 100, height: 100),
                                                                scale: 1.0)
                        self.profileImage.setImage(image: downSampledImage)
                        self.profileImage.setContentMode(mode: .scaleAspectFill)
                        
                        if let imageData = downSampledImage.jpegData(compressionQuality: 1.0) {
                            self.viewModel.profileImageData.onNext(imageData)
                        }
                    }
                }
            }
        } else {
            print("이미지 지정을 취소했습니다.")
        }
    }
}

