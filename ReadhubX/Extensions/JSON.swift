//
//  JSON.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/18.
//  Copyright © 2019 EJ. All rights reserved.
//

import Foundation

extension String {
    /// json 字符串转 array dictionary
    public func JSONObject() -> Any {
        let data = self.data(using: .utf8)
        
        return try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
    }
}

extension NSArray {
    /// array 转 json 字符串
    public func JSONString() -> String {
        let jsonData = try! JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        
        return String(data: jsonData, encoding: .utf8)!
    }
}

extension NSDictionary {
    /// dictionary 转 json 字符串
    public func JSONString() -> String {
        let jsonData = try! JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        
        return String(data: jsonData, encoding: .utf8)!
    }
}
