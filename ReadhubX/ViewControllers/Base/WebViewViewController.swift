//
//  WebViewViewController.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/28.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit
import WebKit
import PKHUD

/// webView 网页 ViewController
class WebViewViewController: UIViewController {
    /// url 网页链接
    var URL: URL?
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllerConfig()
        view.backgroundColor = color_ffffff
        
        setupUI()
        layoutPageSubviews()
        loadHTML()
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    // MARK: - event response
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
        webView.load(URLRequest(url: URL!))
    }
    
    private func setupUI() {
        view.addSubview(webView)
        webView.addSubview(progressView)
    }
    
    private func layoutPageSubviews() {
        webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        progressView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(1)
            make.left.right.equalToSuperview()
            make.height.equalTo(2)
        }
    }
    
    // MARK: - setter getter
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
extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        navigationItem.title = webView.title
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        HUD.flash(.label(error.localizedDescription), delay: AppConfig.HUDTextDelay)
    }
}
