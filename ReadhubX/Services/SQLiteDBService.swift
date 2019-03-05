//
//  SQLiteDBService.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/24.
//  Copyright © 2019 EJ. All rights reserved.
//

import Foundation
import UIKit
import SQLite

/// 数据库缓存服务
class SQLiteDBService: NSObject {
    /// 历史记录类型
    private let history_type_column = Expression<Int>("type")
    /// 历史记录时间戳
    private let history_time_column = Expression<TimeInterval>("time")
    /// 历史记录标题
    private let history_title_column = Expression<String>("title")
    /// 历史记录 id
    private let history_id_column = Expression<String>("id")
    /// 历史记录资讯链接
    private let history_url_column = Expression<String>("url")
    /// 历史记录资讯新闻语言（zh-cn：中文 en：英文）
    private let history_language_column = Expression<String>("language")
    /// 历史记录摘要
    private let history_summary_column = Expression<String>("summary")
    /// 历史记录发布时间
    private let history_publishDate_column = Expression<String>("publishDate")
    /// 历史记录 extra 预留额外的扩展字段：json 字符串
    private let history_extra_column = Expression<String>("extra")
    
    /// 话题收藏时间戳
    private let collection_time_column = Expression<TimeInterval>("time")
    /// 话题收藏标题
    private let collection_title_column = Expression<String>("title")
    /// 话题收藏 id
    private let collection_id_column = Expression<String>("id")
    /// 话题收藏 extra 预留额外的扩展字段：json 字符串
    private let collection_extra_column = Expression<String>("extra")
    
    /// 单例
    static let shared = SQLiteDBService()
    /// 数据库
    private var db: Connection?
    /// 历史记录表
    private var historyTable: Table?
    /// 话题收藏表
    private var collectionTable: Table?
    
    // MARK: - private method
    /// 当前数据库
    private func getDB() -> Connection {
        if db == nil {
            db = try? Connection(AppConfig.databasePath)
            db?.busyTimeout = 5.0
            
            return db!
        }
        return db!
    }
    
    /// 历史记录表
    private func getHistoryTable() -> Table {
        if historyTable == nil {
            historyTable = Table("history")
            
            _ = try? getDB().run(getHistoryTable().create { t in
                t.column(history_id_column, primaryKey: true)
                t.column(history_type_column)
                t.column(history_time_column)
                t.column(history_title_column)
                t.column(history_url_column)
                t.column(history_language_column)
                t.column(history_summary_column)
                t.column(history_publishDate_column)
                t.column(history_extra_column)
            })
           
            return historyTable!
        }
        return historyTable!
    }
    
    /// 收藏话题表
    private func getCollectionTable() -> Table {
        if collectionTable == nil {
            collectionTable = Table("collection")
            
            _ = try? getDB().run(getCollectionTable().create { t in
                t.column(collection_id_column, primaryKey: true)
                t.column(collection_time_column)
                t.column(collection_title_column)
                t.column(collection_extra_column)
            })
            
            return collectionTable!
        }
        return collectionTable!
    }
    
    // MARK: - public method
    /// 增一条历史记录(type: 0话题 1资讯 extra 预留额外的扩展字段：json 字符串)
    func addHistory(id: String, type: Int, title: String, time: TimeInterval, url: String, language: String, summary: String, publishDate: String, extra: String) {
        // 是否已经浏览
        let history = searchHistory(id: id)
        if history {
            // 更新
            updateHistory(id: id, time: Date().timeIntervalSince1970)
            return
        }
        
        let insert = getHistoryTable().insert(history_type_column <- type, history_time_column <- time, history_id_column <- id, history_title_column <- title, history_url_column <- url, history_language_column <- language, history_summary_column <- summary, history_publishDate_column <- publishDate, history_extra_column <- extra)
        if let rowId = try? getDB().run(insert) {
            DLog(msg: "插入成功：\(rowId)")
        } else {
            DLog(msg: "插入失败")
        }
    }

    /// 删除所有的历史记录
    func deleteHistory() {
        let delete = getHistoryTable().delete()

        if let count = try? getDB().run(delete) {
            DLog(msg: "删除的条数为：\(count)")
        } else {
            DLog(msg: "删除失败")
        }
    }

    /// 修改一条历史记录的浏览时间
    func updateHistory(id: String, time: TimeInterval) {
        let update = getHistoryTable().filter(history_id_column == id).update(history_time_column <- time)
        
        if let count = try? getDB().run(update) {
            DLog(msg: "修改的结果为：\(count == 1)")
        } else {
            DLog(msg: "修改失败")
        }
    }

    /// 查找所有的历史记录
    func searchAllHistory() -> [HistoryModel] {
        var historys = [HistoryModel]()
        
        for column in try! getDB().prepare(getHistoryTable().order(history_time_column.desc)) {
            historys.append(HistoryModel(id: column[history_id_column], type: column[history_type_column], title: column[history_title_column], time: column[history_time_column], url: column[history_url_column], language: column[history_language_column], summary: column[history_summary_column], publishDate: column[history_publishDate_column], extra: column[history_extra_column]))
            
            DLog(msg: "searchHistory id: \(column[history_id_column]), type: \(column[history_type_column]), title: \(column[history_title_column]), time: \(column[history_time_column]), url: \(column[history_url_column]), language: \(column[history_language_column]), summary: \(column[history_summary_column]), publishDate: \(column[history_publishDate_column]), extra: \(column[history_extra_column])")
        }

        return historys
    }
    
    /// 查找一条历史记录
    func searchHistory(id: String) -> Bool {
        let query = getHistoryTable().filter(history_id_column == id)

        if let count = try? getDB().scalar(query.count) {
            return count == 1
        }
        return false
    }
    
    /// 增一条话题收藏记录(extra 预留额外的扩展字段：json 字符串)
    func addCollection(id: String, title: String, time: TimeInterval, extra: String) -> Bool  {
        // 是否已经收藏
        if searchCollection(id: id) {
            return false
        }
        
        let insert = getCollectionTable().insert(collection_time_column <- time, collection_id_column <- id, collection_title_column <- title, collection_extra_column <- extra)
        if let rowId = try? getDB().run(insert) {
            DLog(msg: "插入成功：\(rowId)")
            return true
        } else {
            DLog(msg: "插入失败")
            return false
        }
    }
    
    /// 删除一条话题收藏
    func deleteCollection(id: String) -> Bool {
        let delete = getCollectionTable().filter(collection_id_column == id).delete()
        
        if let count = try? getDB().run(delete) {
            DLog(msg: "删除的条数为：\(count)")
            return true
        } else {
            DLog(msg: "删除失败")
            return false
        }
    }
    
    /// 查找所有的话题收藏
    func searchAllCollection() -> [CollectionModel] {
        var collections = [CollectionModel]()
        
        for column in try! getDB().prepare(getCollectionTable().order(collection_time_column.desc)) {
            collections.append(CollectionModel(id: column[collection_id_column], title: column[collection_title_column], time: column[collection_time_column], extra: column[collection_extra_column]))
            
            DLog(msg: "searchAllCollection id: \(column[collection_id_column]), title: \(column[collection_title_column]), time: \(column[collection_time_column]), extra: \(column[collection_extra_column])")
        }
        
        return collections
    }
    
    /// 查找一条话题收藏
    func searchCollection(id: String) -> Bool {
        let query = getCollectionTable().filter(collection_id_column == id)
        
        if let count = try? getDB().scalar(query.count) {
            return count == 1
        }
        return false
    }
}
