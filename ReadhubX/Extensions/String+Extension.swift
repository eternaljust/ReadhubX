//
//  String+Extension.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/18.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit
import Foundation

extension String {
    /// 字符串转 date
    func date() -> Date? {
        let dateformatter = DateFormatter()
        
        if self.count > 19 {
            let length19: String = String(self.prefix(19))
            
            dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
           return dateformatter.date(from: length19)
        }
        
//        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'.000Z'"
        
        return dateformatter.date(from: self)
    }
    
    /// 详细时间
    func yyyy_MM_dd_HH_mm_ss() -> String {
        let date = self.date()
        let dateformatter = DateFormatter()

        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        return dateformatter.string(from: date ?? Date())
    }
    
    /// 字符串转时间戳
    func timeStamp() -> String {
        let time: TimeInterval = self.date()!.timeIntervalSince1970 * 1000
        
        return "\(time)"
    }
    
    /// 根据时间戳返回几分钟前，几小时前，几天前
    public static func currennTime(timeStamp: TimeInterval, isTopic: Bool) -> String {
        // 获取当前的时间戳
        let currentTime = Date().timeIntervalSince1970
        // readhub 时差 话题（7 小时）资讯（8 小时）
        let hour: Float = isTopic ? 7 : 8
        
        let e: TimeInterval = (TimeInterval(hour * 60 * 60))
        
        // 时间戳为毫秒级
        let timeSta: TimeInterval = timeStamp + e
        // 时间差
        let reduceTime: TimeInterval = currentTime - timeSta
        // 时间差小于60秒
        if reduceTime < 60 {
            return "刚刚"
        }
        // 时间差大于一分钟小于60分钟内
        let mins = Int(reduceTime / 60)
        if mins < 60 {
            return "\(mins)分钟前"
        }
        let hours = Int(reduceTime / 3600)
        if hours < 24 {
            return "\(hours)小时前"
        }
        let days = Int(reduceTime / 3600 / 24)
        if days == 1 {
            return "昨天"
        }
        if days == 2 {
            return "前天"
        }
        
        // 不满足上述条件 直接返回日期
        let date = NSDate(timeIntervalSince1970: timeSta)
        let dateFormat = DateFormatter()
   
        dateFormat.dateFormat = "MM月dd日"
        
        return dateFormat.string(from: date as Date)
    }
    
    /// 浏览历史 根据时间戳返回几分钟前，几小时前，几天前
    public static func historyTime(timeStamp: TimeInterval) -> String {
        // 获取当前的时间戳
        let currentTime = Date().timeIntervalSince1970
        
        // 时间差
        let reduceTime: TimeInterval = currentTime - timeStamp
        // 时间差小于60秒
        if reduceTime < 60 {
            return "刚刚"
        }
        // 时间差大于一分钟小于60分钟内
        let mins = Int(reduceTime / 60)
        if mins < 60 {
            return "\(mins)分钟前"
        }
        let hours = Int(reduceTime / 3600)
        if hours < 24 {
            return "\(hours)小时前"
        }
        let days = Int(reduceTime / 3600 / 24)
        if days == 1 {
            return "昨天"
        }
        if days == 2 {
            return "前天"
        }
        
        // 不满足上述条件 直接返回日期
        let date = NSDate(timeIntervalSince1970: timeStamp)
        let dateFormat = DateFormatter()
        
        dateFormat.dateFormat = "yy-MM-dd HH:mm:ss"
        
        return dateFormat.string(from: date as Date)
    }
}

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
    
    private func isMatch(regEx: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", regEx).evaluate(with: self)
    }
}
