//
//  NewsViewController.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/18.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit
import JXSegmentedView

/// 资讯合集 ViewController
class NewsViewController: UIViewController {
    /// 分页视图
    var segmentedView: JXSegmentedView!
    /// 分页视图的数据源配置
    var segmentedDataSource: JXSegmentedTitleDataSource!
    /// 滚动视图
    var listContainerView: JXSegmentedListContainerView!
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllerConfig()
        
        setupSegmentedView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        segmentedView.frame = CGRect(x: 0, y: 0, width: view.width, height: 44)
        listContainerView.frame = CGRect.init(x: 0, y: 0, width: view.width, height: view.height)
    }
    
    // MARK: - private method
    private func setupSegmentedView() {
        // 1、初始化 JXSegmentedView
        segmentedView = JXSegmentedView()
        
        // 2、配置数据源
        // segmentedViewDataSource 一定要通过属性强持有！！！！！！！！！
        segmentedDataSource = JXSegmentedTitleDataSource()
        segmentedDataSource.isTitleColorGradientEnabled = true
        segmentedView.dataSource = segmentedDataSource
        segmentedDataSource.titleNormalFont = font_18
        segmentedDataSource.titleNormalColor = color_000000
        segmentedDataSource.titleSelectedColor = color_theme
        
        // 3、配置指示器
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.lineStyle = .lengthen
        indicator.indicatorColor = color_theme
        segmentedView.indicators = [indicator]
        
        // 4、配置 JXSegmentedView 的属性
        segmentedView.isContentScrollViewClickTransitionAnimationEnabled = false
        segmentedView.delegate = self
        navigationItem.titleView = segmentedView
        
        // 5、初始化 JXSegmentedListContainerView
        listContainerView = JXSegmentedListContainerView(dataSource: self)
        listContainerView.didAppearPercent = 0.9
        view.addSubview(listContainerView)
        
        // 6、将 listContainerView.scrollView和segmentedView.contentScrollView 进行关联
        segmentedView.contentScrollView = listContainerView.scrollView
        
        // 一定要统一 segmentedDataSource、segmentedView、listContainerView 的 defaultSelectedIndex
        segmentedDataSource.titles = [ AppConfig.moduleNews, AppConfig.moduleTechnews, AppConfig.moduleBlockchain ]
        // reloadData(selectedIndex:) 一定要调用
        segmentedDataSource.reloadData(selectedIndex: 0)
        
        segmentedView.defaultSelectedIndex = 0
        segmentedView.reloadData()
        
        listContainerView.defaultSelectedIndex = 0
        listContainerView.reloadData()
    }
}

// MARK: - JXSegmentedViewDelegate
extension NewsViewController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        // 传递 didClickSelectedItemAt 事件给 listContainerView，必须调用！！！
        listContainerView.didClickSelectedItem(at: index)
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat) {
        // 传递 scrollingFrom 事件给 listContainerView，必须调用！！！
        listContainerView.segmentedViewScrolling(from: leftIndex, to: rightIndex, percent: percent, selectedIndex: segmentedView.selectedIndex)
    }
}

// MARK: - JXSegmentedListContainerViewDataSource
extension NewsViewController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return segmentedDataSource.dataSource.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        let vc = NewsListViewController()
        
        vc.viewController = self
        vc.listIndex = index
        
        return vc
    }
}
