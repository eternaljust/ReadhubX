//
//  NewsViewController.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/18.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit
import SafariServices
import GTMRefresh
import EmptyDataSet_Swift
import PKHUD

class NewsViewController: UIViewController {

    var list: [NewsList.News] = []
    var lastCursor: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "资讯"

        setupUI()
        layoutPageSubviews()
        tableView.triggerRefreshing()
    }
    
    // MARK: - private method
    private func loadData() {
        let url = api_base + api_news + api_arg
        
        NetworkService<NewsList>().requestJSON(url: url) { (jsonModel, message, success) in
            self.tableView.endRefreshing(isSuccess: success)

            if (success != false) {
                DLog(msg: jsonModel)
                self.lastCursor = (jsonModel?.data.last?.publishDate)!.timeStamp()
                self.list = (jsonModel?.data)!
            } else {
                // 空白页展示
                self.tableView.emptyDataSetSource = self
                self.tableView.emptyDataSetDelegate = self
                
                HUD.flash(.label(message), delay: 2)
            }
            
            self.tableView.reloadData()
        }
    }
    
    private func loadMoreData() {
        let url = api_base + api_news + api_arg + lastCursor
        
        NetworkService<NewsList>().requestJSON(url: url) { (jsonModel, message, success) in
            self.tableView.endLoadMore(isNoMoreData: success)

            if (success != false) {
                DLog(msg: jsonModel)
                self.lastCursor = (jsonModel?.data.last?.publishDate)!.timeStamp()
                
                let list: [NewsList.News] = (jsonModel?.data)!
                self.list.append(contentsOf: list)
                
                self.tableView.reloadData()
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

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewsCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NewsCell
        let news = list[indexPath.row]
        
        cell.titleLabel.text = news.title
        cell.contentLabel.text = news.summary

        let date: Date = news.publishDate.date()!
        let time: String = String.currennTime(timeStamp: date.timeIntervalSince1970)
        cell.infoLabel.text = news.siteName + " / " + news.authorName + " " + time
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = list[indexPath.row]
        let vc = SFSafariViewController.init(url: URL.init(string: news.mobileUrl)!)
        vc.preferredControlTintColor = color_theme

        self.present(vc, animated: true, completion: nil)
    }
}

extension NewsViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    // MARK: - EmptyDataSetSource
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
    
    // MARK: - EmptyDataSetDelegate
    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        tableView.triggerRefreshing()
    }
    
}
