//
//  UIDeviceUtil.swift
//  cleaner
//
//  Created by zy on 2020/8/25.
//  Copyright © 2020 gramm. All rights reserved.
//

import Foundation
import UIKit

public enum LocalLanguage {
    case en,cn
}

public extension UIDevice {
    /// 判断当前设备的语言， 只支持 中文和英文
    /// - Returns: description
    func getLanguageType() -> LocalLanguage {
        let def = UserDefaults.standard
        let allLanguages: [String] = def.object(forKey: "AppleLanguages") as! [String]
        let chooseLanguage = allLanguages.first
        
        guard chooseLanguage != nil  else {
            return .en
        }
        
        if chooseLanguage!.hasPrefix("en") {
            return .en
        } else {
            return .cn
        }
    }
}
