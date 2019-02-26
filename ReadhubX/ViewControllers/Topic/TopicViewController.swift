//
//  TopicViewController.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/18.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit
import GTMRefresh
import EmptyDataSet_Swift
import PKHUD

/// 热门话题列表 ViewController
class TopicViewController: UIViewController {
    /// 列表数据源
    private var list: [TopicListModel.TopicModel] = []
    /// 上一页数据最后一个话题的order，首次传空
    private var lastCursor: String = ""
    // 是否显示热门话题摘要
    private var summaryShow: Bool = true
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllerConfig()
        navigationItem.title = "热门话题"
        
        setupUI()
        layoutPageSubviews()
        tableView.triggerRefreshing()
        
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToTopOrRefresh), name: .TabBarItemDidSelectedTopic, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(summaryShowOrHide), name: .TopicSummaryShowOrHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteHistoryReload), name: .DeleteHistoryReload, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - event response
    @objc private func scrollToTopOrRefresh() {
        let contentOffsetY: CGFloat = tableView.contentOffset.y
        
        // 滚动到列表顶部或者刷新
        if contentOffsetY > 0 {
            tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        } else {
            tableView.triggerRefreshing()
        }
    }
    
    @objc private func summaryShowOrHide() {
        // 是否显示热门话题摘要
        let off = UserDefaults.standard.string(forKey: AppConfig.topicSummarySwitchOff)
        
        summaryShow = off == nil ? true : false
        
        tableView.reloadData()
    }
    
    @objc private func deleteHistoryReload() {
        // 清空浏览历史记录刷新列表
        tableView.reloadData()
    }
    
    // MARK: - private method
    private func loadData() {
        let url = api_base + api_topic + api_arg
        
        NetworkService<TopicListModel>().requestJSON(url: url) { (jsonModel, message, success) in
            self.tableView.endRefreshing(isSuccess: success)
            
            if success {
                DLog(msg: jsonModel)
                self.lastCursor = "\(jsonModel?.data.last?.order ?? 0)"
                self.list = (jsonModel?.data)!
            } else {
                // 空白页展示
                self.tableView.emptyDataSetSource = self
                self.tableView.emptyDataSetDelegate = self
                
                HUD.flash(.label(message), delay: AppConfig.HUDTextDelay)
            }
            
            self.summaryShowOrHide()
        }
    }
    
    private func loadMoreData() {
        let url = api_base + api_topic + api_arg + lastCursor
        
        NetworkService<TopicListModel>().requestJSON(url: url) { (jsonModel, message, success) in
            self.tableView.endLoadMore(isNoMoreData: false)
            
            if success {
                DLog(msg: jsonModel)
                self.lastCursor = "\(jsonModel?.data.last?.order ?? 0)"

                let list: [TopicListModel.TopicModel] = (jsonModel?.data)!
                self.list.append(contentsOf: list)
                
                self.summaryShowOrHide()
            } else {
                HUD.flash(.label(message), delay: 2)
            }
        }
    }
    
    private func setupUI() {
        view.addSubview(tableView)
    }
    
    private func layoutPageSubviews() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    // MARK: - setter getter
    /// 列表视图
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = .zero
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.register(TopicCell.self, forCellReuseIdentifier: "cell")
        
        tableView.gtm_addRefreshHeaderView {
            self.loadData()
        }
        tableView.gtm_addLoadMoreFooterView {
            self.loadMoreData()
        }
        
        return tableView
    }()
}

// MARK: - UITableViewDataSource
extension TopicViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TopicCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TopicCell
        let topic = list[indexPath.row]
        
        cell.titleLabel.text = topic.title
        cell.summaryLabel.text = summaryShow ? topic.summary : nil
        
        let date: Date = topic.createdAt.date()!
        let time: String = String.currennTime(timeStamp: date.timeIntervalSince1970, isTopic: true)
        cell.timeLabel.text = time
        
        // 查找历史记录阅读
        let history: Bool = SQLiteDBService.shared.searchHistory(id: topic.id)
        cell.titleLabel.textColor = history ? color_888888 : color_000000
        cell.summaryLabel.textColor = history ? color_888888 : color_353535
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TopicViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topic = list[indexPath.row]
        
        // 增加一条话题历史记录
        SQLiteDBService.shared.addHistory(id: topic.id, type: 0, title: topic.title, time: Date().timeIntervalSince1970, url: "", language: AppConfig.cnLanguage, extra: "")
        tableView.reloadRows(at: [indexPath], with: .none)
        
        let vc = TopicDetailViewController()

        vc.topicID = topic.id

        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - EmptyDataSetSource
extension TopicViewController: EmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let title: NSAttributedString = NSAttributedString.init(string: "请求失败", attributes: [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font_17, NSAttributedString.Key.foregroundColor: color_000000])
        
        return title
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let title: NSAttributedString = NSAttributedString.init(string: "数据错误或者网络断开连接", attributes: [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font_14, NSAttributedString.Key.foregroundColor: color_888888])
        
        return title
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        let title: NSAttributedString = NSAttributedString.init(string: "重新加载话题", attributes: [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font_18, NSAttributedString.Key.foregroundColor: color_theme])
        
        return title
    }
}

// MARK: - EmptyDataSetDelegate
extension TopicViewController: EmptyDataSetDelegate {
    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        tableView.triggerRefreshing()
    }
}
