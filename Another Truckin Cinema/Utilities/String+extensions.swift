//
//  String+extensions.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 9/3/23.
//

import Foundation

extension String {
    var containsSpecialCharacter: Bool {
        let regex = ".*[^A-Za-z0-9].*"
        let testString = NSPredicate(format: "SELF MATCHES %@", regex)
        return testString.evaluate(with: self)
    }
    
    var containsUpperCase: Bool {
        var result = false
        for char in self.unicodeScalars {
            if NSCharacterSet.uppercaseLetters.contains(char) {
                result = true
            }
        }
        return result
    }
    
    var containsLowerCase: Bool {
        var result = false
        for char in self.unicodeScalars {
            if NSCharacterSet.lowercaseLetters.contains(char) {
                result = true
            }
        }
        return result
    }
    
    func isValidEmailAddress() -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = self as NSString
            let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    func convertToDisplayDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: self)

        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "MMM d, yyyy"
        guard let date = date else { return self }
        let displayDate = displayFormatter.string(from: date)
        return "Released \(displayDate)"
    }
    
    func convertToNavBarDisplayDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let date = dateFormatter.date(from: self) ?? Date()
        
        dateFormatter.dateFormat = "EEE, MMM d"
        let resultString = dateFormatter.string(from: date)
        print(resultString)
        
        dateFormatter.dateStyle = .medium
        
        return resultString
    }
}
