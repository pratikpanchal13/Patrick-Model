//
//  String+Extension.swift
//  Demo
//
//  Created by pratik on 23/08/18.
//  Copyright © 2018 pratik. All rights reserved.
//


import Foundation
import UIKit

extension String {
    
    var integerValue: Int? {
        //Issue: Int(string) : Not work fine when float string come.
        return NSString(string: self).integerValue
        // code not safe if string so much big then Int(big Double) cases crash
        //        if let double = Double(self){
        //            return Int(double)
        //        }
        //        return nil
        /// On 32-bit platforms, `Int` is the same size as `Int32`, and
        /// on 64-bit platforms, `Int` is the same size as `Int64`.
    }
    var floatValue: Float? {
        return NSString(string: self).floatValue
    }
    var doubleValue: Double? {
        return NSString(string: self).doubleValue//Double(self)
        //Max  (.123456789012345678) =   .1234567890123456
        //Max (0.123456789012345678) =  0.1234567890123456
        //Max(-0.123456789012345678) = -0.123456789012346
        //Max (1.123456789012345678) =  1.12345678901235
        //Max (123456789012345.) =    123456789012345.0
        //Max (123456789012345.0) =   123456789012345.0
        //Max (123456789012345.1) =   123456789012345.0
        //Max (1234567890.12345678) = 1234567890.12346
    }
}

//MARK: Validations
extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    subscript (bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ..< end]
    }
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ... end]
    }
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        return self[start ... end]
    }
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ... end]
    }
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ..< end]
    }
}
extension Substring {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    subscript (bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ..< end]
    }
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ... end]
    }
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        return self[start ... end]
    }
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ... end]
    }
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ..< end]
    }
}

extension String {
    
    var notEmpty: String? {
        if self != "" {
            return self
        }
        return nil
    }
   
    var isCharacterAndNumber:Bool{
        var flag: Bool = false
        let characterSet = CharacterSet.letters
        if self.rangeOfCharacter(from: characterSet.inverted) == nil {
            flag =  true
        }
        if Int(self) != nil{
            flag = true
        }
        let whitespace = NSCharacterSet.whitespaces
        let range = self.rangeOfCharacter(from: whitespace)
        if range != nil {
            flag =  true
        }
        return flag
    }
    var isCharacter:Bool{
        var flag: Bool = false
        let characterSet = CharacterSet.letters
        if self.rangeOfCharacter(from: characterSet.inverted) == nil {
            flag =  true
        }
        let whitespace = NSCharacterSet.whitespaces
        let range = self.rangeOfCharacter(from: whitespace)
        if range != nil {
            flag =  true
        }
        return flag
    }
    
    var isValidLoginPin:Bool {
        print(self)
        var flag: Bool = false
        for (_ , value) in self.enumerated() {
            if(first != value){
                flag = true
                break;
                //                return flag
            }
        }
        if self == "123456"{
            flag = false
            return flag
        }
        
        let MAX_MATCHED_COUNT = 3
        var matched_count = 1
        let length = self.count
        for (index, element) in self.enumerated() {
            if index < length - 1 && element == self[index + 1]{
                matched_count = matched_count + 1
                if matched_count == MAX_MATCHED_COUNT {
                    flag = false
                    return flag
                }
            }else{
                matched_count = 1;
                flag = true
            }
        }
        // Check consecutive sequential incremental number are there or not in STRING
        matched_count = 1
        for (index, element) in self.enumerated() {
            if index < length - 1{
                
                if let tempValue = Int(String(element)),
                    let tempValue1 = Int(String((self[index + 1]))),
                    tempValue + 1 == tempValue1{
                    matched_count = matched_count + 1
                    if matched_count == MAX_MATCHED_COUNT {
                        flag = false
                        return flag
                    }
                }else{
                    matched_count = 1;
                    flag = true
                }
            }
        }
        // Check consecutive sequential decremental number are there or not in STRING
        matched_count = 1
        for (index, element) in self.enumerated() {
            if index < length - 1{
                
                if let tempValue = Int(String(element)),
                    let tempValue1 = Int(String((self[index + 1]))),
                    tempValue - 1 == tempValue1{
                    matched_count = matched_count + 1
                    if matched_count == MAX_MATCHED_COUNT {
                        flag = false
                        return flag
                    }
                }else{
                    matched_count = 1;
                    flag = true
                }
            }
        }
        
        return flag
    }
    
}

extension String {
    
    var trimWhiteSpaceAndNewlines: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func date(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
    
    func removeFirstOccurrences(of target: String) -> String? {
        
        var animal = self
        if let range = animal.range(of: target) {
            animal = animal.replacingCharacters(in: range, with: "")
            return animal
        }
        return nil
    }
    func removeFirstOccurrencesWithCurrentString(of target: String) -> String {
        
        var animal = self
        if let range = animal.range(of: target) {
            animal = animal.replacingCharacters(in: range, with: "")
            return animal
        }
        return animal
    }
    func trimLeadingZeroes(input: String) -> String {
        var result = ""
        for character in input {
            if result.isEmpty && character == "0" { continue }
            result.append(character)
        }
        return result
    }
    func mutableAttributedString(font: UIFont, textColor: UIColor, underlines:Any? = nil) -> NSMutableAttributedString {
        var attributes: [NSAttributedStringKey : Any] = [.foregroundColor: textColor, .font: font]
        if let underlines = underlines {
            attributes[.underlineStyle] = underlines
        }
        return NSMutableAttributedString(string: self, attributes: attributes)
    }
    func attributedString(font: UIFont, textColor: UIColor, underlines:Any? = nil) -> NSAttributedString {
        var attributes: [NSAttributedStringKey : Any] = [.foregroundColor: textColor, .font: font]
        if let underlines = underlines {
            attributes[.underlineStyle] = underlines
        }
        return NSAttributedString(string: self, attributes: attributes)
    }
    mutating func hideStringWithStar(sufixCount:Int) -> String{
        //https://stackoverflow.com/questions/12083605/formatting-a-uitextfield-for-credit-card-input-like-xxxx-xxxx-xxxx-xxxx
        var formatedCardNumber = ""
        var i :Int = 0
        //loop for every character
        for character in self{
            //in case you want to replace some digits in the middle with * for security
            if(i < self.count - sufixCount || i >= self.count - 0){
                formatedCardNumber = formatedCardNumber + "*"
            }else{
                formatedCardNumber = formatedCardNumber + String(character)
            }
            //insert separators every 4 spaces(magic number)
            if(i == 3 || i == 7 || i == 11 || (i == 15 && self.count > 16 )){
                formatedCardNumber = formatedCardNumber + " "
                // could use just " " for spaces
            }
            
            i = i + 1
        }
        return formatedCardNumber
    }
    
    mutating func hideMobileStringWithStar(sufixCount:Int) -> String{
        
        var hiddenDebitCardNumber = ""
        let offset = self.count - sufixCount
        
        let start = self.startIndex
        let end = self.index(self.startIndex, offsetBy: offset)
        for _ in 0..<offset {
            hiddenDebitCardNumber.append("*")
        }
        self.replaceSubrange(start..<end, with: hiddenDebitCardNumber)
        
        return self
    }
}

extension NSString {
    
    var toBool:Bool? {
        switch self {
        case "True", "true", "yes", "Yes", "1":
            return true
        case "False", "false", "no", "No", "0":
            return false
        default:
            return nil
        }
    }
    var htmlAttributedString: NSAttributedString? {
        return try? NSAttributedString(data: self.data(using: String.Encoding.unicode.rawValue, allowLossyConversion: true)!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return boundingBox.height
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return boundingBox.width
    }
}
