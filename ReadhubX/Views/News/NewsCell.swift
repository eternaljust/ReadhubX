//
//  NewsCell.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/18.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit

/// 资讯 cell
class NewsCell: UITableViewCell {
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
        contentView.addSubview(contentLabel)
        contentView.addSubview(infoLabel)
        
        layoutPageSubviews()
    }
    
    private func layoutPageSubviews() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(width_list_space_15)
            make.left.equalToSuperview().offset(width_list_space_15)
            make.right.equalToSuperview().offset(-width_list_space_15)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(width_list_space_15)
            make.left.right.equalTo(titleLabel)
            make.bottom.equalTo(infoLabel.snp.top).offset(-width_list_space_15)
        }
        
        infoLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-width_list_space_15)
            make.left.right.equalTo(titleLabel)
            make.height.equalTo(14)
        }
    }
    
    // MARK: - setter getter
    /// 资讯标题
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = font_17
        label.textColor = color_000000
        label.numberOfLines = 0
        
        return label
    }()
    
    /// 资讯内容
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        
        label.font = font_14
        label.textColor = color_353535
        label.numberOfLines = 0
        
        return label
    }()
    
    /// 详细描述
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        
        label.font = font_14
        label.textColor = color_888888
        
        return label
    }()
}
