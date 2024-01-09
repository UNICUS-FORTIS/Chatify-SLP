//
//  UINavigationController+Extension.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/9/24.
//

import UIKit



extension UINavigationController {
    
    
    func setSignInNavigation(target: UIViewController, action: Selector) {
        print(#function)
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.backgroundColor = .white
        navigationBar.tintColor = .black
        navigationBar.topItem?.backButtonDisplayMode = .generic
        navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: .close,
                                                                   style: .done,
                                                                   target: target,
                                                                   action: action)
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
}
