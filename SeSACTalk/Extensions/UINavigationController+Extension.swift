//
//  UINavigationController+Extension.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/9/24.
//

import UIKit



extension UINavigationController {
    
    
    func setStartingAppearance(title: String?, target: UIViewController, action: Selector?) {
        let appearance = UINavigationBarAppearance()
        target.title = title
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
    
    func setWorkSpaceNavigation() {
            let appearance = UINavigationBarAppearance()
            appearance.shadowColor = Colors.Border.naviShadow
            appearance.backgroundColor = .white

            navigationBar.standardAppearance = appearance
            navigationBar.compactAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance

            let leftItem = UIBarButtonItem(customView: CustomNavigationLeftView())
            let rightItem = UIBarButtonItem(customView: CustomNavigationRightView())

            topViewController?.navigationItem.leftBarButtonItem = leftItem
            topViewController?.navigationItem.rightBarButtonItem = rightItem
        }
}
