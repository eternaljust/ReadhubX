//
//  NewsModel.swift
//  ReadhubX
//
//  Created by Awro on 2019/2/19.
//  Copyright © 2019 EJ. All rights reserved.
//

import UIKit

struct NewsList : Codable {
    let data: [News]
    
    struct News: Codable {
        var title: String
        var summary: String
        var siteName: String
        var authorName: String?
        var publishDate: String
        var mobileUrl: String = ""
    }
}
