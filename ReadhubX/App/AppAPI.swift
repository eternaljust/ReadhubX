//
//  AppAPI.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/18.
//  Copyright © 2019 EJ. All rights reserved.
//

import Foundation

// Readhub 官方的 api 接口整理来源于：https://github.com/bihe0832/readhub-android

/// base url: "https://api.readhub.cn/"
let api_base: String = "https://api.readhub.cn/"

/// 热门话题列表 参数：lastCursor：上一页数据最后一个话题的 order，首次传空 pageSize：一次请求拉取的话题数目（https://api.readhub.cn/topic?pageSize=1&lastCursor= || https://api.readhub.cn/topic?pageSize=10&lastCursor=39311）
let api_topic: String = "topic"
/// 话题详情 参数：话题id （https://api.readhub.cn/topic/4djhWVo81n9）
let api_topic_detail: String = "topic/"
/// 科技动态 参数：lastCursor：上一次访问的最后一条资讯的 PublishDate 对应的毫秒时间戳 pageSize：一次请求拉取的数目 （https://api.readhub.cn/news?pageSize=1&lastCursor= || https://api.readhub.cn/news?pageSize=1&lastCursor=1519477905000）
let api_news: String = "news"
/// 开发者资讯 参数：lastCursor：上一次访问的最后一条资讯的 PublishDate 对应的毫秒时间戳 pageSize：一次请求拉取的数目 （https://api.readhub.cn/technews?pageSize=1&lastCursor= || https://api.readhub.cn/technews?pageSize=1&lastCursor=1519477905000）
let api_technews: String = "technews"
/// 区块链资讯 参数：lastCursor：上一次访问的最后一条资讯的 PublishDate 对应的毫秒时间戳 pageSize：一次请求拉取的数目 （https://api.readhub.cn/blockchain?pageSize=1&lastCursor= || https://api.readhub.cn/blockchain?pageSize=1&lastCursor=1519477905000）
let api_blockchain: String = "blockchain"
/// 默认参数拼接 "pageSize=20&lastCursor="
let api_arg: String = "?pageSize=20&lastCursor="
