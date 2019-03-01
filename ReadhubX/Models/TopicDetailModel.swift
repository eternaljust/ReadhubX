//
//  TopicDetailModel.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/23.
//  Copyright © 2019 EJ. All rights reserved.
//

import Foundation

/// 话题详情 model
struct TopicDetailModel: Codable {
    /// 话题标题
    var title: String = ""
    /// 话题摘要
    var summary: String = ""
    /// 话题创建时间
    var createdAt: String = ""
    /// 即时查看
    var hasInstantView: Bool = false
    
    /// 媒体报道
    var newsArray: [TopicDetailNewsModel]
    
    /// 事件追踪
    var timeline: TopicDetailTimelineModel?
    
    /// 媒体报道资讯
    struct TopicDetailNewsModel: Codable {
        /// 资讯 id
        var id: String = ""
        /// 资讯标题
        var title: String = ""
        /// 资讯来源
        var siteName: String = ""
        /// 资讯手机端链接
        var mobileUrl: String = AppConfig.defaultURL
        /// 资讯新闻语言（zh-cn：中文 en：英文）
        var language: String = AppConfig.cnLanguage
        /// 资讯发布时间
        var publishDate: String = ""
    }
    
    /// 相关事件
    struct TopicDetailTimelineModel: Codable {
        /// 话题列表
        var topics: [TopicDetailTimelineTopicModel]
    }
    
    /// 相关事件的话题
    struct TopicDetailTimelineTopicModel: Codable {
        /// 话题标题
        var title: String = ""
        /// 话题创建时间
        var createdAt: String = ""
        /// 话题 id
        var id: String = ""
    }
}

/// 话题的即时查看
struct TopicInstantviewModel: Codable {
    /// 即时查看网页的标题
    var title: String = ""
    /// 即时查看网页的访问源网址
    var url: String = ""
    /// 即时查看网页的来源
    var siteName: String = ""
    /// 即时查看网页的 html 内容
    var content: String = ""
}
