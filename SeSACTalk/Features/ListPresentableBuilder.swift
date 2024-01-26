//
//  ListPresentableBuilder.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/26/24.
//

import Foundation
import UIKit


struct ListPresentableBuilder {
    
    func build(feature: ListingViewControllerProtocol, target: UIViewController) {
        print("빌더 실행됨")
        feature.bind(target: target)
        feature.configure(target: target)
        feature.setConstraints(target: target)
    }
    
}
