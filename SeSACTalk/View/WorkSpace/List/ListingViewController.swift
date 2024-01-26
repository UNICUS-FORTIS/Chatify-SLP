//
//  WorkSpaceViewController.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/19/24.
//

import UIKit


final class ListingViewController: UIViewController {
    
    private var featureType: ListingViewControllerProtocol!
    private lazy var builder = ListPresentableBuilder()

    init(feature: ListingViewControllerProtocol) {
        self.featureType = feature
        super.init(nibName: nil, bundle: nil)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(navigationController)
    }
    
    private func configure() {
        guard let safeFeature = featureType else { return }
        builder.build(feature: safeFeature, target: self)
    }
}


