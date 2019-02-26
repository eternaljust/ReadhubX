//
//  TopicInstantviewViewController.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/26.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit
import WebKit
import PKHUD

/// 话题即时查看
class TopicInstantviewViewController: UIViewController {
    /// 即时查看 instantview
    var instantview: TopicInstantviewModel?
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewControllerConfig()
        view.backgroundColor = color_ffffff
        navigationItem.title = "即时查看"
        
        setupUI()
        layoutPageSubviews()
        loadHTML()
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    // MARK: - event response
    @objc private func gotoSafari() {
        let vc = BaseSafariViewController(url: URL(string: (instantview?.url)!)!)
        
        self.present(vc, animated: true, completion: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //  加载的进度条
        if keyPath == "estimatedProgress" {
            progressView.alpha = 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            
            if webView.estimatedProgress >= 1 {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                    self.progressView.alpha = 0
                }, completion: { (finish) in
                    self.progressView.setProgress(0.0, animated: false)
                })
            }
        }
    }
    
    // MARK: - private method
    private func loadHTML() {
        // 感谢 https://github.com/BryantPang/ReadHub
        let htmlHead = "<head>"
            +
            "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"> "
            + "<link rel=\"stylesheet\" href=\"https://unpkg.com/mobi.css/dist/mobi.min.css\">"
            + "<style>"
            + "img{max-width:100% !important; width:auto; height:auto;}"
            + "body {font-size: 100%;word-spacing:100%；}"
            + "</style>"
            + "</head>"
        
        let htmlContent = "<html>"
            + htmlHead
            + "<body style:'height:auto; max-width: 100%; width:auto;'>"
            + (instantview?.content)!
        
        webView.loadHTMLString(htmlContent, baseURL: nil)
    }

    private func setupUI() {
        view.addSubview(headerView)
        view.addSubview(webView)
        webView.addSubview(progressView)
    }
    
    private func layoutPageSubviews() {
        headerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.height.equalTo(110)
        }
        
        webView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(width_list_space_15)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-width_list_space_15)
            make.bottom.equalToSuperview()
        }
        
        progressView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(1)
            make.left.right.equalToSuperview()
            make.height.equalTo(2)
        }
    }
    
    // MARK: - setter getter
    /// headerView
    private lazy var headerView: TopicInstantviewHeaderView = {
        let view: TopicInstantviewHeaderView = TopicInstantviewHeaderView()
        
        view.urlButton.addTarget(self, action: #selector(gotoSafari), for: .touchUpInside)
        
        view.siteNameLabel.text = "来源：\(instantview?.siteName ?? "来源")"
        view.titleLabel.text = instantview?.title ?? "标题"
        
        return view
    }()
    
    /// webView 网页
    private lazy var webView: WKWebView = {
        let web = WKWebView()
        
        web.navigationDelegate = self
        // 监听进度条
        web.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)

        return web
    }()
    
    /// 网页进度条
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        
        progressView.tintColor = color_theme
        progressView.trackTintColor = color_ffffff
        
        return progressView
    }()
}

// MARK: - WKNavigationDelegate
extension TopicInstantviewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        HUD.flash(.label(error.localizedDescription), delay: AppConfig.HUDTextDelay)
    }
}
