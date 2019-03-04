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
    /// 当前的话题 id
    var topicID: String = ""
    /// 话题详情
    private var topicDetail: TopicDetailModel?
    /// 新闻列表数据源
    private var newsArray: [TopicDetailModel.TopicDetailNewsModel] = []
    /// 复制分享链接
    private var copyShareURL: String?
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllerConfig()
        navigationItem.title = "话题详情"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "more"), style: .plain, target: self, action: #selector(more))
        
        copyShareURL = "https://readhub.cn/topic/\(topicID)"
        
        setupUI()
        layoutPageSubviews()
        loadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(newsListFilter), name: .EnglishNewsShowOrHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - event response
    @objc private func newsListFilter() {
        // 是否过滤科技动态英文新闻
        let off = UserDefaults.standard.string(forKey: AppConfig.englishSwitchOff)
        
        let filterNewsArray = newsArray.filter { (news) -> Bool in
            if off != nil {
                return news.language == AppConfig.cnLanguage
            }
            return true
        }
        topicDetail?.newsArray = filterNewsArray
        // 时间排序
        topicDetail?.newsArray.sort(by: { (news1, news2) -> Bool in
            return (news1.publishDate.date()?.timeIntervalSince1970)! > (news2.publishDate.date()?.timeIntervalSince1970)!
        })
        
        // 过滤掉相关话题列表中包含当前的话题
        let fileterTopics = topicDetail?.timeline?.topics.filter({ (topic) -> Bool in
            return topic.id != self.topicID
        })
        topicDetail?.timeline?.topics = fileterTopics ?? []
        
        tableView.reloadData()
    }
    
    @objc private func loadInstantview() {
        let url = api_base + api_topic_instantview + topicID
        
        HUD.show(.systemActivity, onView: view)
        NetworkService<TopicInstantviewModel>().requestJSON(url: url) { (jsonModel, message, success) in
            HUD.hide()
            
            if success {
                DLog(msg: jsonModel)
                let vc = TopicInstantviewViewController()
                
                vc.instantview = jsonModel
                
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                HUD.flash(.label(message), delay: AppConfig.HUDTextDelay)
            }
        }
    }
    
    @objc private func more() {
        let actionSheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "复制链接", style: .default, handler: { _ in
            self.copyLink()
        }))
        actionSheet.addAction(UIAlertAction(title: "分享", style: .default, handler: { _ in
            self.systemShare()
        }))
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
            
        }))
        actionSheet.view.tintColor = color_theme
        
        self.present(actionSheet, animated: true, completion: nil)
    }
 
    // MARK: - private method
    private func loadData() {
        let url = api_base + api_topic_detail + topicID
        
        HUD.show(.systemActivity, onView: view)
        NetworkService<TopicDetailModel>().requestJSON(url: url) { (jsonModel, message, success) in
            HUD.hide()

            if success {
                DLog(msg: jsonModel)
                self.topicDetail = jsonModel
                self.newsArray = jsonModel?.newsArray ?? []
                
                self.newsListFilter()
                
                // 即时查看
//                if (jsonModel?.hasInstantView)! {
//                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "instantview"), style: .plain, target: self, action: #selector(self.loadInstantview))
//                }
            } else {
                HUD.flash(.label(message), delay: AppConfig.HUDTextDelay)
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
    
    private func copyLink() {
        UIPasteboard.general.string = self.copyShareURL
        
        HUD.flash(.label("已复制"), delay: AppConfig.HUDTextDelay)
    }
    
    private func systemShare() {
        let vc = UIActivityViewController(
            activityItems: [
                topicDetail?.title ?? "Readhub 话题",
                #imageLiteral(resourceName: "app_logo"),
                URL(string: copyShareURL!) as Any],
            applicationActivities: [])
        
        // 解决 iPad 分享奔溃
        if iPad {
            vc.popoverPresentationController?.sourceView = view
            vc.popoverPresentationController?.sourceRect = view.frame
        }
        
        currentViewController().present(vc, animated: true, completion: nil)
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
//            cell.infoLabel.text = news?.siteName
            let date: Date = (news?.publishDate.date()!)!
            let time: String = String.currennTime(timeStamp: date.timeIntervalSince1970, isTopic: true)
            cell.infoLabel.text = time
            
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

            // 增加一条资讯历史记录
            SQLiteDBService.shared.addHistory(id: (news?.id)!, type: 1, title: (news?.title)!, time: Date().timeIntervalSince1970, url: (news?.mobileUrl)!, language: (news?.language)!, summary: "", publishDate: (news?.publishDate)!, extra: "")
            tableView.reloadRows(at: [indexPath], with: .none)
            
            let vc = NewsDetailViewController()
            
            vc.newsTitle = news!.title
            vc.newsSummary = ""
            vc.newsPublishDate = news?.publishDate
            
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 2 {
            let topic = topicDetail?.timeline?.topics[indexPath.row]
            
            // 增加一条话题历史记录
            SQLiteDBService.shared.addHistory(id: (topic?.id)!, type: 0, title: (topic?.title)!, time: Date().timeIntervalSince1970, url: "", language: AppConfig.cnLanguage, summary: "", publishDate: (topic?.createdAt)!, extra: "")
            tableView.reloadRows(at: [indexPath], with: .none)
            
            let vc = TopicDetailViewController()
            
            vc.topicID = (topic?.id)!
            
            self.navigationController?.pushViewController(vc, animated: true)
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
            header.titleLabel.text = newsArrayCount() ? "相关报道" : nil
        } else {
            header.titleLabel.text = timelineTopicsCount() ? "相关事件" : nil
        }
        
        return header
    }
}

// MARK: - Peek && Pop
extension TopicDetailViewController {
    override var previewActionItems: [UIPreviewActionItem] {
        let copyAction = UIPreviewAction(
            title: "复制链接",
            style: .default) { [weak self] action, vc in
                self?.copyLink()
        }
        
        let shareAction = UIPreviewAction(
            title: "分享",
            style: .default) { [weak self] action, vc in
                self?.systemShare()
        }
        
        return [copyAction, shareAction]
    }
}
