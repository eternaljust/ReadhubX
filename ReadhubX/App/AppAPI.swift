//
//  AppAPI.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/18.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit

/// base url: "https://api.readhub.cn/"
let api_base = "https://api.readhub.cn/"

/// 热门话题列表 参数：lastCursor：上一页数据最后一个话题的order，首次传空 pageSize：一次请求拉取的话题数目（https://api.readhub.cn/topic?pageSize=1&lastCursor= || https://api.readhub.cn/topic?pageSize=10&lastCursor=39311）
let api_topic = "topic?"
/// 话题详情 参数：话题id （https://api.readhub.cn/topic/4djhWVo81n9）
let api_topic_detail = "topic/"
/// 科技动态 参数：lastCursor：上一次访问的最后一条资讯的PublishDate对应的毫秒时间戳 pageSize：一次请求拉取的数目 （https://api.readhub.cn/news?pageSize=1&lastCursor= || https://api.readhub.cn/news?pageSize=1&lastCursor=1519477905000）
let api_news = "news?"
/// 开发者资讯 参数：lastCursor：上一次访问的最后一条资讯的PublishDate对应的毫秒时间戳 pageSize：一次请求拉取的数目 （https://api.readhub.cn/technews?pageSize=1&lastCursor= || https://api.readhub.cn/technews?pageSize=1&lastCursor=1519477905000）
let api_technews = "technews?"
/// 区块链资讯 参数：lastCursor：上一次访问的最后一条资讯的PublishDate对应的毫秒时间戳 pageSize：一次请求拉取的数目 （https://api.readhub.cn/blockchain?pageSize=1&lastCursor= || https://api.readhub.cn/blockchain?pageSize=1&lastCursor=1519477905000）
let api_blockchain = "blockchain?"
/// 默认参数拼接 "pageSize=20&lastCursor="
let api_arg = "?pageSize=20&lastCursor="
