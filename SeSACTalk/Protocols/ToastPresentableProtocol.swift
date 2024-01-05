//
//  ToastPresentableProtocol.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/4/24.
//

import UIKit
import Toast


var toastStyle = ToastStyle()

protocol ToastPresentableProtocol: AnyObject {
    
    func makeToastAboveView(message: String, backgroundColor: UIColor, aboveView: UIView)
    
}

extension ToastPresentableProtocol where Self: UIViewController {
    
    func makeToastAboveView(message: String, backgroundColor: UIColor, aboveView: UIView) {
        
        let overlayView = UIView(frame: aboveView.frame)
        overlayView.backgroundColor = UIColor.clear
        self.view.addSubview(overlayView)
        overlayView.snp.makeConstraints { make in
            make.bottom.equalTo(aboveView.snp.top).offset(-36)
            make.centerX.equalToSuperview()
        }
        
        var style = ToastStyle()
        style.backgroundColor = backgroundColor
        
        overlayView.makeToast(message, duration: 2.0, position: .center, style: style)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            overlayView.removeFromSuperview()
        }
    }
}

