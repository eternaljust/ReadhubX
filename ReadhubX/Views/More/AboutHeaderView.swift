//
//  AboutHeaderView.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/21.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit

/// 关于 headerView
class AboutHeaderView: UIView {
    /// MARK: - instance
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
        addSubview(logoImageView)
        addSubview(versionLabel)
        
        layoutPageSubviews()
    }
    
    private func layoutPageSubviews() {
        logoImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(width_large_button_space_34)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
        
        versionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(logoImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(17)
        }
    }
    
    // MARK: - setter getter
    /// logo 图标
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.image = #imageLiteral(resourceName: "app_logo")
        
        return imageView
    }()
    
    /// 版本信息
    lazy var versionLabel: UILabel = {
        let label = UILabel()
        
        label.font = font_17
        label.textColor = color_888888
        
        return label
    }()
}
