//
//  NewsViewController.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/18.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit
import SafariServices

class NewsViewController: UIViewController {

    var list: [NewsList.News] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "资讯"

        setupUI()
        layoutPageSubviews()
        loadData()
    }
    
    // MARK: - private method
    private func loadData() {
        let url = api_base + api_news + api_arg
        
        NetworkService<NewsList>().requestJSON(url: url) { (josnModel, message, success) in
            DLog(msg: josnModel)
            
            self.list = (josnModel?.data)!
            self.tableView.reloadData()
        }
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
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
}

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let news = list[indexPath.row]
        
        cell?.textLabel?.text = news.title
        cell?.detailTextLabel?.text = news.summary
        
        return cell!
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = list[indexPath.row]
        let vc = SFSafariViewController.init(url: URL.init(string: news.mobileUrl)!)
        vc.preferredControlTintColor = color_theme

        self.present(vc, animated: true, completion: nil)
    }
}
