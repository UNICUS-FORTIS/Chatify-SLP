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
                                               width: aboveView.frame.width + 30,
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
    
    func makeSuccessToastView(message: String, backgroundColor: UIColor, target: UIViewController) {
        let overlayView = UIView(frame: CGRect(x: 0,
                                               y: 0,
                                               width: UIScreen.main.bounds.width,
                                               height: 50))
        overlayView.backgroundColor = UIColor.clear
        target.view.addSubview(overlayView)
        overlayView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(target.view.safeAreaLayoutGuide)
            make.bottom.equalTo(target.view.safeAreaLayoutGuide)
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

