//
//  AboutViewController.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/21.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit
import PKHUD

/// 关于 ViewController
class AboutViewController: UIViewController {
    enum AboutItemType: Int {
        /// URL Schemes
        case urlSchemes
        /// 清理缓存
        case reset
        /// 更新版本
        case update
        
        /// 开源库
        case pods
        /// 项目源码
        case repository
        
        /// 关于
        case about
    }
    
    /// 列表 item
    struct AboutItem {
        /// 标题
        var title: String
        /// 类型
        var type: AboutItemType
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllerConfig()
        self.navigationItem.title = "关于"
        
        setupUI()
        layoutPageSubviews()
    }
    
    // MARK: - event response
    private func gotoURLSchemes() {
        self.navigationController?.pushViewController(URLSchemesViewController(), animated: true)
    }
    
    private func reset() {
        let alertVC = UIAlertController(title: "清理缓存？", message: "同时会恢复默认设置以及清空浏览历史", preferredStyle: .alert)
        
        alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
            
        }))
        alertVC.addAction(UIAlertAction(title: "确认", style: .destructive, handler: { _ in
            // 通知 Switch 恢复默认打开
            NotificationCenter.default.post(Notification(name: .TopicSwitchOn))
            NotificationCenter.default.post(Notification(name: .EnglishSwitchOn))
            
            // 清空浏览历史
            SQLiteDBService.shared.deleteHistory()
            NotificationCenter.default.post(Notification(name: .DeleteHistoryReload))
            
            HUD.flash(.label("清理缓存成功！"), delay: AppConfig.HUDTextDelay)
        }))
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    private func update() {
        UIApplication.shared.open(URL(string: AppConfig.url)!, options: [:]) {  (success) in
            
        }
    }
    
    private func gotoPods() {
        self.navigationController?.pushViewController(PodsViewController(), animated: true)
    }
    
    private func gotoRepository() {
        let vc = BaseSafariViewController(url: URL(string: AppConfig.appRepository)!)
        
        self.present(vc, animated: true, completion: nil)
    }
    
    private func gotoAbout() {
        let vc = BaseSafariViewController(url: URL(string: AppConfig.readhubIntroURL)!)

        self.present(vc, animated: true, completion: nil)
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
        tableView.tableHeaderView = headerView
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    private lazy var headerView: AboutHeaderView = {
        let headerView = AboutHeaderView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 200))
        
        headerView.versionLabel.text = "Readhub X v\(APP_VERSION)(\(APP_BUILD))"
        
        return headerView
    }()
    
    /// 列表数据源
    private var dataSource: [[AboutItem]] = {
        return [
            [
                AboutItem(title: "URL Schemes", type: .urlSchemes),
                AboutItem(title: "清理缓存", type: .reset),
                AboutItem(title: "更新版本", type: .update)
            ],
            [
                AboutItem(title: "开源库", type: .pods),
                AboutItem(title: "项目源码", type: .repository)
            ],
            [
                AboutItem(title: "关于 Readhub", type: .about)
            ]
        ]
    }()
}

// MARK: - UITableViewDataSource
extension AboutViewController: UITableViewDataSource {
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
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AboutViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSource[indexPath.section][indexPath.row]
        
        switch item.type {
        case .urlSchemes:
            gotoURLSchemes()
        case .reset:
            reset()
        case .update:
            update()
            
        case .pods:
            gotoPods()
        case .repository:
            gotoRepository()
            
        case .about:
            gotoAbout()
        }
    }
}
