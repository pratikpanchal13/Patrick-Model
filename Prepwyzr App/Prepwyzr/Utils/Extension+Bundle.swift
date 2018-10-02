//
//  Extension+Bundle.swift
//  Demo
//
//  Created by pratik on 23/08/18.
//  Copyright © 2018 Mitul Mandanka. All rights reserved.
//

import Foundation

extension Bundle {
    
    var appName: String {
        return infoDictionary?["CFBundleName"] as! String
    }
    
    var bundleId: String {
        return bundleIdentifier!
    }
    
    var versionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as! String
    }
    
    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as! String
    }
    
}
