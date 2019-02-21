//
//  UIViewController+Extension.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/21.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit

extension UIViewController {
    /// 视图控制器 viewController 统一配置
    func viewControllerConfig() {
        self.edgesForExtendedLayout = .init(rawValue: 0)
        self.view.backgroundColor = color_background
    }
}
