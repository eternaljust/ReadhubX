//
//  URLSchemesViewController.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/21.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit
import PKHUD

/// URL Schemes ViewController
class URLSchemesViewController: UIViewController {
    /// 列表 item
    struct URLSchemesItem {
        /// 标题
        var title: String
        /// 链接
        var url: String
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllerConfig()
        self.navigationItem.title = "URL Schemes"
        
        setupUI()
        layoutPageSubviews()
    }
    
    // MARK: - private method
    private func setupUI() {
        view.addSubview(tableView)
    }
    
    private func layoutPageSubviews() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - setter getter
    /// 列表视图
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .grouped)
        
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 60
        
        return tableView
    }()
    
    /// 列表数据源
    private var dataSource: [URLSchemesItem] = {
        return [
            URLSchemesItem(title: "打开热门话题", url: "readhubx://topic"),
            URLSchemesItem(title: "打开资讯列表", url: "readhubx://news")
        ]
    }()
}

// MARK: - UITableViewDataSource
extension URLSchemesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        let item = dataSource[indexPath.row]
        
        cell?.textLabel?.text = item.title
        cell?.detailTextLabel?.text = item.url
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "点击复制"
    }
}

// MARK: - UITableViewDelegate
extension URLSchemesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSource[indexPath.row]
        
        UIPasteboard.general.string = item.url
        
        HUD.flash(.labeledSuccess(title: "复制成功", subtitle: item.url), delay: 1)
    }
}
