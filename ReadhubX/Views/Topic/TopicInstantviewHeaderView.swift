//
//  TopicInstantviewHeaderView.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/26.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit

/// 话题即时查看的标题来源原网站
class TopicInstantviewHeaderView: UIView {
    // MARK: - instance
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    // MARK: - private method
    private func setupUI() {
        addSubview(siteNameLabel)
        addSubview(urlButton)
        addSubview(titleView)
        addSubview(titleLabel)
        
        layoutPageSubviews()
    }
    
    private func layoutPageSubviews() {
        siteNameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(width_list_space_15)
            make.left.equalToSuperview().offset(width_list_space_15)
            make.right.equalTo(urlButton.snp.left).offset(width_list_space_15)
            make.height.equalTo(14)
        }
        
        urlButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(siteNameLabel)
            make.right.equalToSuperview().offset(-width_list_space_15)
            make.size.equalTo(CGSize(width: 86, height: 20))
        }
        
        titleView.snp.makeConstraints { (make) in
            make.top.equalTo(siteNameLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(width_list_space_15)
            make.right.equalToSuperview().offset(-width_list_space_15)
            make.height.equalTo(46)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(titleView)
            make.left.equalTo(titleView).offset(5)
            make.right.equalTo(titleView).offset(-5)
        }
    }
    
    // MARK: - setter getter
    /// 访问原网址
    lazy var urlButton: UIButton = {
        let button = UIButton()
        
        button.titleLabel?.font = font_14
        button.setTitleColor(color_888888, for: .normal)
        button.setTitle("访问原网站 >", for: .normal)
        
        return button
    }()
    
    /// 来源
    lazy var siteNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = font_14
        label.textColor = color_888888
        label.text = "来源"
        
        return label
    }()
    
    /// 标题
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = font_17
        label.textColor = color_theme
        label.numberOfLines = 2
        label.textAlignment = .center
        
        return label
    }()
    
    /// 标题背景
    private lazy var titleView: UIView = {
        let view = UIView()
        
        view.backgroundColor = color_436a90_10
        view.layer.cornerRadius = corner_large_button_5
        view.layer.borderColor = color_436a90_10.cgColor
        view.layer.borderWidth = 1
        view.layer.masksToBounds = true
        
        return view
    }()
}
