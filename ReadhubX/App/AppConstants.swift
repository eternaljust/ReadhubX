//
//  AppConstants.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/18.
//  Copyright © 2019 EJ. All rights reserved.
//

import Foundation
import UIKit

// MARK: - macro
/// Debug 模式下打印 log
func DLog<T> (funcName: String = #function, line: Int = #line, file: String = #file, msg: T) {
    
    #if DEBUG
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.current
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    let strDate = dateFormatter.string(from: currentDate)
    let fileName = (file as NSString).lastPathComponent
    
    print("时间：\(strDate) 文件名: \(fileName) 函数名：func \(funcName) 第\(line)行: \(msg)")
    #endif
}

/// 字体大小
var FONT: (CGFloat) -> UIFont = { size in
    return UIFont.systemFont(ofSize: size);
}
/// RGB 进制颜色 + 透明
var RGBA: (CGFloat, CGFloat, CGFloat, CGFloat) -> UIColor = { red, green, blue, alpha in
    return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
}
/// RGB 进制颜色
var RGB: (CGFloat, CGFloat, CGFloat) -> UIColor = { red, green, blue in
    return RGBA(red, green, blue, 1)
}
/// 16 进制颜色 + 透明度
var HEXA: (NSInteger, CGFloat) -> UIColor = { hex, alpha in
    return UIColor(red: ((CGFloat)((hex & 0xff0000) >> 16))/255.0, green: ((CGFloat)((hex & 0xff00) >> 8))/255.0, blue: ((CGFloat)(hex & 0xff))/255.0, alpha: alpha)
}
/// 16 进制颜色
var HEX: (NSInteger) -> UIColor = { hex in
    return HEXA(hex, 1)
}

/// App 主 window 视图
let WINDOW = UIApplication.shared.delegate?.window
/// 系统屏幕
let SCREEN_SCALE = UIScreen.main.scale
let SCREEN_BOUNDS = UIScreen.main.bounds
/// 系统屏幕 宽
let SCREEN_WIDTH = SCREEN_BOUNDS.width
/// 系统屏幕 高
let SCREEN_HEIGHT = SCREEN_BOUNDS.height

/// 小屏幕
let iPhone5: Bool = (SCREEN_HEIGHT < 667)
/// 中屏幕
let iPhone6: Bool = (SCREEN_HEIGHT == 667)
/// 大屏幕
let iPhonePlus: Bool = (SCREEN_HEIGHT > 667)
/// iPhone X 屏幕
let iPhoneX: Bool = (SCREEN_HEIGHT == 812 || SCREEN_HEIGHT == 896)
/// iPad 屏幕
let iPad: Bool = UIDevice.current.userInterfaceIdiom == .pad

/// iPhoneX 状态栏高度
let iPhoneXStatusBarSafeMargin: CGFloat = 44
/// iPhoneX 底部横条高度
let iPhoneXTabBarSafeMargin: CGFloat = 34
/// 导航栏高函数
let naviBarHeightFunc: () -> CGFloat = {
    var height: CGFloat = 20 + 44
    
    if iPhoneX {
        height = iPhoneXStatusBarSafeMargin + 44
    }
    
    return height
}
/// 导航栏高度
let naviBarHeight: CGFloat = naviBarHeightFunc()

/// 系统版本号
let APP_VERSION: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
/// 系统构建版本
let APP_BUILD: String = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
/// App 的 bundle id 标识
let APP_ID: String = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String

// MARK: widht height corner
/// 大按钮的左右间距 34
let width_large_button_space_34: CGFloat = 34
/// 列表的左右间距 15
let width_list_space_15: CGFloat = 15
/// 中按钮宽度最小 180
let width_medium_button_180: CGFloat = 180
/// 小按钮宽度最小 60
let width_small_button_60: CGFloat = 60

/// 大按钮的固定高度 47
let height_large_button_47: CGFloat = 47
/// 中按钮的固定高度 35
let height_medium_button_35: CGFloat = 35
/// 小按钮的固定高度 30
let height_small_button_30: CGFloat = 30

/// 大按钮的圆角大小 5
let corner_large_button_5: CGFloat = 5
/// 中按钮的圆角大小 4
let corner_medium_button_4: CGFloat = 4
/// 小按钮的圆角大小 3
let corner_small_button_3: CGFloat = 3

// MARK: - color
/// 白色
let color_ffffff = HEX(0xffffff)
/// 主内容 balck 黑色
let color_000000 = HEX(0x000000)
/// 大段的说明内容而且属于主要内容 semi 黑
let color_353535 = HEX(0x353535)
/// 次要内容 grey 灰色
let color_888888 = HEX(0x888888)
/// 时间戳与表单缺省值 light 灰色
let color_b2b2b2 = HEX(0xb2b2b2)

/// 蓝色
let color_436a90 = HEX(0x436a90)
let color_436a90_20 = HEXA(0x436a90, 0.2)
let color_436a90_10 = HEXA(0x436a90, 0.1)

/// 红色
let color_e64340 = HEX(0xe64340)
let color_e64340_20 = HEXA(0xe64340, 0.2)
let color_e64340_10 = HEXA(0xe64340, 0.1)

/// 主题颜色
let color_theme = color_436a90
/// 警告颜色
let color_red = color_e64340
/// 页面背景颜色
let color_background = HEX(0xf6f6f6)
/// 下划线颜色
let color_line = HEX(0xe8e8e8)

// nomal 状态 100%，Press 与 Disable 状态分别降低透明度为 20% 与 10%。
/// 主题颜色按钮
let color_theme_button_normal = color_436a90
let color_theme_button_press = color_436a90_20
let color_theme_button_disable = color_436a90_10
/// 警告红色按钮
let color_red_button_normal = color_e64340
let color_red_button_press = color_e64340_20
let color_red_button_disable = color_e64340_10

// MARK: - font
/// 只能为阿拉伯数字信息，如金额、时间等
let font_40 = FONT(40)
/// 页面大标题，一般用于结果、空状态等信息单一页面
let font_20 = FONT(20)
/// 页面内大按钮字体，与按钮搭配使用
let font_18 = FONT(18)
/// 页面内首要层级信息，基准的，可以是连续的，如列表标题、消息气泡
let font_17 = FONT(17)
/// 页面内中按钮字体，与按钮搭配使用
let font_16 = FONT(16)
/// 页面内次要描述信息，服务于首要信息并与之关联，如列表摘要
let font_14 = FONT(14)
/// 页面辅助信息，需弱化的内容，如链接、小按钮
let font_13 = FONT(13)
/// 说明文本，如版权信息等不需要用户关注的信息
let font_11 = FONT(11)

/// 空字符串
let kNilValue = ""

/// App 相关的配置
struct AppConfig {
    /// URL Schemes
    static var URLScheme: String = "readhubx"
    /// 收件人邮箱
    static var receiverEmail: String = "eternal.just@gmail.com"
    /// 关于 Readhub 介绍
    static var readhubIntroURL: String = "https://mp.weixin.qq.com/s?__biz=MjM5ODIyMTE0MA==&mid=2650969398&idx=1&sn=70c44b9bb994d9a8d98453b97555890b"
    /// 项目源码
    static var appRepository: String = "https://github.com/tzqiang/ReadhubX"
}
