//
//  NewWorkSpaceViewController.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/12/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import PhotosUI


final class EmptyWorkSpaceEditViewController: UIViewController, ToastPresentableProtocol {
    
    
    private let spaceImage = CustomSpaceImageView()
    private let spaceName = CustomInputView(label: "워크스페이스 이름", placeHolder: "", keyboardType: .default)
    private let spaceDescription = CustomInputView(label: "워크스페이스 설명", placeHolder: "", keyboardType: .default)
    private let createButton = CustomButton(title: "완료")
    private var center = ValidationCenter()
    private let viewModel = EmptyWorkSpaceViewModel()
    private let disposeBag = DisposeBag()
    private let tapGesture = UITapGestureRecognizer()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setConstraints()
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        spaceImage.removeGestureRecognizer(tapGesture)
    }
    
    private func configure() {
        navigationController?.setStartingAppearance(title: "워크스페이스 생성",
                                                    target: self,
                                                    action: nil)
        view.addSubview(spaceImage)
        view.addSubview(spaceName)
        view.addSubview(spaceDescription)
        view.addSubview(createButton)
        view.backgroundColor = Colors.Background.primary
    }
    
    @objc private func imageTapped() {
        print("터치됨")
    }
    
    private func setupImagePicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    private func bind() {
        spaceImage.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .subscribe(with: self) { owner, _ in
                owner.setupImagePicker()
            }
            .disposed(by: disposeBag)
        
        spaceName.textField.rx.text.orEmpty
            .bind(to: viewModel.workspace)
            .disposed(by: disposeBag)
        
        spaceDescription.textField.rx.text.orEmpty
            .bind(to: viewModel.spaceDescription)
            .disposed(by: disposeBag)
        
        spaceName.textField.rx.text.orEmpty
            .asDriver()
            .drive { [weak self] text in
                let isValid = text.count > 0
                self?.createButton.validationBinder.onNext(isValid)
                self?.createButton.buttonEnabler.onNext(isValid)
            }
            .disposed(by: disposeBag)
        
        createButton.rx.tap
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(viewModel.workspaceImageMounted)
            .flatMapLatest { validation -> Observable<Bool> in
                if validation {
                    return Observable.just(validation)
                } else {
                    self.makeToastAboveView(message: ScreenTitles.WorkSpaceInitial.workSpaceImageRestrict,
                                            backgroundColor: Colors.Brand.error,
                                            aboveView: self.createButton)
                    return Observable.just(false)
                }
            }
            .filter { $0 }
            .withLatestFrom(viewModel.workspace)
            .subscribe(with: self) { owner, spaceName in
                let validation = owner.center.checkWorkspaceName(spaceName)
                if validation {
                    print("전부 유효함")
                } else {
                    owner.makeToastAboveView(message: ScreenTitles.WorkSpaceInitial.workSpaceNameRestrict,
                                             backgroundColor: Colors.Brand.error,
                                             aboveView: owner.createButton)
                }
            }
            .disposed(by: disposeBag)
        
        
        
    }
    
    private func setConstraints() {
        spaceImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.size.equalTo(70)
            make.centerX.equalToSuperview()
        }
        
        spaceName.snp.makeConstraints { make in
            make.top.equalTo(spaceImage.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(76)
            make.centerX.equalToSuperview()
        }
        
        spaceDescription.snp.makeConstraints { make in
            make.top.equalTo(spaceName.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(76)
            make.centerX.equalToSuperview()
        }
        
        createButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-45)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.spaceName.textField.resignFirstResponder()
        self.spaceDescription.textField.resignFirstResponder()
    }
    
}

extension EmptyWorkSpaceEditViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results:
                [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        if let imageData = image.jpegData(compressionQuality: 0.5) {
                            self.spaceImage.setImage(image: image)
                            self.spaceImage.setContentMode(mode: .scaleAspectFill)
                            self.viewModel.workspaceImage.onNext(imageData)
                            self.viewModel.workspaceImageMounted.onNext(true)
                        }
                    }
                }
            }
        } else {
            print("이미지 못 불러왔음!!!!")
        }
    }
}

