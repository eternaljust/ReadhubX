//
//  CollectionModel.swift
//  ReadhubX
//
//  Created by Awro on 2019/3/5.
//  Copyright © 2019 EJ. All rights reserved.
//

import Foundation

/// 话题收藏 model
struct CollectionModel: Codable {
    /// 话题 id
    var id: String = ""
    /// 话题标题
    var title: String = ""
    /// 话题添加时间
    var time: TimeInterval = Date().timeIntervalSince1970
    /// extra 预留额外的扩展字段：json 字符串
    var extra: String = ""
}
