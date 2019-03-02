//
//  NewsDetailCell.swift
//  ReadhubX
//
//  Created by Awro on 2019/3/2.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit

/// 资讯详情 cell
class NewsDetailCell: UITableViewCell {
    // MARK: - instance
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    // MARK: - private method
    private func setupUI() {
        contentView.addSubview(titleView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(summaryLabel)
        contentView.addSubview(timeLabel)

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
        
        summaryLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(width_list_space_15)
            make.left.right.equalTo(titleLabel)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(summaryLabel.snp.bottom).offset(width_list_space_15)
            make.left.equalTo(titleLabel)
            make.height.equalTo(14)
            make.bottom.equalToSuperview().offset(-width_list_space_15)
        }
    }
    
    // MARK: - setter getter
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
    
    /// 资讯标题
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = font_17
        label.textColor = color_theme
        label.numberOfLines = 2
        label.textAlignment = .center
        
        return label
    }()
    
    /// 资讯摘要
    lazy var summaryLabel: UILabel = {
        let label = UILabel()
        
        label.font = font_17
        label.textColor = color_353535
        label.numberOfLines = 0
        
        return label
    }()
    
    /// 资讯时间
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        
        label.font = font_14
        label.textColor = color_888888
        
        return label
    }()
}
