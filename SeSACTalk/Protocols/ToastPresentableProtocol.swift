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
        
        let overlayView = UIView(frame: CGRect(x: 0,
                                               y: 0,
                                               width: aboveView.frame.width,
                                               height: aboveView.frame.height + 30))
        overlayView.backgroundColor = UIColor.clear
        self.view.addSubview(overlayView)
        overlayView.snp.makeConstraints { make in
            make.bottom.equalTo(aboveView.snp.top).offset(-42)
            make.centerX.equalToSuperview()
            make.width.equalTo(aboveView)
        }
        
        var style = ToastStyle()
        style.backgroundColor = backgroundColor
        style.messageNumberOfLines = 0
        
        overlayView.makeToast(message, duration: 2.0, position: .center, style: style)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            overlayView.removeFromSuperview()
        }
    }
}

