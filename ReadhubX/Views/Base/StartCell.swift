//
//  StartCell.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/18.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit

class StartCell: UITableViewCell {
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
        contentView.addSubview(infoLabel)
        
        layoutPageSubviews()
    }
    
    private func layoutPageSubviews() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(width_list_space_15)
            make.left.equalToSuperview().offset(width_large_button_space_34)
            make.height.equalTo(17)
        }

        infoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(width_list_space_15)
            make.left.equalTo(titleLabel)
            make.height.equalTo(14)
        }
    }
    
    // MARK: - setter getter
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = font_17
        label.textColor = color_000000
        
        return label
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        
        label.font = font_14
        label.textColor = color_353535
        
        return label
    }()
}
