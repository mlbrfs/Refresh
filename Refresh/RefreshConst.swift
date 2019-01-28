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

let RefreshSlowAnimationDuration: TimeInterval = 0.4
let RefreshFastAnimationDuration: TimeInterval = 0.25

let RefreshLabelLeftInset: CGFloat = 25

//let RefreshSlowDelayDuration = 200

let RefreshContentOffset: String = "contentOffset"
let RefreshContentSize: String = "contentSize"
let RefreshPathPanState: String = "state"
let RefreshHeaderTimeKey: String = "RefreshHeaderTime"

//var RefreshHeaderPullToRefresh: String = "下拉可以刷新"
//var RefreshHeaderReleaseToRefresh: String = "松开立即刷新"
//var RefreshHeaderRefreshing: String = "正在帮你刷新数据..."
//
//var RefreshFooterPullToRefresh: String = "上拉可以加载更多数据"
//var RefreshFooterReleaseToRefresh: String = "松开立即加载更多数据"
//var RefreshFooterRefreshing: String = "正在帮你加载数据..."


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

extension UIImage {
    
    class func bundleImage(named name: String) -> UIImage? {
        return UIImage(contentsOfFile: (Bundle.current.path(forResource: name, ofType: "png"))!)
    }
}

extension Bundle {
    
    static var current: Bundle {
        let bundle =  Bundle(for: RefreshComponent.self)
        let path = bundle.path(forResource: "Refresh", ofType: "bundle")
        let currentBundle =  Bundle(path: path!)
        return currentBundle!
    }
    
    class func localizedString(for key: String, value: String? = nil) -> String {
        
        // （iOS获取的语言字符串比较不稳定）目前框架只处理en、zh-Hans、zh-Hant三种情况，其他按照系统默认处理
        var language: String
        language = Locale.preferredLanguages.first ?? "en"
        if language.hasPrefix("en") == true {
            language = "en"
        } else if language.hasPrefix("zh") == true  {
            if language.range(of: "Hans") != nil {
                language = "zh-Hans" // 简体中文
            } else {
                language = "zh-Hant" // 繁體中文
            }
        } else {
            language = "en"
        }
        // 从Refresh.bundle中查找资源
        let bundle = Bundle(path: current.path(forResource: language, ofType: "lproj")!)
        let str = bundle?.localizedString(forKey: key, value: value, table: nil) ?? key
        return str
    }
    
}

struct RefreshText {
    
    struct Header {
        static let idle = "RefreshHeaderIdleText"
        static let pulling = "RefreshHeaderPullingText"
        static let refreshing = "RefreshHeaderRefreshingText"
    }
    
    struct Footer {
        static let autoIdle = "RefreshAutoFooterIdleText"
        static let autoRefreshing = "RefreshAutoFooterRefreshingText"
        static let autoNoMoreData = "RefreshAutoFooterNoMoreDataText"
        
        static let backIdle = "RefreshBackFooterIdleText"
        static let backPulling = "RefreshBackFooterPullingText"
        static let backRefreshing = "RefreshBackFooterRefreshingText"
        static let backNoMoreData = "RefreshBackFooterNoMoreDataText"
    }
    
    struct Time {
        static let HeaderLastTime = "RefreshHeaderLastTimeText"
        static let HeaderDateToday = "RefreshHeaderDateTodayText"
        static let HeaderNoneLastDate = "RefreshHeaderNoneLastDateText"
    }
    
}
