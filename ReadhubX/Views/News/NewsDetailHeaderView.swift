//
//  NewsDetailHeaderView.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/28.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit

/// 资讯详情的标题 HeaderView
class NewsDetailHeaderView: UIView {
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
        addSubview(titleView)
        addSubview(titleLabel)
        
        layoutPageSubviews()
    }
    
    private func layoutPageSubviews() {
        titleView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(width_list_space_15)
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
