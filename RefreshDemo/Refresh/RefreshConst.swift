//
//  RefreshConst.swift
//  RefreshDemo
//
//  Created by 马磊 on 2016/10/18.
//  Copyright © 2016年 MLCode.com. All rights reserved.
//

import UIKit

let RefreshHeaderHeight: CGFloat = 54.0
let RefreshFooterHeight: CGFloat = 44.0

let RefreshSlowAnimationDuration = 0.4
let RefreshFastAnimationDuration = 0.25

let RefreshSlowDelayDuration = 200

let RefreshContentOffset: String = "contentOffset"
let RefreshContentSize: String = "contentSize"
let RefreshPathPanState: String = "state"
let RefreshHeaderTimeKey: String = "RefreshHeaderTime"

var RefreshHeaderPullToRefresh: String = "下拉可以刷新"
var RefreshHeaderReleaseToRefresh: String = "松开立即刷新"
var RefreshHeaderRefreshing: String = "正在帮你刷新数据..."

var RefreshFooterPullToRefresh: String = "上拉可以加载更多数据"
var RefreshFooterReleaseToRefresh: String = "松开立即加载更多数据"
var RefreshFooterRefreshing: String = "正在帮你加载数据..."


extension UIFont {
    static let mlFont = UIFont.systemFont(ofSize: 14)
}
extension UIColor {
    static let text = Color(90, 90, 90)
}

func Color(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1.0) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}
let DefaltColor: UIColor = Color(150, 150, 150, 1.0)


