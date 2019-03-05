
//
//  CollectionViewController.swift
//  ReadhubX
//
//  Created by Awro on 2019/3/5.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift
import PKHUD

/// 话题收藏 ViewController
class CollectionViewController: UIViewController {
    /// 列表数据源
    var list: [CollectionModel] = []
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllerConfig()
        navigationItem.title = "话题收藏"
        
        setupUI()
        layoutPageSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
    
    // MARK: - event response
    private func cancelCollection(indexPath: IndexPath) {
        let alertVC = UIAlertController(title: "确认取消收藏？", message: nil, preferredStyle: .alert)
        let collection = list[indexPath.row]
        
        alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
            
        }))
        alertVC.addAction(UIAlertAction(title: "确认", style: .destructive, handler: { _ in
            let success = SQLiteDBService.shared.deleteCollection(id: collection.id)
            
            HUD.flash(.label(success ? "取消收藏成功！" : "取消收藏失败！"), delay: AppConfig.HUDTextDelay)
            
            self.loadData()
        }))
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: - private method
    private func loadData() {
        list = SQLiteDBService.shared.searchAllCollection()
        
        if list.count == 0 {
            tableView.emptyDataSetSource = self
        }
        
        // 记录条数
        countLabel.text = "已收藏 \(list.count) 条"
        countLabel.isHidden = true
        
        tableView.reloadData()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(countLabel)
    }
    
    private func layoutPageSubviews() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(width_list_space_15)
            make.right.equalToSuperview().offset(-width_list_space_15)
            make.height.equalTo(20)
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
        
        tableView.register(CollectionCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    /// 已记录多少条
    let countLabel: UILabel = {
        let label = UILabel()
        
        label.font = font_14
        label.textColor = color_888888
        label.textAlignment = .center
        label.text = "已记录 条"
        label.isHidden = true
        
        return label
    }()
}

// MARK: - UITableViewDataSource
extension CollectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CollectionCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CollectionCell
        let collection = list[indexPath.row]
        
        cell.titleLabel.text = collection.title
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CollectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collection = list[indexPath.row]
        
        let vc = TopicDetailViewController()
        
        vc.topicID = collection.id
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        // 更新历史记录时间
        SQLiteDBService.shared.updateHistory(id: collection.id, time: Date().timeIntervalSince1970)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let cancelAction = UITableViewRowAction(
            style: .destructive,
            title: "取消收藏") { _, indexPath in
                self.cancelCollection(indexPath: indexPath)
        }
        
        return [cancelAction]
    }
}

// MARK: - EmptyDataSetSource
extension CollectionViewController: EmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let title: NSAttributedString = NSAttributedString.init(string: "暂无数据", attributes: [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font_17, NSAttributedString.Key.foregroundColor: color_000000])
        
        return title
    }
}

// MARK: -
extension CollectionViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        
        // 滚动偏移量
        if contentOffsetY < -34 {
            countLabel.isHidden = false
        } else if contentOffsetY >= -34 && contentOffsetY < -20 {
            countLabel.isHidden = false
            countLabel.alpha = (-20 - contentOffsetY) / 14;
        } else {
            countLabel.isHidden = true;
        }
    }
}
