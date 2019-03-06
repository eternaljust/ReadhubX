//
//  TopicDetailCell.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/23.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit

/// 话题详情 cell
class TopicDetailCell: UITableViewCell {
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
        contentView.addSubview(instantviewButton)
        contentView.addSubview(summaryLabel)
        
        layoutPageSubviews()
    }
    
    private func layoutPageSubviews() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(width_list_space_15)
            make.left.equalToSuperview().offset(width_list_space_15)
            make.right.equalToSuperview().offset(-width_list_space_15)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(width_list_space_15)
            make.left.equalTo(titleLabel)
            make.height.equalTo(14)
        }
        
        instantviewButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-width_list_space_15)
            make.centerY.equalTo(timeLabel)
            make.size.equalTo(CGSize(width: 32, height: 32))
        }
        
        summaryLabel.snp.makeConstraints { (make) in
            make.top.equalTo(timeLabel.snp.bottom).offset(20)
            make.left.right.equalTo(titleLabel)
            make.bottom.equalToSuperview().offset(-width_list_space_15)
        }
    }
    
    // MARK: - setter getter
    /// 话题标题
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = font_20
        label.textColor = color_000000
        label.numberOfLines = 0
        
        return label
    }()
    
    /// 话题摘要
    lazy var summaryLabel: UILabel = {
        let label = UILabel()
        
        label.font = font_17
        label.textColor = color_353535
        label.numberOfLines = 0
        
        return label
    }()
    
    /// 话题时间
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        
        label.font = font_14
        label.textColor = color_888888
        
        return label
    }()
    
    /// 话题的即时查看
    lazy var instantviewButton: UIButton = {
        let button = UIButton()
        
        button.setBackgroundImage(#imageLiteral(resourceName: "instantview"), for: .normal)
        
        return button
    }()
}

/// 话题详情媒体报道 相关事件 cell
class TopicDetailNewsTopicCell: UITableViewCell {
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
        contentView.addSubview(itemLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(infoLabel)
        
        layoutPageSubviews()
    }
    
    private func layoutPageSubviews() {
        itemLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(width_list_space_15)
            make.size.equalTo(CGSize(width: 6, height: 6))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(itemLabel.snp.right).offset(10)
            make.right.equalTo(infoLabel.snp.left).offset(-width_list_space_15)
        }
        
        infoLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.right.equalToSuperview().offset(-width_list_space_15)
            make.width.equalTo(70)
            make.height.equalTo(15)
        }
    }
    
    // MARK: - setter getter
    /// item 小圆圈
    lazy var itemLabel: UILabel = {
        let label = UILabel()
        
        label.backgroundColor = color_888888
        label.layer.cornerRadius = 3
        label.layer.masksToBounds = true
        
        return label
    }()
    
    /// 话题详情媒体报道 相关事件的标题
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = font_14
        label.textColor = color_353535
        label.numberOfLines = 2
        
        return label
    }()
    
    /// 话题详情媒体报道 相关事件的说明
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        
        label.font = font_14
        label.textColor = color_888888
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
}

/// 话题详情的 header
class TopicDetailHeader: UITableViewHeaderFooterView {
    // MARK: - instance
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    // MARK: - private method
    private func setupUI() {
//        contentView.backgroundColor = color_line
        contentView.addSubview(titleLabel)
        
        layoutPageSubviews()
    }
    
    private func layoutPageSubviews() {
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(width_list_space_15)
            make.height.equalTo(17)
        }
    }
    
    // MARK: - setter getter
    /// 媒体报道标题
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = font_17
        label.textColor = color_000000
        
        return label
    }()
}
