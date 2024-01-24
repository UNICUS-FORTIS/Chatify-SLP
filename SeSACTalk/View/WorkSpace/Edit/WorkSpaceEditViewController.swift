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

// MARK: - 워크스페이스 생성 바텀시트
final class WorkSpaceEditViewController: UIViewController, ToastPresentableProtocol {
    
    
    private let spaceImage = CustomSpaceImageView()
    private let spaceName = CustomInputView(label: "워크스페이스 이름", placeHolder: "", keyboardType: .default)
    private let spaceDescription = CustomInputView(label: "워크스페이스 설명", placeHolder: "", keyboardType: .default)
    private let createButton = CustomButton(title: "완료")
    private let center = ValidationCenter()
    private let disposeBag = DisposeBag()
    private let tapGesture = UITapGestureRecognizer()
    var viewModel: EmptyWorkSpaceViewModel!
    private let networkService = NetworkService.shared
    private let session = LoginSession.shared
    private var viewTitle: String?
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(viewModel: EmptyWorkSpaceViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setConstraints()
        bind()
        viewModel.bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        spaceImage.removeGestureRecognizer(tapGesture)
    }
    
    private func configure() {
        
        switch viewModel.workspaceEditMode {
        case .create:
            viewTitle = "워크스페이스 생성"
        case .edit:
            viewTitle = "워크스페이스 편집"
            viewModel.workspaceImageMounted.onNext(true)
        }
        navigationController?.setStartingAppearance(title: viewTitle,
                                                    target: self,
                                                    action: #selector(dismissTrigger))
        view.addSubview(spaceImage)
        view.addSubview(spaceName)
        view.addSubview(spaceDescription)
        view.addSubview(createButton)
        view.backgroundColor = Colors.Background.primary
    }
    
    @objc private func dismissTrigger() {
        dismiss(animated: true)
    }
    
    private func bind() {
        print("에딧뷰컨트롤러 bind 실행됨")
        spaceImage.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .subscribe(with: self) { owner, _ in
                owner.setupImagePicker()
            }
            .disposed(by: disposeBag)
        
        viewModel.workspaceInfoForEdit
            .bind(with: self) { owner, workspace in
                guard let safe = workspace else { return }
                owner.spaceName.textField.text = safe.name
                owner.spaceDescription.textField.text = safe.description
                owner.spaceImage.setImageWithThumbnail(thumbnail: safe.thumbnail) { [weak self] image in
                    if let safeImage = image.jpegData(compressionQuality: 1.0) {
                        DispatchQueue.main.async {
                            self?.viewModel.workspaceImage.onNext(safeImage)
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
        
        spaceName.textField.rx.text.orEmpty
            .bind(to: viewModel.workspaceName)
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
            .flatMap { isImageMounted -> Observable<Bool> in
                if !isImageMounted {
                    self.makeToastAboveView(message: ScreenTitles.WorkSpaceInitial.workSpaceImageRestrict,
                                            backgroundColor: Colors.Brand.error,
                                            aboveView: self.createButton)
                }
                return Observable.just(isImageMounted)
            }
            .filter { $0 }
            .withLatestFrom(viewModel.workspaceName)
            .flatMap { name -> Observable<Bool> in
                let nameValidation = self.center.validateWorkspaceName(name)
                print(nameValidation)
                if !nameValidation {
                    self.makeToastAboveView(message: ScreenTitles.WorkSpaceInitial.workSpaceNameRestrict,
                                            backgroundColor: Colors.Brand.error,
                                            aboveView: self.createButton)
                }
                return Observable.just(nameValidation)
            }
            .filter { $0 }
            .withLatestFrom(viewModel.form)
            .flatMapLatest { form -> Observable<Result<NewWorkSpaceResponse, ErrorResponse>> in
                switch self.viewModel.workspaceEditMode {
                case .create:
                    return self.viewModel.fetchCreateWorkSpace(info: form).asObservable()
                case .edit:
                    return self.viewModel.fetchEditWorkSpace(form: form).asObservable()
                }
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(_):
                    owner.session.fetchLoadWorkSpace()
                    owner.dismiss(animated: true)
                case .failure(let error):
                    print(error.errorCode)
                }
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
    
    
    deinit {
        print("워크스페이스 deinit 됨")
    }
    
}

extension WorkSpaceEditViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        let downSampledImage = image.downSample(size: CGSize(width: 100, height: 100),
                                                                scale: 1.0)
                        self.spaceImage.setImage(image: downSampledImage)
                        self.spaceImage.setContentMode(mode: .scaleAspectFill)
                        
                        if let imageData = downSampledImage.jpegData(compressionQuality: 1.0) {
                            self.viewModel.workspaceImage.onNext(imageData)
                            self.viewModel.workspaceImageMounted.onNext(true)
                        }
                    }
                }
            }
        } else {
            print("이미지 지정을 취소했습니다.")
        }
    }
}

