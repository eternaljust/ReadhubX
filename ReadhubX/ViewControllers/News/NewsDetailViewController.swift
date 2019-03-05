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
    /// 资讯 url
    var newsURL: String?
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllerConfig()
        view.backgroundColor = color_ffffff
        navigationItem.title = "资讯详情"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "more"), style: .plain, target: self, action: #selector(more))

        setupUI()
        layoutPageSubviews()
    }
    
    // MARK: - event response
    @objc private func more() {
        let actionSheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "分享", style: .default, handler: { _ in
            self.systemShare()
        }))
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
            
        }))
        actionSheet.view.tintColor = color_theme
        // 解决 iPad 奔溃
        if iPad {
            actionSheet.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        }
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func systemShare() {
        let vc = UIActivityViewController(
            activityItems: [
                newsTitle ?? "Readhub 资讯",
                #imageLiteral(resourceName: "app_logo"),
                URL(string: newsURL!) as Any],
            applicationActivities: [])
        
        // 解决 iPad 分享奔溃
        if iPad {
            vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        }
        
        currentViewController().present(vc, animated: true, completion: nil)
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
