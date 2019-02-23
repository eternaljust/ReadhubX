//
//  TopicDetailModel.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/23.
//  Copyright © 2019 EJ. All rights reserved.
//

import Foundation

/// 话题详情 model
struct TopicDetail: Codable {
    /// 话题标题
    var title: String = ""
    /// 话题摘要
    var summary: String = ""
    /// 话题创建时间
    var createdAt: String = ""
    
    /// 媒体报道
    var newsArray: [TopicDetailNews]
    
    /// 事件追踪
    var timeline: TopicDetailTimeline?
    
    /// 媒体报道资讯
    struct TopicDetailNews: Codable {
        /// 资讯标题
        var title: String = ""
        /// 资讯来源
        var siteName: String = ""
        /// 资讯手机端链接
        var mobileUrl: String = AppConfig.defaultURL
    }
    
    /// 相关事件
    struct TopicDetailTimeline: Codable {
        /// 话题列表
        var topics: [TopicDetailTimelineTopic]
    }
    
    /// 相关事件的话题
    struct TopicDetailTimelineTopic: Codable {
        /// 话题标题
        var title: String = ""
        /// 话题创建时间
        var createdAt: String = ""
        /// 话题 id
        var id: String = ""
    }
}
