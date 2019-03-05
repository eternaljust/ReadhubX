//
//  NewsListViewController.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/21.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit
import GTMRefresh
import EmptyDataSet_Swift
import PKHUD
import JXSegmentedView

/// 资讯列表 ViewController
class NewsListViewController: UIViewController {
    /// 父 VC 传递，方便点击跳转
    weak var viewController: UIViewController?
    /// 当前分页的 index （0: 科技动态 1: 开发者资讯 2: 区块链快讯）
    var listIndex: Int = 0
    
    /// 列表数据源
    private var list: [NewsListModel.NewsModel] = []
    /// 过滤之后的列表数据源
    private var filterList: [NewsListModel.NewsModel] = []
    /// 上一次访问的最后一条资讯的 PublishDate 对应的毫秒时间戳
    private var lastCursor: String = ""
    /// 当前的分页分类的数据 api
    private var currentAPI: String = ""
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllerConfig()
        
        setupUI()
        layoutPageSubviews()
        getCurrentAPI()
        tableView.triggerRefreshing()
        
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToTopOrRefresh), name: .TabBarItemDidSelectedNews, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(newsListFilter), name: .EnglishNewsShowOrHide, object: nil)
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
    
    @objc private func newsListFilter() {
        // 是否过滤科技动态英文新闻
        let off = UserDefaults.standard.string(forKey: AppConfig.englishSwitchOff)
        
        filterList = list.filter { (news) -> Bool in
            if off != nil {
                return news.language == AppConfig.cnLanguage
            }
            return true
        }
        
        tableView.reloadData()
    }
    
    @objc private func deleteHistoryReload() {
        // 清空浏览历史记录刷新列表
        tableView.reloadData()
    }
    
    // MARK: - private method
    private func getCurrentAPI() {
        switch listIndex {
        case 0:
            currentAPI = api_news
        case 1:
            currentAPI = api_technews
        case 2:
            currentAPI = api_blockchain
        default:
            currentAPI = api_news
        }
    }
    
    private func loadData() {
        let url = api_base + currentAPI + api_arg
        
        NetworkService<NewsListModel>().requestJSON(url: url) { (jsonModel, message, success) in
            self.tableView.endRefreshing(isSuccess: success)
            
            if success {
                DLog(msg: jsonModel)
                self.lastCursor = (jsonModel?.data.last?.publishDate)!.timeStamp()
                self.list = (jsonModel?.data)!
            } else {
                // 空白页展示
                self.tableView.emptyDataSetSource = self
                self.tableView.emptyDataSetDelegate = self
                
                HUD.flash(.label(message), delay: AppConfig.HUDTextDelay)
            }
            
            self.newsListFilter()
        }
    }
    
    private func loadMoreData() {
        let url = api_base + currentAPI + api_arg + lastCursor
        
        NetworkService<NewsListModel>().requestJSON(url: url) { (jsonModel, message, success) in
            self.tableView.endLoadMore(isNoMoreData: false)
            
            if success {
                DLog(msg: jsonModel)
                self.lastCursor = (jsonModel?.data.last?.publishDate)!.timeStamp()
                
                let list: [NewsListModel.NewsModel] = (jsonModel?.data)!
                self.list.append(contentsOf: list)
                
                self.newsListFilter()
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
        tableView.register(NewsCell.self, forCellReuseIdentifier: "cell")
        
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
extension NewsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewsCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NewsCell
        let news = filterList[indexPath.row]
        
        cell.titleLabel.text = news.title
//        cell.summaryLabel.text = news.summary
        
        let date: Date = news.publishDate.date()!
        let time: String = String.currennTime(timeStamp: date.timeIntervalSince1970, isTopic: false)
//        cell.infoLabel.text = news.siteName + " / " + news.authorName + " " + time
        cell.infoLabel.text = time
        
        // 查找历史记录阅读
        let history: Bool = SQLiteDBService.shared.searchHistory(id: "\(news.id)")
        cell.titleLabel.textColor = history ? color_888888 : color_000000
        cell.summaryLabel.textColor = history ? color_888888 : color_353535
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NewsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = filterList[indexPath.row]
        
        // 增加一条资讯历史记录
        SQLiteDBService.shared.addHistory(id: "\(news.id)", type: 1, title: (news.title), time: Date().timeIntervalSince1970, url: (news.mobileUrl), language: news.language, summary: news.summary, publishDate: news.publishDate, extra: "")
        tableView.reloadRows(at: [indexPath], with: .none)
        
        let vc = NewsDetailViewController()
        
        vc.newsTitle = news.title
        vc.newsSummary = news.summary
        vc.newsPublishDate = news.publishDate
        vc.newsURL = news.mobileUrl
        
        viewController!.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - EmptyDataSetSource
extension NewsListViewController: EmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let title: NSAttributedString = NSAttributedString.init(string: "请求失败", attributes: [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font_17, NSAttributedString.Key.foregroundColor: color_000000])
        
        return title
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let title: NSAttributedString = NSAttributedString.init(string: "数据错误或者网络断开连接", attributes: [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font_14, NSAttributedString.Key.foregroundColor: color_888888])
        
        return title
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        let title: NSAttributedString = NSAttributedString.init(string: "重新加载", attributes: [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font_18, NSAttributedString.Key.foregroundColor: color_theme])
        
        return title
    }
}

// MARK: - EmptyDataSetDelegate
extension NewsListViewController: EmptyDataSetDelegate {
    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        tableView.triggerRefreshing()
    }
}

// MARK: - JXSegmentedListContainerViewListDelegate
extension NewsListViewController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view
    }
}
