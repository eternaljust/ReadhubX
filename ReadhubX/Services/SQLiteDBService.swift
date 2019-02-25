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
    /// 历史记录 extra 预留额外的扩展字段：json 字符串
    private let history_extra_column = Expression<String>("extra")
    
    /// 单例
    static let shared = SQLiteDBService()
    /// 数据库
    private var db: Connection?
    /// 历史记录表
    private var historyTable: Table?
    
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
                t.column(history_extra_column)
            })
           
            return historyTable!
        }
        return historyTable!
    }
    
    // MARK: - public method
    /// 增一条历史记录(type: 0话题 1资讯 extra 预留额外的扩展字段：json 字符串)
    func addHistory(id: String, type: Int, title: String, time: TimeInterval, url: String, language: String, extra: String) {
        // 是否已经浏览
        let history = searchHistory(id: id)
        if history {
            // 更新
            updateHistory(id: id, time: Date().timeIntervalSince1970)
            return
        }
        
        let insert = getHistoryTable().insert(history_type_column <- type, history_time_column <- time, history_id_column <- id, history_title_column <- title, history_url_column <- url, history_language_column <- language, history_extra_column <- extra)
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
            historys.append(HistoryModel(id: column[history_id_column], type: column[history_type_column], title: column[history_title_column], time: column[history_time_column], url: column[history_url_column], language: column[history_language_column], extra: column[history_extra_column]))
            
            DLog(msg: "searchHistory id: \(column[history_id_column]), type: \(column[history_type_column]), title: \(column[history_title_column]), time: \(column[history_time_column]), url: \(column[history_url_column]), language: \(column[history_language_column]), extra: \(column[history_extra_column])")
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
}
