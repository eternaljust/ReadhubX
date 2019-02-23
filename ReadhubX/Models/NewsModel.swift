//
//  NewsModel.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/19.
//  Copyright © 2019 EJ. All rights reserved.
//

import Foundation

/// 新闻资讯动态列表 model
struct NewsList : Codable {
    let data: [News]
    
    /// 资讯详细 model
    struct News: Codable {
        /// 资讯标题
        var title: String = ""
        /// 资讯摘要
        var summary: String = ""
        /// 资讯来源
        var siteName: String = ""
        /// 资讯来源作者
        var authorName: String = ""
        /// 资讯发布时间
        var publishDate: String = ""
        /// 资讯手机端链接
        var mobileUrl: String = AppConfig.defaultURL
        /// 资讯新闻语言（zh-cn：中文 en：英文）
        var language: String = AppConfig.cnLanguage
    }
}
