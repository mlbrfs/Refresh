//
//  ML.swift
//  Refresh
//
//  Created by 马磊 on 2019/1/13.
//  Copyright © 2019年 MLCode.com. All rights reserved.
//

import UIKit

public protocol RefreshCompatible: class { }

public extension RefreshCompatible {
    /// A proxy which hosts reactive extensions for `self`.
    /// Gets a namespace holder for Kingfisher compatible types.
    public var ml: RefreshWrapper<Self> {
        get { return RefreshWrapper(self) }
        set { }
    }
    
}

public struct RefreshWrapper<Base> {
    public let base: Base
    
    // Construct a proxy.
    //
    // - parameters:
    //   - base: The object to be proxied.
    fileprivate init(_ base: Base) {
        self.base = base
    }
}

public extension RefreshWrapper where Base: UIScrollView {
    /*
     1 添加属性  头部刷新控件
     2 增加添加头部func - 增加添加头部func带回调
     2.5 添加响应事件
     3 增加开始刷新  增加结束刷新
     4 增量
     1> 是否正在刷新
     2> 刷新控件文案
     5 删除头部控件
     */
    // 1.1 添加属性  头部刷新控件
    public var header: RefreshHeader? {
        set {
            base.header = newValue
        }
        get {
            return base.header
        }
    }
    // 1.2 添加属性  底部刷新控件
    public var footer: RefreshFooter?  {
        set {
            base.footer = newValue
        }
        get {
            return base.footer
        }
    }
    
//    private mutating func addHeader() {
//        if header == nil {
//            let headerView: RefreshHeader = RefreshHeaderView.header()
//            base.addSubview(headerView)
//            header = headerView
//        }
//    }
//
//    private mutating func addfooter() {
//        if footer == nil {
//            let footerView: RefreshFooter = RefreshFooterView.footer()
//            base.addSubview(footerView)
//            footer = footerView
//        }
//    }
//    // 2 增加添加头部func带回调
//    public mutating func addHeaderCallBack(_ callback:(()-> Void)?)  -> Void  {
//        addHeader()
//        header!.startRefreshingCallback = callback
//
//    }
//    public mutating func addFooterCallBack(_ callback:(()-> Void)?)  -> Void  {
//        addfooter()
//        footer!.startRefreshingCallback = callback
//    }
//    //2.5 添加事件响应
//    public mutating func addHeaderWithTarget(_ target: Any , action: Selector) {
//        addHeader()
//        header?.startRefreshingTaget = target
//        header?.startRefreshingAction = action
//    }
//    public mutating func addFooterWithTarget(_ target: Any , action: Selector) {
//        addfooter()
//        footer?.startRefreshingTaget = target
//        footer?.startRefreshingAction = action
//    }
//    // 3 增加开始刷新
//    public mutating func startHeaderRefresh()  -> Void {
//        addHeader()
//        header!.startRefreshing()
//    }
//    public mutating func startFooterRefresh()  -> Void {
//        addfooter()
//        footer!.startRefreshing()
//    }
//    // 3 增加结束刷新
//    public func endHeaderRefresh() -> Void {
//        header?.endRefreshing()
//    }
//    public func endFooterRefresh() -> Void {
//        footer?.endRefreshing()
//    }
    // 4.1> 是否正在刷新
    public var isHeaderRefreshing: Bool {
        get {
            return header == nil ? false : header!.isRefreshing
        }
    }
    public var isFooterRefreshing: Bool {
        get {
            return footer == nil ? false : footer!.isRefreshing
        }
    }
    // 4.2> 刷新控件文案
    public var headerPullToRefreshText: String {
        get {
            return RefreshHeaderPullToRefresh
        }
        set {
            RefreshHeaderPullToRefresh = newValue
        }
    }
    public var headerReleaseToRefreshText: String {
        get {
            return RefreshHeaderReleaseToRefresh
        }
        set {
            RefreshHeaderReleaseToRefresh = newValue
        }
    }
    public var headerRefreshingText: String {
        get {
            return RefreshHeaderRefreshing
        }
        set {
            RefreshHeaderRefreshing = newValue
        }
    }
    
    public var footerPullToRefreshText: String {
        get {
            return RefreshFooterPullToRefresh
        }
        set {
            RefreshFooterPullToRefresh = newValue
        }
    }
    public var footerReleaseToRefreshText: String {
        get {
            return RefreshFooterReleaseToRefresh
        }
        set {
            RefreshFooterReleaseToRefresh = newValue
        }
    }
    public var footerRefreshingText: String {
        get {
            return RefreshFooterRefreshing
        }
        set {
            RefreshFooterRefreshing = newValue
        }
    }
    
    // 5 删除头部控件
    public func removerHeader() -> Void {
        header?.removeFromSuperview()
    }
    
    public func removerFooter() -> Void {
        footer?.removeFromSuperview()
    }
    
    
}

// scrollView 添加属性
extension UIScrollView: RefreshCompatible {
    
}

