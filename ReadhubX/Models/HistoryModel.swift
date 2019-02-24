//
//  HistoryModel.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/24.
//  Copyright © 2019 EJ. All rights reserved.
//

import Foundation

/// 浏览历史记录 model
struct History: Codable {
    /// 话题 id
    var id: String = ""
    /// 历史记录类型：0话题 1资讯
    var type: Int = 0
    /// 记录标题
    var title: String = ""
    /// 浏览时间
    var time: TimeInterval = Date().timeIntervalSince1970
    /// 资讯链接
    var url: String = AppConfig.defaultURL
}
