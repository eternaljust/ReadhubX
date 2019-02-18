//
//  UIView+Extension.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/18.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import UIKit

struct BorderSideType: OptionSet {
    let rawValue: Int
    
    static let all = BorderSideType(rawValue: 0)
    static let top = BorderSideType(rawValue: 1 << 0)
    static let bottom = BorderSideType(rawValue: 1 << 1)
    static let left = BorderSideType(rawValue: 1 << 2)
    static let shooting = BorderSideType(rawValue: 1 << 3)
    static let right = BorderSideType(rawValue: 1 << 4)
}

extension UIView {
    // MARK: - Position
    
    var top: CGFloat {
        get {
            return self.bounds.origin.y
        }
        set(top) {
            var frame = self.frame
            frame.origin.y = top
            self.frame = frame
        }
    }
    
    var left: CGFloat {
        get {
            return self.bounds.origin.x
        }
        set(left) {
            var frame = self.frame
            frame.origin.x = left
            self.frame = frame
        }
    }
    
    var bottom: CGFloat {
        get {
            return (self.frame.origin.y + self.frame.size.height)
        }
        set(bottom) {
            var frame = self.frame
            frame.origin.y = (bottom - self.frame.size.height)
            self.frame = frame
        }
    }
    
    var right: CGFloat {
        get {
            return (self.frame.origin.x + self.frame.size.width)
        }
        set(right) {
            var frame = self.frame
            frame.origin.x = (right - self.frame.size.width)
            self.frame = frame
        }
    }
    
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set(width) {
            var frame = self.frame
            frame.size.width = width
            self.frame = frame
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set(height) {
            var frame = self.frame
            frame.size.height = height
            self.frame = frame
        }
    }
    
    var origin: CGPoint {
        get {
            return self.frame.origin
        }
        set(origin) {
            var frame = self.frame
            frame.origin = origin
            self.frame = frame
        }
    }
    
    var size: CGSize{
        get {
            return self.frame.size
        }
        set(size) {
            var frame = self.frame
            frame.size = size
            self.frame = frame
        }
    }
    
    var centerX: CGFloat {
        get {
            return self.center.x
        }
        set(centerX) {
            var center = self.center
            center.x = centerX
            self.center = center
        }
    }
    
    var centerY: CGFloat {
        get {
            return self.center.y
        }
        set(centerY) {
            var center = self.center
            center.y = centerY
            self.center = center
        }
    }
    
    var minX: CGFloat {
        get {
            return self.left
        }
        set(minX) {
            self.left = minX
        }
    }
    
    var maxX: CGFloat {
        get {
            return self.left + self.width
        }
        set(maxX) {
            self.left = maxX - self.width
        }
    }
    
    var minY: CGFloat {
        get {
            return self.top
        }
        set(minY) {
            self.top = minY
        }
    }
    
    var maxY: CGFloat {
        get {
            return self.top + self.height
        }
        set(maxY) {
            self.top = maxY - self.height
        }
    }
    
    // MARK: - Corner
    
    /// view 去掉圆角
    func cornerNone() {
        if self.layer.mask != nil {
            self.layer.mask?.removeFromSuperlayer()
            self.layer.mask = nil
        }
    }
    
    /// view 添加圆角
    func cornerRadii(corners: UIRectCorner, radii: CGFloat) {
        var maskLayer: CAShapeLayer? = self.layer.mask as? CAShapeLayer
        
        if maskLayer == nil {
            maskLayer = CAShapeLayer.init()
            self.layer.mask = maskLayer
        }
        
        let path = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        maskLayer?.path = path.cgPath
    }
    
    // MARK: - BorderLine
    
    /// view 添加边框线
    func borderLine(color: UIColor, width: CGFloat, type: BorderSideType) {
        
        if type == .all {
            self.layer.borderWidth = width;
            self.layer.borderColor = color.cgColor;
            
            return;
        }
        
        let layer: CALayer = CALayer.init()
        
        layer.backgroundColor = color.cgColor;
        switch type {
        case .left:
            let frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
            layer.frame = frame;
        case .right:
            let frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
            layer.frame = frame;
        case .top:
            let frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
            layer.frame = frame;
        case .bottom:
            let frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
            layer.frame = frame;
        default:
            let frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
            layer.frame = frame;
        }
        
        self.layer.addSublayer(layer)
    }
}

