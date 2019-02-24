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

let type_column = Expression<Int>("type")
let time_column = Expression<TimeInterval>("time")
let title_column = Expression<String>("title")
let id_column = Expression<String>("id")
let url_column = Expression<String>("url")

class SQLiteDBService: NSObject {
    static let shared = SQLiteDBService()
    private var db: Connection?
    private var table: Table?
    
    private func getDB() -> Connection {
        if db == nil {
            db = try? Connection(AppConfig.databasePath)
            db?.busyTimeout = 5.0
            
            return db!
        }
        return db!
    }
    
    private func getTable() -> Table {
        if table == nil {
            table = Table("history")
            
            _ = try? getDB().run(getTable().create { t in
                t.column(id_column, primaryKey: true)
                t.column(type_column)
                t.column(time_column)
                t.column(title_column)
                t.column(url_column)
            })
           
            return table!
        }
        return table!
    }
    
    /// 增一条历史记录(type: 0话题 1资讯)
    func addHistory(id: String, type: Int, title: String, time: TimeInterval, url: String) {
        // 是否已经浏览
        let history = searchHistory(id: id)
        if history {
            // 更新
            updateHistory(id: id, time: Date().timeIntervalSince1970)
            return
        }
        
        let insert = getTable().insert(type_column <- type, time_column <- time, id_column <- id, title_column <- title, url_column <- url)
        if let rowId = try? getDB().run(insert) {
            DLog(msg: "插入成功：\(rowId)")
        } else {
            DLog(msg: "插入失败")
        }
    }

    /// 删除所有的历史记录
    func deleteHistory() {
        let delete = getTable().delete()

        if let count = try? getDB().run(delete) {
            DLog(msg: "删除的条数为：\(count)")
        } else {
            DLog(msg: "删除失败")
        }
    }

    /// 修改一条历史记录的浏览时间
    func updateHistory(id: String, time: TimeInterval) {
        let update = getTable().filter(id_column == id).update(time_column <- time)
        
        if let count = try? getDB().run(update) {
            DLog(msg: "修改的结果为：\(count == 1)")
        } else {
            DLog(msg: "修改失败")
        }
    }

    /// 查找所有的历史记录
    func searchAllHistory() -> [History] {
        var historys = [History]()
        
        for column in try! getDB().prepare(getTable().order(time_column.desc)) {
            historys.append(History(id: column[id_column], type: column[type_column], title: column[title_column], time: column[time_column], url: column[url_column]))
            
            print("searchHistory id: \(column[id_column]), type: \(column[type_column]), title: \(column[title_column]), time: \(column[time_column]), url: \(column[url_column])")
        }

        return historys
    }
    
    /// 查找一条历史记录
    func searchHistory(id: String) -> Bool {
        let query = getTable().filter(id_column == id)

        if let count = try? getDB().scalar(query.count) {
            return count == 1
        }
        return false
    }
}
