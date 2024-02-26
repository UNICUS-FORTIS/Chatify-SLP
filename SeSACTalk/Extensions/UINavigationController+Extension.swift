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


let session = LoginSession.shared

extension UINavigationController {
    
    
    func setCloseableNavigation(title: String?, target: UIViewController, action: Selector?) {
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
    
    func setWorkSpaceNavigation(target: UIViewController,
                                leftAction: Selector,
                                rightActoin: Selector) {
        
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = Colors.Border.naviShadow
        appearance.backgroundColor = .white
        
        let leftCustomView = session.leftCustomView
        let leftCustomLabel = session.leftCustomLabel
        leftCustomLabel.button.addTarget(target, action: leftAction, for: .touchUpInside)
        
        let rightCustomView = session.rightCustomView
        rightCustomView.button.addTarget(target, action: rightActoin, for: .touchUpInside)
        
        let leftItem = UIBarButtonItem(customView: leftCustomView)
        let leftTitleItem = UIBarButtonItem(customView: leftCustomLabel)
        
        let rightItem = UIBarButtonItem(customView: rightCustomView)
        leftItem.width = 32
        
        topViewController?.navigationItem.leftBarButtonItems = [leftItem, leftTitleItem]
        topViewController?.navigationItem.rightBarButtonItem = rightItem
        
        navigationBar.isUserInteractionEnabled = true
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
    
    func setWorkSpaceListNavigation() {
        
        let appearance = UINavigationBarAppearance()
        navigationBar.clipsToBounds = true
        toolbar.layer.cornerRadius = 25
        appearance.shadowColor = .clear
        appearance.backgroundColor = .white
        let titleLabel = UILabel()
        titleLabel.text = "워크스페이스"
        titleLabel.font = Typography.createTitle1()
        
        let leftItem = UIBarButtonItem(customView: titleLabel)
        topViewController?.navigationItem.leftBarButtonItem = leftItem
        
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
    
    func setChannelChatNavigation(target: UIViewController,
                                  title: String,
                                  rightAction: Selector) {
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = Colors.Border.naviShadow
        appearance.backgroundColor = .white
        target.title = "#\(title)"
        let rightItem = UIBarButtonItem(image: .list,
                                        style: .plain,
                                        target: target,
                                        action: rightAction)
        
        target.navigationItem.rightBarButtonItem = rightItem
        navigationBar.tintColor = .black
        navigationBar.topItem?.backButtonTitle = ""
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
    
    func setDefaultNavigation(target: UIViewController, title: String) {
        let appearance = UINavigationBarAppearance()
        target.title = title
        appearance.shadowColor = Colors.Border.naviShadow
        appearance.backgroundColor = .white
        navigationBar.tintColor = .black
        navigationBar.topItem?.backButtonTitle = ""
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
    
    func setOnboardingNavigation() {
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .clear
        appearance.backgroundColor = Colors.Background.primary
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
}
