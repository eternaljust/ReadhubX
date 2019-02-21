//
//  StartViewController.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/18.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit
import SnapKit

/// 开始使用 ViewController
class StartViewController: UIViewController {
    /// 列表 item
    struct StartItem {
        /// 标题
        var title: String
        /// 详细描述
        var info: String
    }
    
    typealias startCompletion = () -> Void
    // 开始按钮点击回调
    var callBack: startCompletion?
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        layoutPageSubviews()
    }
    
    // MARK: - event response
    @objc private func clickStartButton() {
        if callBack != nil {
            callBack!()
        }
    }
    
    // MARK: - private method
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(startButton)
    }
    
    private func layoutPageSubviews() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(width_large_button_space_34)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(width_large_button_space_34)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(startButton.snp.top).offset(-width_large_button_space_34)
        }
        
        startButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-width_large_button_space_34)
            make.left.equalToSuperview().offset(width_large_button_space_34)
            make.right.equalToSuperview().offset(-width_large_button_space_34)
            make.height.equalTo(height_large_button_47)
        }
    }
    
    // MARK: - setter getter
    /// 标题
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = font_20
        label.textColor = color_000000
        label.text = "欢迎使用「Readhub X」"
        
        return label
    }()
    
    /// 列表视图
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        tableView.register(StartCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    /// 开始按钮
    private lazy var startButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.backgroundColor = color_theme_button_normal;
        button.setBackgroundImage(UIImage.imageWithColor(color: color_theme_button_normal), for: .normal)
        button.setBackgroundImage(UIImage.imageWithColor(color: color_theme_button_press), for: .highlighted)
        button.titleLabel?.font = font_18
        button.setTitleColor(color_ffffff, for: .normal)
        button.layer.cornerRadius = corner_large_button_5
        button.layer.masksToBounds = true
        button.setTitle("开始使用", for: .normal)
        button.addTarget(self, action: #selector(clickStartButton), for: .touchUpInside)
        
        return button
    }()
    
    /// 列表数据源
    private lazy var dataSource : [StartItem] = {
        return [ StartItem(title: "热门话题", info: "互联网行业里发生的"),
                 StartItem(title: "科技动态", info: "互联网行业里发生的"),
                 StartItem(title: "开发者资讯", info: "互联网行业里发生的"),
                 StartItem(title: "区块链快讯", info: "互联网行业里发生的")
        ]
    }()
}

// MARK: - UITableViewDataSource
extension StartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StartCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! StartCell
        let item = dataSource[indexPath.row]
        
        cell.titleLabel.text = item.title
        cell.infoLabel.text = item.info

        return cell
    }
}

// MARK: - UITableViewDelegate
extension StartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }
}
