//
//  NewsDetailViewController.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/28.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit
import WebKit
import PKHUD

/// 资讯详情 ViewController
class NewsDetailViewController: UIViewController {
    /// 资讯详情 标题
    var newsTitle: String?
    /// 资讯摘要
    var newsSummary: String?
    /// 资讯发布时间
    var newsPublishDate: String?
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllerConfig()
        view.backgroundColor = color_ffffff
        navigationItem.title = "资讯详情"

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
        let tableView = UITableView.init(frame: .zero, style: .plain)
        
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        
        tableView.register(NewsDetailCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
}

// MARK: - UITableViewDataSource
extension NewsDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewsDetailCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NewsDetailCell
        
        cell.titleLabel.text = newsTitle ?? ""
        cell.summaryLabel.text = newsSummary == "" ? "资讯摘要：\(newsTitle ?? "")" : newsSummary
        
        let time: String = newsPublishDate?.yyyy_MM_dd_HH_mm_ss() ?? ""
        cell.timeLabel.text = "发布时间：\(time)"
        
        return cell
    }
}
