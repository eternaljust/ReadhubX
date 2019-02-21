//
//  NavigationViewController.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/21.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit

/// 统一导航 NavigationViewController
class NavigationViewController: UINavigationController {
    /// 返回手势
    var fullScreenPopGesture: UIPanGestureRecognizer?
    
    // MARK: - life cycle
    override func viewDidLoad() {
        setFullScreenPopGesture()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(popVC))
            viewController.navigationItem.leftBarButtonItem?.tintColor = color_theme
        }
        super.pushViewController(viewController, animated: true)
    }
    
    // MARK: - event response
    @objc func popVC() {
        self.popViewController(animated: true)
    }
}

extension NavigationViewController {
    /// 解决自定义backItem后手势失效的问题，并修改为全屏返回
    private func setFullScreenPopGesture() {
        navigationBar.isTranslucent = false
        
        let target = self.interactivePopGestureRecognizer?.delegate
        let targetView = self.interactivePopGestureRecognizer!.view
        let handler: Selector = NSSelectorFromString("handleNavigationTransition:");
        let fullScreenGesture = UIPanGestureRecognizer(target: target, action: handler)
        
        fullScreenPopGesture = fullScreenGesture
        fullScreenGesture.delegate = self
        targetView?.addGestureRecognizer(fullScreenGesture)
        
        self.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
        return .none
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return topViewController?.preferredStatusBarStyle ?? .lightContent
    }
}

extension NavigationViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let disabled = (topViewController as? InteractivePopProtocol)?.disabled ?? false
        
        if children.count <= 1 {
            return false
        }
        
        // 手势响应区域
        let panGestureRecognizer = gestureRecognizer as! UIPanGestureRecognizer
        let location = panGestureRecognizer.location(in: view)
        let offset = panGestureRecognizer.translation(in: panGestureRecognizer.view)
        //        let ret = 0 < offset.x && location.x <= 40 // x < 40 可以响应返回手势
        //        let ret =  0 < offset.x && location.x < view.width // 全屏返回手势
        let area = disabled ? 30 : view.width
        let ret =  0 < offset.x && location.x < area
        
        return ret
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension UINavigationController {
    open override var previewActionItems : [UIPreviewActionItem] {
        if let items = topViewController?.previewActionItems {
            return items
        } else {
            return super.previewActionItems
        }
    }
}

protocol InteractivePopProtocol {
    var disabled: Bool { get }
}
