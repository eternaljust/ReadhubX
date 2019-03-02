//
//  MoreViewController.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/18.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit
import MessageUI
import PKHUD

/// 更多 ViewController
class MoreViewController: UIViewController {
    enum MoreItemType: Int {
        /// 热门话题摘要
        case topic
        /// 科技动态英文新闻
        case english
        /// 浏览历史
        case history
        
        /// 去评分
        case grade
        /// 推荐给朋友
        case share
        /// 意见反馈
        case feedback
        /// 关于
        case about
    }
    
    /// 列表 item
    struct MoreItem {
        /// 标题
        var title: String
        /// 类型
        var type: MoreItemType
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewControllerConfig()
        self.navigationItem.title = "更多"

        setupUI()
        layoutPageSubviews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(topicSwitchOn), name: .TopicSwitchOn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enlishSwitchOn), name: .EnglishSwitchOn, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - event response
    @objc private func topicSwitchOn() {
        topicSwitch.setOn(true, animated: false)
        
        onTopicSwitch()
    }
    
    @objc private func enlishSwitchOn() {
        englishSwitch.setOn(true, animated: false)
        
        onEnglishSwitch()
    }
    
    private func gotoBrowseHistory() {
        self.navigationController?.pushViewController(HistoryViewController(), animated: true)
    }
    
    private func grade() {
        UIApplication.shared.open(URL(string: AppConfig.gradeURL)!, options: [:]) {  (success) in
            
        }
    }
    
    private func share() {
        let vc = UIActivityViewController(
            activityItems: [
                AppConfig.title,
                #imageLiteral(resourceName: "app_logo"),
                URL(string: AppConfig.url) as Any],
            applicationActivities: [])
        
        // 解决 iPad 分享奔溃
        if iPad {
            vc.popoverPresentationController?.sourceView = view
            vc.popoverPresentationController?.sourceRect = view.frame
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    private func gotoAbout() {
        self.navigationController?.pushViewController(AboutViewController(), animated: true)
    }
    
    @objc private func onTopicSwitch() {
        // 是否关闭
        UserDefaults.standard.set(topicSwitch.isOn ? nil : "1", forKey: AppConfig.topicSummarySwitchOff)
        
        // 通知处理列表数据
        NotificationCenter.default.post(Notification(name: .TopicSummaryShowOrHide))
    }
    
    @objc private func onEnglishSwitch() {
        // 是否关闭
        UserDefaults.standard.set(englishSwitch.isOn ? nil : "1", forKey: AppConfig.englishSwitchOff)
        
        // 通知处理列表数据
        NotificationCenter.default.post(Notification(name: .EnglishNewsShowOrHide))
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
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    /// 热门话题摘要开关
    private lazy var topicSwitch: UISwitch = {
        let switch1 = UISwitch.init()

        // 是否关闭
        let off = UserDefaults.standard.string(forKey: AppConfig.topicSummarySwitchOff)
        
        switch1.setOn(off == nil ? true : false, animated: false)
        switch1.addTarget(self, action: #selector(onTopicSwitch), for: .valueChanged)

        return switch1
    }()
    
    /// 科技动态英文新闻开关
    private lazy var englishSwitch: UISwitch = {
        let switch1 = UISwitch.init()
        
        // 是否关闭
        let off = UserDefaults.standard.string(forKey: AppConfig.englishSwitchOff)
        
        switch1.setOn(off == nil ? true : false, animated: false)
        switch1.addTarget(self, action: #selector(onEnglishSwitch), for: .valueChanged)

        return switch1
    }()
    
    /// 列表数据源
    private var dataSource: [[MoreItem]] = {
        return [
            [
                MoreItem(title: "热门话题摘要", type: .topic),
//                MoreItem(title: "科技动态英文新闻", type: .english),
                MoreItem(title: "浏览历史", type: .history)
            ],
            [
//                MoreItem(title: "到 App Store 评分", type: .grade),
//                MoreItem(title: "推荐给朋友", type: .share),
                MoreItem(title: "意见反馈", type: .feedback),
                MoreItem(title: "关于 Readhub X", type: .about)
            ]
        ]
    }()
    
    /// 分区头部标题
    private lazy var sectionTitles: Array = {
        return [ "设置", "综合" ]
    }()
}

// MARK: - UITableViewDataSource
extension MoreViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let item = dataSource[indexPath.section][indexPath.row]

        cell.textLabel?.text = item.title
        cell.accessoryType = .disclosureIndicator

        switch item.type {
        case .topic:
            cell.accessoryView = topicSwitch
        case .english:
            cell.accessoryView = englishSwitch
        default:
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
}

// MARK: - UITableViewDelegate
extension MoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSource[indexPath.section][indexPath.row]
        
        switch item.type {
        case .history:
            gotoBrowseHistory()
            
        case .share:
            share()
        case .grade:
            grade()
        case .feedback:
            sendEmail()
            
        case .about:
            gotoAbout()
        default:
            break
        }
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension MoreViewController: MFMailComposeViewControllerDelegate {
    private func sendEmail() {
        guard MFMailComposeViewController.canSendMail() else {
            let alertVC = UIAlertController(title: "无法发送邮件", message: "您的设备尚未设置邮箱，请在“邮件”应用中设置后再尝试发送。\n或直接通过邮箱向我反馈 email: \(AppConfig.receiverEmail)", preferredStyle: .alert)
            
            alertVC.addAction(UIAlertAction(title: "取消", style: .cancel) { _ in
            })
            alertVC.addAction(UIAlertAction(title: "复制邮箱", style: .destructive) { _ in
                UIPasteboard.general.string = AppConfig.receiverEmail
                
                HUD.flash(.label("已复制"), delay: AppConfig.HUDTextDelay)
            })
            
            self.present(alertVC, animated: true, completion: nil)
            
            return
        }
        
        let mailVC = MFMailComposeViewController()
        
        mailVC.setSubject("Readhub X iOS 反馈")
        mailVC.setToRecipients([AppConfig.receiverEmail])
        mailVC.setMessageBody("\n\n\n\n[运行环境] \(UIDevice.current.name)(\(UIDevice.current.systemVersion))-\(APP_VERSION)(\(APP_BUILD))", isHTML: false)
        mailVC.mailComposeDelegate = self
        
        self.present(mailVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
        
        switch result {
        case .sent:
            HUD.flash(.label("感谢您的反馈，我会尽量给您答复。"), delay: AppConfig.HUDTextDelay)
        case .failed:
            HUD.flash(.label("邮件发送失败"), delay: AppConfig.HUDTextDelay)
        default:
            break
        }
    }
}
