//
//  AppDelegate.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/18.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit

@UIApplicationMain

/// App 代理类
class AppDelegate: UIResponder, UIApplicationDelegate {
    /// 主 window
    var window: UIWindow?
    /// 当前根视图控制器
    var rootViewController: UITabBarController?
    
    // MARK: - UIApplicationDelegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 初始化 主 window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = TabBarViewController()
        rootViewController = (window?.rootViewController as! TabBarViewController)
        window?.makeKeyAndVisible()
        
        /// 第一次或者更新版本之后打开 App
        let vc = StartViewController()
        
        vc.callBack = {
            // 存储当前的构建版本
            UserDefaults.standard.setValue(APP_BUILD, forKey: AppConfig.build)
        }
        
        // 当前 App 的构建版本
        let build = UserDefaults.standard.string(forKey: AppConfig.build)
        
        if build == nil || build != APP_BUILD {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                // 显示开始使用界面
                self.rootViewController?.present(vc, animated: false, completion: nil)
            }
        }
        
        // 3D Touch ShortcutItem
        let shortcutItems: [UIApplicationShortcutItem] = [
            UIApplicationShortcutItem(type: AppConfig.shortcutItemTopic, localizedTitle: AppConfig.moduleTopic, localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: .home), userInfo: nil),
            UIApplicationShortcutItem(type: AppConfig.shortcutItemNews, localizedTitle: AppConfig.moduleNews, localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: .bookmark), userInfo: nil),
            UIApplicationShortcutItem(type: AppConfig.shortcutItemTechnews, localizedTitle: AppConfig.moduleTechnews, localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: .bookmark), userInfo: nil),
            UIApplicationShortcutItem(type: AppConfig.shortcutItemBlockchain, localizedTitle: AppConfig.moduleBlockchain, localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: .bookmark), userInfo: nil),
        ]
        
        UIApplication.shared.shortcutItems = shortcutItems
        
        return true
    }

    // MARK: - event response
    private func topic() {
        rootViewController?.selectedIndex = 0
        
        let navi: NavigationViewController = rootViewController?.selectedViewController as! NavigationViewController
        // App 当前正在查看话题详情
        navi.popToRootViewController(animated: false)
    }
    
    private func news(selectedIndex: Int) {
        rootViewController?.selectedIndex = 1
        
        let navi: NavigationViewController = rootViewController?.selectedViewController as! NavigationViewController
        let newsVC: NewsViewController = navi.topViewController as! NewsViewController
        // App 当前正在浏览资讯，可能资讯导航跳转了 safariVC
        navi.dismiss(animated: false, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            newsVC.segmentedView.selectItemAt(index: selectedIndex)
            newsVC.listContainerView.didClickSelectedItem(at: selectedIndex)
        }
    }
}

// MARK: - URL Schemes
extension AppDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // 有可能第一次或者版本更新之后首次打开 App 展示的开始使用界面
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.rootViewController?.presentedViewController?.dismiss(animated: false, completion: nil)
        }
        
        let host: String = url.host!
        
        switch host {
        case AppConfig.URLSchemeTopic:
            topic()
        case AppConfig.URLSchemeNews:
            news(selectedIndex: 0)
        case AppConfig.URLSchemeTechnews:
            news(selectedIndex: 1)
        case AppConfig.URLSchemeBlockchain:
            news(selectedIndex: 2)
        default:
            topic()
        }
        
        return true
    }
}

// MARK: - ShortcutItem
extension AppDelegate {
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        switch shortcutItem.type {
        case AppConfig.shortcutItemTopic:
            topic()
        case AppConfig.shortcutItemNews:
            news(selectedIndex: 0)
        case AppConfig.shortcutItemTechnews:
            news(selectedIndex: 1)
        case AppConfig.shortcutItemBlockchain:
            news(selectedIndex: 2)
        default:
            topic()
        }
    }
}
