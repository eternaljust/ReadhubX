//
//  TabBarViewController.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/18.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit
import PKHUD

/// tabBarViewController 
class TabBarViewController: UITabBarController {
    var lastDate: Date = Date()
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
        setAppearance()
        globalConfig()
        
        self.delegate = self
    }

    // MARK: - private method
    private func globalConfig() {
        HUD.dimsBackground = false
    }
    
    private func setAppearance() {
        // tabBar
        let tabBar = UITabBar.appearance();
        
        tabBar.isTranslucent = false;
        tabBar.backgroundColor = color_background;
        
        // tabbarItem
        let tabBarItem = UITabBarItem.appearance()
        
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font_13, NSAttributedString.Key.foregroundColor: color_888888], for: .normal)
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font_13, NSAttributedString.Key.foregroundColor: color_theme], for: .selected)
        
        /// 导航栏左右的 item 字体颜色
        let barButtonItem = UIBarButtonItem.appearance()

        barButtonItem.tintColor = color_theme
        barButtonItem.setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font_17, NSAttributedString.Key.foregroundColor: color_theme], for: .normal)
        barButtonItem.setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font_17, NSAttributedString.Key.foregroundColor: color_theme], for: .highlighted)

        // 导航栏 naviBar
        let naviBar = UINavigationBar.appearance();
        
        naviBar.barTintColor = color_ffffff
        naviBar.titleTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font_20, NSAttributedString.Key.foregroundColor: color_theme]
        
        // tableView cell 选中效果
        UITableViewCell.appearance().selectionStyle = .none
        UISwitch.appearance().onTintColor = color_theme
    }

    private func setupTabBar() {
        addChildViewController(childController: TopicViewController(),
                               title: "话题",
                               normalImage: #imageLiteral(resourceName: "topic"),
                               selectedImageName: #imageLiteral(resourceName: "topic_selected"))
        
        addChildViewController(childController: NewsViewController(),
                               title: "资讯",
                               normalImage: #imageLiteral(resourceName: "news"),
                               selectedImageName: #imageLiteral(resourceName: "news_selected"))
        
        addChildViewController(childController: MoreViewController(),
                               title: "更多",
                               normalImage: #imageLiteral(resourceName: "more"),
                               selectedImageName: #imageLiteral(resourceName: "more_selected"))
    }
    
    private func addChildViewController(childController: UIViewController, title: String, normalImage: UIImage?, selectedImageName: UIImage?) {
        childController.tabBarItem.image = normalImage?.withRenderingMode(.alwaysOriginal)
        childController.tabBarItem.selectedImage = selectedImageName?.withRenderingMode(.alwaysOriginal)
        
        // 图片居中显示，不显示文字
        let offset: CGFloat = iPad ? 0 : 5
        childController.tabBarItem.imageInsets = UIEdgeInsets(top: offset, left: 0, bottom: -offset, right: 0)
        let nav = NavigationViewController.init(rootViewController: childController)
        
        addChild(nav)
    }
}

// MARK: - UITabBarControllerDelegate
extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool{
        let vc = tabBarController.selectedViewController
        let date = NSDate()
        if vc == viewController {
            if date.timeIntervalSince1970 - lastDate.timeIntervalSince1970 <= 0.5 {
                switch tabBarController.selectedIndex {
                case 0:
                    NotificationCenter.default.post(Notification(name: .TabBarItemDidSelectedTopic))
                case 1:
                    NotificationCenter.default.post(Notification(name: .TabBarItemDidSelectedNews))
                default:
                    break
                }
                
                // 如果双击，就将 lastDate 置成一个较小的值，防止多次重复点击造成的方法重复调用
                lastDate = Date(timeIntervalSinceReferenceDate:1000) as Date
            } else {
                // 如果不是双击，记录最后一次点击时间
                lastDate = date as Date
            }
            return false
        } else {
            // 如果换了按钮点击，记录下最后一次点击时间
            lastDate = date as Date
        }
        return true
    }
}
