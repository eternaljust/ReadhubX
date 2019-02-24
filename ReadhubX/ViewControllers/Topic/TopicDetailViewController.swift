//
//  TopicDetail1ViewController.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/23.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit
import PKHUD

/// 话题详情 ViewController
class TopicDetailViewController: UIViewController {
    var topicID: String = ""
    /// 话题详情
    private var topicDetail: TopicDetail?
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllerConfig()
        navigationItem.title = "话题详情"
        
        setupUI()
        layoutPageSubviews()
        loadData()
    }
    
    // MARK: - event response
    
    // MARK: - private method
    private func loadData() {
        let url = api_base + api_topic_detail + topicID
        
        HUD.show(.systemActivity)
        NetworkService<TopicDetail>().requestJSON(url: url) { (jsonModel, message, success) in
            HUD.hide()

            if success {
                DLog(msg: jsonModel)
                self.topicDetail = jsonModel
                
                self.tableView.reloadData()
            } else {
                HUD.flash(.label(message), delay: 2)
            }
        }
    }
    
    private func newsArrayCount() -> Bool {
        if topicDetail != nil {
            return topicDetail?.newsArray.count ?? 0 > 0
        }
        return false
    }
    
    private func timelineTopicsCount() -> Bool {
        if topicDetail != nil {
            if topicDetail?.timeline != nil {
                return topicDetail?.timeline?.topics.count ?? 0 > 0
            }
            return false
        }
        return false
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
        
        tableView.register(TopicDetailCell.self, forCellReuseIdentifier: "cell1")
        tableView.register(TopicDetailNewsTopicCell.self, forCellReuseIdentifier: "cell2")
        tableView.register(TopicDetailNewsTopicCell.self, forCellReuseIdentifier: "cell3")
        tableView.register(TopicDetailHeader.self, forHeaderFooterViewReuseIdentifier: "header")

        return tableView
    }()
}

// MARK: - UITableViewDataSource
extension TopicDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if topicDetail != nil {
            if section == 0 {
                return 1
            } else if section == 1 {
                return topicDetail?.newsArray.count ?? 0
            }
            return topicDetail?.timeline?.topics.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: TopicDetailCell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! TopicDetailCell
            
            if topicDetail != nil {
                cell.titleLabel.text = topicDetail!.title
                cell.summaryLabel.text = topicDetail!.summary
                
                let date: Date = topicDetail!.createdAt.date()!
                let time: String = String.currennTime(timeStamp: date.timeIntervalSince1970, isTopic: true)
                cell.timeLabel.text = time
            }
            
            return cell
        } else if indexPath.section == 1 {
            let cell: TopicDetailNewsTopicCell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! TopicDetailNewsTopicCell
            let news = topicDetail?.newsArray[indexPath.row]
            
            cell.titleLabel.text = news?.title
            cell.infoLabel.text = news?.siteName
            
            // 查找历史记录阅读
            let history: Bool = SQLiteDBService.shared.searchHistory(id: (news?.id)!)
            cell.titleLabel.textColor = history ? color_888888 : color_000000
            
            return cell
        } else {
            let cell: TopicDetailNewsTopicCell = tableView.dequeueReusableCell(withIdentifier: "cell3") as! TopicDetailNewsTopicCell
            let topic = topicDetail?.timeline?.topics[indexPath.row]
            
            cell.titleLabel.text = topic?.title
            
            let date: Date = topic!.createdAt.date()!
            let time: String = String.currennTime(timeStamp: date.timeIntervalSince1970, isTopic: true)
            cell.infoLabel.text = time
            
            // 查找历史记录阅读
            let history: Bool = SQLiteDBService.shared.searchHistory(id: (topic?.id)!)
            cell.titleLabel.textColor = history ? color_888888 : color_000000
            
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension TopicDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let news = topicDetail?.newsArray[indexPath.row]
            let vc = BaseSafariViewController(url: URL(string: (news?.mobileUrl)!)!)
            
            self.present(vc, animated: true, completion: nil)
            
            // 增加一条资讯历史记录
            SQLiteDBService.shared.addHistory(id: (news?.id)!, type: 1, title: (news?.title)!, time: Date().timeIntervalSince1970, url: (news?.mobileUrl)!)
            tableView.reloadRows(at: [indexPath], with: .none)
        } else if indexPath.section == 2 {
            let topic = topicDetail?.timeline?.topics[indexPath.row]
            let vc = TopicDetailViewController()
            
            vc.topicID = (topic?.id)!
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            // 增加一条话题历史记录
            SQLiteDBService.shared.addHistory(id: (topic?.id)!, type: 0, title: (topic?.title)!, time: Date().timeIntervalSince1970, url: "")
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.1
        } else if section == 1 {
            return newsArrayCount() ? 40 : 0.1
        } else {
            return timelineTopicsCount() ? 40 : 0.1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: TopicDetailHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! TopicDetailHeader
        
        if section == 0 {
            return nil
        } else if section == 1 {
            header.titleLabel.text = newsArrayCount() ? "媒体报道" : nil
        } else {
            header.titleLabel.text = timelineTopicsCount() ? "相关事件" : nil
        }
        
        return header
    }
}
