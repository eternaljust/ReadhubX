//
//  NewsModel.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/19.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit

struct NewsList : Codable {
    let data: [News]
    
    struct News: Codable {
        /// 资讯标题
        var title: String
        /// 资讯内容
        var summary: String
        /// 资讯来源
        var siteName: String
        /// 资讯来源作者
        var authorName: String = ""
        /// 资讯发布时间
        var publishDate: String = ""
        /// 资讯手机端链接
        var mobileUrl: String = ""
    }
}
