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
    
    func setWorkSpaceNavigation(target: UIViewController, action: Selector) {
        
        
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = Colors.Border.naviShadow
        appearance.backgroundColor = .white
        
        let leftCustomView = session.leftCustomView
        let leftCustomLabel = session.leftCustomLabel
        leftCustomLabel.button.addTarget(target, action: action, for: .touchUpInside)
        
        let rightCustomView = session.rightCustomView
        
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
        appearance.backgroundColor = Colors.Border.naviShadow
        let titleLabel = UILabel()
        titleLabel.text = "워크스페이스"
        titleLabel.font = Typography.title1 ?? UIFont.systemFont(ofSize: 22)
        
        let leftItem = UIBarButtonItem(customView: titleLabel)
        topViewController?.navigationItem.leftBarButtonItem = leftItem
        
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
    
    func setChannelChatNavigation(target: UIViewController,
                                  leftAction: Selector,
                                  rightAction: Selector) {
        
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = Colors.Border.naviShadow
        appearance.backgroundColor = .white
        let leftItem = UIBarButtonItem(image: .chevronLeft,
                                       style: .plain,
                                       target: target,
                                       action: leftAction)
        let rightItem = UIBarButtonItem(image: .list,
                                        style: .plain,
                                        target: target,
                                        action: rightAction)
        topViewController?.navigationItem.leftBarButtonItem = leftItem
        topViewController?.navigationItem.rightBarButtonItem = rightItem
        
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
}
