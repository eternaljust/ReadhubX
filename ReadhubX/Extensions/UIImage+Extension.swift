//
//  UIImage+Extension.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/18.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit

extension UIImage {
    /// 无渲染模式的原图
    open class func originalImageNamed(name: String) -> UIImage {
        let image: UIImage = UIImage.init(named: name)!
        
        return image.withRenderingMode(.alwaysOriginal);
    }
    
    /// color 生成 image
    open class func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        UIGraphicsBeginImageContext(rect.size);
        let context: CGContext = UIGraphicsGetCurrentContext()!;
        
        context.setFillColor(color.cgColor);
        context.fill(rect);
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        
        return image
    }
    
    /// color 生成指定 size 大小的 image
    open class func imageWithColorSize(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size);
        let context: CGContext = UIGraphicsGetCurrentContext()!;
        
        context.setFillColor(color.cgColor);
        context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height));
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        
        return image
    }
}
