---
title: Readhub X - 每天三分钟的科技新闻聚合阅读
date: 2019-02-28 20:16:45
categories: 
- iOS
tags:
- iOS
- iOS.项目
- iOS.Swift
---

# Readhub X

Readhub X 是一款无码科技官方产品 Readhub 的第三方客户端。从 2.18 开始到今天 2.28 一个周期，差不多 10 天的空闲开发时间。下面做一下项目开发的回顾和总结。

## ☆简介
Readhub - 每天三分钟的科技新闻聚合阅读

Readhub 是由 [Fenng](https://weibo.com/fenng "小道消息") 的无码科技团队推出的科技新闻聚合阅读的网站，每天花几分钟了解一下互联网行业里发生的最值得关注的事情。

Readhub 主要功能如下：

【热门话题】
 互联网行业每天值得关注的事情

【科技动态】 
互联网行业的科技新闻报道

【开发者资讯】 
互联网行业里开发者关心的信息

【区块链快讯】 
 互联网行业区块链领域的实时要闻

【招聘行情】 
 互联网行业专业的招聘信息

## ☆目的
开发 Readhub X 的主要原因有四个：
1. Readhub 以 PC 端网页浏览为主，小程序端只有热门话题列表，没有资讯相关的列表。现在获取大部分的信息以手机为主，Readhub 没有官方的 App，网页在移动端的体验不是太完美。
2. Readhub 官网提供了一份由独立开发者开发和维护第三方应用，有移动端、Mac 端、浏览器插件和 IDE 版，Android 端有五六个第三方 App，暂时没有一个 iOS 端的第三方 App。
3. 马上 2019 年 6 月份的 WWDC 苹果开发者大会就要开始了，Swift 5 ABI 终于要稳定了，是时候重新把 Swift 捡起来，做个项目开发练练手了。
4. 希望 Readhub X 能顺利上架 App Store，能给有 Readhub 浏览新闻习惯的苹果小伙伴们提供一个好一点的阅读体验。

以上四个主要原因加上一些其他的心思，最终在 2.18 周一开始了搬砖之旅。

## ☆项目
Readhub X 的开发环境是 Swift 4.2 + Xcode 10.1，使用 CocoaPods 管理第三方开源库，用 Git 进行版本管理，并在 [GitHub](https://github.com/tzqiang/ReadhubX "Readhub X") 上开源。

Readhub X 的设计与 PC 端网页的布局和操作上大体风格一致，并针对移动端的浏览做了一些优化，使在手机浏览 Readhub 有更好的用户体验。

Readhub X 的主要功能有：
1. Readhub X 包含了热门话题、话题的详情浏览、话题的媒体报道列表、话题的相关事件和话题详情的即时查看等功能。
2. 资讯列表功能包括了科技动态、开发者资讯和区块链快讯三部分，资讯详情加载 webView 显示网站链接的详细内容，也加入了跳转 Safari 开启阅读模式优化阅读体验。
3. 设置页面包括了热门话题摘要和科技动态英文新闻的开关功能，方便小伙伴们的不同需求。浏览历史记录列表方便查看已经浏览的话题和资讯，针对热门话题列表和资讯列表，已经点击查看的字体有颜色变灰小提示。
4. 加入了应用图标长按 3D Touch 快速跳转热门话题、科技动态、开发者资讯和区块链快讯页面，也有 URL Shcemes 自动化快捷小功能。
5. 会不断的优化和更新新功能。

## ☆感谢
开发 Readhub X 的过程中，开源社区提供了很大的帮助，非常感谢。🙏

Readhub X 的 API 数据来源于 [bihe0832](https://github.com/bihe0832/readhub-android "readhub-android") 的收集整理，极大的方便了后续的开发者。

Readhub X 的话题详情即时查看功能参考 [BryantPang](https://github.com/BryantPang/ReadHub "ReadHub") 安卓端的 API 接口和 HTML 文本渲染。

Readhub X 的 Logo 来源于 https://readhub.cn 官方，应用图标大部分来源于[阿里巴巴矢量图标库](https://www.iconfont.cn/collections/detail?cid=14751)。

Readhub X 的项目开发框架以及部分灵感来源于 aidevjoe 的 [V2er](https://github.com/aidevjoe/V2EX "V2EX") 项目。

## ☆总结
Readhub X 的第一阶段的开发结束了，各方面都收获满满，十分开心。

前天第一次提交的审核被拒了，今天根据苹果爸爸的审核建议做了调整优化，提交了新的构建版本，希望 Readhub X 能够早点在 App Store 和大家见面。

期待 Readhub X 的慢慢成长。
