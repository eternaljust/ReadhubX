//
//  StartViewController.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/18.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit
import SnapKit

typealias startCompletion = () -> Void

class StartViewController: UIViewController {
    // MARK: - proporty
    var callBack: startCompletion?
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        layoutPageSubviews()
    }
    
    // 禁用屏幕旋转
    override var shouldAutorotate: Bool {
        return false
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
            make.bottom.equalTo(startButton.top).offset(20)
        }
        
        startButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-width_large_button_space_34)
            make.left.equalToSuperview().offset(width_large_button_space_34)
            make.right.equalToSuperview().offset(-width_large_button_space_34)
            make.height.equalTo(height_large_button_47)
        }
    }
    
    // MARK: - setter getter
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = font_20
        label.textColor = color_000000
        label.text = "欢迎使用「Readhub X」"
        
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        
        tableView.register(StartCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
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
    
    private lazy var dataSource : [Dictionary] = {
        return [ [ "title" : "热门话题", "info" : "互联网行业里发生的" ], [ "title" : "科技动态", "info" : "互联网行业里发生的" ], [ "title" : "开发者资讯", "info" : "互联网行业里发生的" ], [ "title" : "区块链快讯", "info" : "互联网行业里发生的" ], ]
    }()
}

extension StartViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StartCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! StartCell
        
        cell.titleLabel.text = dataSource[indexPath.row]["title"]
        cell.infoLabel.text = dataSource[indexPath.row]["info"]

        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }
}
