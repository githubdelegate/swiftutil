//
//  String+Util.swift
//  cleaner
//
//  Created by zy on 2020/9/4.
//  Copyright © 2020 gramm. All rights reserved.
//

import Foundation
import UIKit

public extension NSAttributedString {
    /// 获取string文字size
    /// - Returns: description
    func getSize() -> CGSize {
        let lable = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        lable.attributedText = self
        lable.sizeToFit()
        return lable.frame.size
    }
}
