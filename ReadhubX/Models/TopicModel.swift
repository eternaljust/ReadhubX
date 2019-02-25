//
//  TopicModel.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/23.
//  Copyright © 2019 EJ. All rights reserved.
//

import Foundation

/// 热门话题列表 model
struct TopicListModel : Codable {
    let data: [TopicModel]
    
    /// 话题 model
    struct TopicModel: Codable {
        /// 话题标题
        var title: String = ""
        /// 话题摘要
        var summary: String = ""
        /// 话题创建时间
        var createdAt: String = ""
        /// 话题 id
        var id: String = ""
        /// 下拉刷新上一页数据最后一个话题的 lastCursor
        var order: Int = 0
    }
}
