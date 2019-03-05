//
//  CollectionCell.swift
//  ReadhubX
//
//  Created by Awro on 2019/3/5.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit

/// 话题收藏 cell
class CollectionCell: UITableViewCell {
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
        
        layoutPageSubviews()
    }
    
    private func layoutPageSubviews() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(width_list_space_15)
            make.left.equalToSuperview().offset(width_list_space_15)
            make.right.equalToSuperview().offset(-width_list_space_15)
            make.bottom.equalToSuperview().offset(-width_list_space_15)
        }
    }
    
    // MARK: - setter getter
    /// 话题收藏标题
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = font_14
        label.textColor = color_353535
        label.numberOfLines = 3
        
        return label
    }()
}
