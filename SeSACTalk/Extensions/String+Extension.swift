//
//  String+Extension.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/6/24.
//

import UIKit



extension String {
    
    var decimalFilteredString: String {
        return String(unicodeScalars.filter(CharacterSet.decimalDigits.contains))
    }
    
    func formated(by patternString: String) -> String {
        let digit: Character = "#"
        
        let pattern: [Character] = Array(patternString)
        let input: [Character] = Array(self.decimalFilteredString)
        var formatted: [Character] = []
        
        var patternIndex = 0
        var inputIndex = 0
        
        while inputIndex < input.count {
            let inputCharacter = input[inputIndex]
            
            guard patternIndex < pattern.count else { break }
            
            switch pattern[patternIndex] == digit {
                
            case true:
                formatted.append(inputCharacter)
                inputIndex += 1
                
            case false:
                formatted.append(pattern[patternIndex])
            }
            
            patternIndex += 1
        }
        return String(formatted)
    }
    
    func greenColored() -> NSAttributedString {
        let pattern = "또는 (.+?) 하기"
        
        let attributedString = NSMutableAttributedString(string: self)
        
        if let match = self.range(of: pattern, options: .regularExpression) {
            let nsRange = NSRange(match, in: self)
            if nsRange.location != NSNotFound, let swiftRange = Range(nsRange, in: self) {
                let range = NSRange(swiftRange, in: self)
                attributedString.addAttribute(.foregroundColor, value: Colors.Brand.green, range: range)
                
                let blackRange = NSRange(location: 0, length: 2)
                attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: blackRange)
                
                return attributedString
            }
        }
        
        return NSAttributedString(string: self)
    }
}
