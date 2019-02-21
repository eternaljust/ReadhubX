//
//  BaseSafariViewController.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/21.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit
import SafariServices

/// safari 浏览ViewController
class BaseSafariViewController: SFSafariViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        preferredControlTintColor = color_theme
    }
}
