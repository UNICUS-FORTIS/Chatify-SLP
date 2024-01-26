//
//  ListingViewControllerType.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/26/24.
//

import UIKit

protocol ListingViewControllerProtocol: AnyObject {
    
    func bind(target: UIViewController)
    func configure(target: UIViewController)
    func setConstraints(target: UIViewController)
    func showActionSheet(target: UIViewController, workspace: WorkSpace)
    
}
