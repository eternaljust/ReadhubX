//
//  HistoryModel.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/24.
//  Copyright © 2019 EJ. All rights reserved.
//

import Foundation

/// 浏览历史记录 model
struct HistoryModel: Codable {
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
    /// 资讯新闻语言（zh-cn：中文 en：英文）
    var language: String = AppConfig.cnLanguage
    /// 摘要
    var summary: String = ""
    /// 发布时间
    var publishDate: String = ""
    /// extra 预留额外的扩展字段：json 字符串
    var extra: String = ""
}
