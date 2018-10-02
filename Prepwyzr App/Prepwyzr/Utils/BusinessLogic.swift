//
//  BusinessLogic.swift
//  Demo
//
//  Created by pratik on 22/08/18.
//  Copyright © 2018 Mitul Mandanka. All rights reserved.
//

import Foundation

import Foundation
import UIKit

struct BusinessLogic {
    
   
    
    static func displayAmount(_ amount: String) -> String {
        
        let formatter = NumberFormatter()
        //        formatter.locale = Locale(identifier: LLanguage.appleLanguageInShort) // this ensures the right separator behavior
        formatter.numberStyle = .decimal
        //        formatter.usesGroupingSeparator = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.roundingMode = .down
        formatter.minimumIntegerDigits = 1
        
        let amountDouble = (Double(amount) ?? 00)
        let floatString = "\(amountDouble)"
        let amountNumber = NSNumber(value: amountDouble)
        
        if let strAmount = formatter.string(from: amountNumber) {
            return strAmount
        } else {
            return floatString
        }
    }
    static func amount(_ amount: String) -> String {
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.roundingMode = .down
        formatter.minimumIntegerDigits = 1 // If pass value 0 that time show .00 show i will add this line Ex. 0.00
        
        let amountDouble = (Double(amount) ?? 00)
        let floatString = "\(amountDouble)"
        let amountNumber = NSNumber(value: amountDouble)
        
        if let strAmount = formatter.string(from: amountNumber) {
            return strAmount
        } else {
            return floatString
        }
    }
    
    static func convert24HoursTime(time: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        if  let date = dateFormatter.date(from: time) {
            dateFormatter.dateFormat = "HH:mm"
            let Date12 = dateFormatter.string(from: date)
            return Date12
        }
        return nil
    }
    
 }
