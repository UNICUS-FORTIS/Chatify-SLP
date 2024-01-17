//
//  UINavigationController+Extension.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/9/24.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher



extension UINavigationController {
    
    
    func setStartingAppearance(title: String?, target: UIViewController, action: Selector?) {
        let appearance = UINavigationBarAppearance()
        target.title = title
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.backgroundColor = .white
        navigationBar.tintColor = .black
        navigationBar.topItem?.backButtonTitle = ""
        navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: .close,
                                                                   style: .done,
                                                                   target: target,
                                                                   action: action)
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
    
    func setWorkSpaceNavigation() {

        let session = LoginSession.shared

        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = Colors.Border.naviShadow
        appearance.backgroundColor = .white
        
        let leftCustomView = session.leftCustomView
        let rightCustomView = session.rightCustomView

        let leftItem = UIBarButtonItem(customView: leftCustomView)
        let rightItem = UIBarButtonItem(customView: rightCustomView)
        
        topViewController?.navigationItem.leftBarButtonItem = leftItem
        topViewController?.navigationItem.rightBarButtonItem = rightItem
        
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
}
