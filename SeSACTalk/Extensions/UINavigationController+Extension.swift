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
    
    func setWorkSpaceNavigation(target: UIViewController, action: Selector) {
        
        
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = Colors.Border.naviShadow
        appearance.backgroundColor = .white
        
        var leftCustomView = session.leftCustomView
        let leftTitleView = session.leftCutomTitleButton
        let rightCustomView = session.rightCustomView

        leftTitleView.addTarget(target, action: action, for: .touchUpInside)
        let leftItem = UIBarButtonItem(customView: leftCustomView)
        let leftTitleItem = UIBarButtonItem(customView: leftTitleView)
        let spacer = UIBarButtonItem()
        spacer.width = 8
        let rightItem = UIBarButtonItem(customView: rightCustomView)
        
        topViewController?.navigationItem.leftBarButtonItems = [leftItem, spacer, leftTitleItem]
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
}
