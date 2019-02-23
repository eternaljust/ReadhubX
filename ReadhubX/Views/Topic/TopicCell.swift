//
//  TopicCell.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/18.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit

/// 热门话题 cell
class TopicCell: UITableViewCell {
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(summaryLabel)
        
        layoutPageSubviews()
    }
    
    private func layoutPageSubviews() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(width_list_space_15)
            make.left.equalToSuperview().offset(width_list_space_15)
            make.right.equalTo(timeLabel.snp.left).offset(-width_list_space_15)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel)
            make.right.equalToSuperview().offset(-width_list_space_15)
            make.width.equalTo(60)
            make.height.equalTo(14)
        }
        
        summaryLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(width_list_space_15)
            make.left.equalTo(titleLabel)
            make.right.equalToSuperview().offset(-width_list_space_15)
            make.bottom.equalToSuperview().offset(-width_list_space_15)
        }
    }
    
    // MARK: - setter getter
    /// 热门话题标题
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = font_17
        label.textColor = color_000000
        label.numberOfLines = 0
        
        return label
    }()
    
    /// 热门话题摘要
    lazy var summaryLabel: UILabel = {
        let label = UILabel()
        
        label.font = font_14
        label.textColor = color_353535
        label.numberOfLines = 0
        
        return label
    }()
    
    /// 热门话题时间
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        
        label.font = font_14
        label.textColor = color_888888
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
}
