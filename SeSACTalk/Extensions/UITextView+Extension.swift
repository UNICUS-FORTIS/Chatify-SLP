//
//  UITextView+Extension.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/5/24.
//

import UIKit


extension UITextView {
    var numberOfLines: Int {
        guard let font = self.font else {
            return 0
        }
        
        let text = self.text ?? ""
        let boundingSize = CGSize(width: self.bounds.width,
                                  height: .greatestFiniteMagnitude)
        
        let boundingRect = text.boundingRect(with: boundingSize,
                                             options: .usesLineFragmentOrigin,
                                             attributes: [NSAttributedString.Key.font: font],
                                             context: nil)
        
        let numberOfLines = Int(boundingRect.height / font.lineHeight)
        
        return numberOfLines
    }
}


