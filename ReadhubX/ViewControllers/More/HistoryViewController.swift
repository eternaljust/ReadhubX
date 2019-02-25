//
//  HistoryViewController.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/24.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift
import PKHUD

/// 浏览历史记录 ViewController
class HistoryViewController: UIViewController {
    /// 列表数据源
    var list: [HistoryModel] = []
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllerConfig()
        self.navigationItem.title = "浏览历史"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "删除", style: .plain, target: self, action: #selector(deleteHistory))
        
        setupUI()
        layoutPageSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
    
    // MARK: - event response
    @objc private func deleteHistory() {
        let alertVC = UIAlertController(title: "清空浏览历史？", message: nil, preferredStyle: .alert)
        
        alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
            
        }))
        alertVC.addAction(UIAlertAction(title: "清空", style: .destructive, handler: { _ in
            SQLiteDBService.shared.deleteHistory()
            NotificationCenter.default.post(Notification(name: .DeleteHistoryReload))
            
            HUD.flash(.label("已清空！"), delay: AppConfig.HUDTextDelay)

            self.loadData()
        }))
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: - private method
    private func loadData() {
        let histories = SQLiteDBService.shared.searchAllHistory()
        // 是否过滤科技动态英文新闻
        let off = UserDefaults.standard.string(forKey: AppConfig.englishSwitchOff)
        
        list = histories.filter({ (history) -> Bool in
            if off != nil {
                return history.language == AppConfig.cnLanguage
            }
            return true
        })
        
        if list.count == 0 {
            tableView.emptyDataSetSource = self
            
            navigationItem.rightBarButtonItem = nil
        }
        
        tableView.reloadData()
    }
    
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
        tableView.delegate = self
        tableView.estimatedRowHeight = 70
        tableView.separatorInset = .zero
        tableView.tableFooterView = UIView()
        
        tableView.register(HistoryCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
}

// MARK: - UITableViewDataSource
extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HistoryCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HistoryCell
        let history = list[indexPath.row]
        
        cell.titleLabel.text = history.title
        
        let time: String = String.historyTime(timeStamp: history.time)
        let type: String = history.type == 0 ? "「话题」" : "「资讯」"
        cell.infoLabel.text = "\(type) \(time)"
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let history = list[indexPath.row]
        
        if history.type == 1 {
            let vc = BaseSafariViewController(url: URL(string: history.url)!)
            
            self.present(vc, animated: true, completion: nil)
        } else {
            let vc = TopicDetailViewController()
            
            vc.topicID = history.id
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        // 更新历史记录时间
        SQLiteDBService.shared.updateHistory(id: history.id, time: Date().timeIntervalSince1970)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

// MARK: - EmptyDataSetSource
extension HistoryViewController: EmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let title: NSAttributedString = NSAttributedString.init(string: "暂无数据", attributes: [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font_17, NSAttributedString.Key.foregroundColor: color_000000])
        
        return title
    }
}
