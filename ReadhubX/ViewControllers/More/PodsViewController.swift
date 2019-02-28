//
//  PodsViewController.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/21.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit

/// 第三方开源库 ViewController
class PodsViewController: UIViewController {
    /// 列表 item
    struct PodsItem {
        /// 标题
        var title: String
        /// 链接
        var url: String
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllerConfig()
        self.navigationItem.title = "感谢开源社区的贡献"
        
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
        let tableView = UITableView.init(frame: .zero, style: .grouped)
        
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    /// 列表数据源
    private var dataSource: [[PodsItem]] = {
        return [
            [
                PodsItem(title: "Alamofire", url: "https://github.com/Alamofire/Alamofire"),
                PodsItem(title: "EmptyDataSet-Swift", url: "https://github.com/Xiaoye220/EmptyDataSet-Swift"),
                PodsItem(title: "GTMRefresh", url: "https://github.com/GTMYang/GTMRefresh"),
                PodsItem(title: "JXSegmentedView", url: "https://github.com/pujiaxin33/JXSegmentedView"),
                PodsItem(title: "PKHUD", url: "https://github.com/pkluz/PKHUD"),
                PodsItem(title: "SQLite.swift", url: "https://github.com/stephencelis/SQLite.swift"),
                PodsItem(title: "SnapKit", url: "https://github.com/SnapKit/SnapKit")
            ],
            [
                PodsItem(title: "Bugly", url: "https://bugly.qq.com")
            ]
        ]
    }()
    
    /// 分区标题
    private var sectionTitles: [String] = {
        return [ "开源库", "第三方服务" ]
    }()
}

// MARK: - UITableViewDataSource
extension PodsViewController: UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
}

// MARK: - UITableViewDelegate
extension PodsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSource[indexPath.section][indexPath.row]
        let vc = BaseSafariViewController(url: URL(string: item.url)!, configuration: BaseSafariViewController.Configuration())

        self.present(vc, animated: true, completion: nil)
    }
}
