//
//  String+Extension.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/18.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit

extension String {
    /// 是否为手机号
    func isPhone() -> Bool {
        //手机号开头：13 14 15 17 18 @"^1+[34578]+\\d{9}"
        //手机号开头：1 + 10位 @"^1+\\d{10}"
        return isMatch(regEx: "1\\d{10}$")
    }
    
    /// 是否为邮箱
    func isEmial() -> Bool {
        return isMatch(regEx: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}")
    }
    
    /// 是否为只包含字母和数字
    func isAlnum() -> Bool {
        return isMatch(regEx: "^[A-Za-z0-9]+$")
    }
    
    /// 是否为只包含字母
    func isAlpha() -> Bool {
        return isMatch(regEx: "^[A-Za-z]+$")
    }
    
    /// 是否只包含数字
    func isDigit() -> Bool {
        return isMatch(regEx: "^[0-9]+")
    }
    
    /// 是否包含小数点
    func isDecimal() -> Bool {
        return isMatch(regEx: "^[0-9]+(\\.[0-9]{0,2})?$")
    }
    
    public func isMatch(regEx: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", regEx).evaluate(with: self)
    }
}
