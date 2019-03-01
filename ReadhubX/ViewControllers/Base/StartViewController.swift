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
        checkThirdPartyAgree()
    }
    
    // MARK: - event response
    @objc private func clickStartButton() {
        if callBack != nil {
            dismiss(animated: false, completion: nil)
            
            callBack!()
        }
    }
    
    @objc private func clickCheckButton() {
        checkButton.isSelected = !checkButton.isSelected
        
        // 开始按钮的状态
        startButton.backgroundColor = checkButton.isSelected ? color_theme_button_normal : color_theme_button_disable
        startButton.isEnabled = checkButton.isSelected
    }
    
    private func gotoThirdParty() {
        self.present(thirdPartyNavi, animated: true, completion: nil)
    }
    
    @objc private func clickBackButton() {
        thirdPartyNavi.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - private method
    private func checkThirdPartyAgree() {
        // 当前 App 的构建版本
        let build = UserDefaults.standard.string(forKey: AppConfig.build)
        
        // 只有第一次打开 App 按钮不可点击
        checkButton.isSelected = build != nil ? false : true
        
        clickCheckButton()
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(startButton)
        view.addSubview(readTextView)
        view.addSubview(checkButton)
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
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-43)
            make.left.equalToSuperview().offset(width_large_button_space_34)
            make.right.equalToSuperview().offset(-width_large_button_space_34)
            make.height.equalTo(height_large_button_47)
        }
        
        readTextView.snp.makeConstraints { (make) in
            make.top.equalTo(startButton.snp.bottom).offset(3)
            make.centerX.equalToSuperview()
            make.height.equalTo(25)
        }
        
        checkButton.snp.makeConstraints { (make) in
            make.right.equalTo(readTextView.snp.left).offset(-3)
            make.centerY.equalTo(readTextView).offset(2)
            make.size.equalTo(CGSize(width: 18, height: 18))
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
    
    /// 阅读条款
    private lazy var readTextView: UITextView = {
        let attributedString = NSMutableAttributedString(string: "我了解并阅读《Readhub X 第三方内容条款》")
        let range1 = NSMakeRange(6, attributedString.length - 6)
        
        attributedString.addAttribute(NSAttributedString.Key.link, value: NSURL(string:"link://")!, range: range1);
        attributedString.addAttribute(NSAttributedString.Key.baselineOffset, value: 0, range: NSMakeRange(0, attributedString.length))
        
        let textView = UITextView()
        
        textView.font = font_20
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.text = attributedString.string
        textView.textColor = color_000000;
        textView.textAlignment = .center
        textView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: color_theme]
        textView.dataDetectorTypes = .all;
        textView.delegate = self;
        textView.attributedText = attributedString
        
        return textView
    }()
    
    /// 勾选按钮
    private lazy var checkButton: UIButton = {
        let button = UIButton()
        
        button.setBackgroundImage(#imageLiteral(resourceName: "check"), for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "check_selected"), for: .selected)
        button.isSelected = true
        button.addTarget(self, action: #selector(clickCheckButton), for: .touchUpInside)

        return button
    }()
    
    /// 跳转第三方内容条款的 navi
    private lazy var thirdPartyNavi: NavigationViewController = {
        let url: URL = Bundle.main.url(forResource: "third-party", withExtension: "html")!
        let vc = WebViewViewController()
        vc.URL = url
        
        let navi = NavigationViewController(rootViewController: vc)
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(clickBackButton))
        
        return navi
    }()
    
    /// 列表数据源
    private lazy var dataSource : [StartItem] = {
        return [ StartItem(title: "热门话题", info: "互联网行业每天值得关注的事情"),
                 StartItem(title: "科技动态", info: "互联网行业的科技新闻报道"),
                 StartItem(title: "开发者资讯", info: "互联网行业里开发者关心的信息"),
                 StartItem(title: "区块链快讯", info: "互联网行业区块链领域的实时要闻")
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

// MARK: - UITextViewDelegate
extension StartViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if ((URL.scheme?.range(of: "link")) != nil) {
            gotoThirdParty()
            return false;
        }
        return true
    }
}
