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
    
    func convertDateString() -> String? {
        let inputFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let outputFormat = "yy. MM. dd"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = outputFormat
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }
    
    func chatDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        guard let date = dateFormatter.date(from: self) else { return "" }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let dateComponents = calendar.dateComponents([.day], from: today, to: date)
        
        if let daysDiff = dateComponents.day {
            if daysDiff == 0 {
                dateFormatter.dateFormat = "a hh:mm"
            } else {
                dateFormatter.dateFormat = "M/dd a hh:mm"
            }
        } else {
            dateFormatter.dateFormat = "M/dd a hh:mm"
        }
        
        return dateFormatter.string(from: date)
    }
}

