//
//  UIScrollView+Refresh.swift
//  RefreshDemo
//
//  Created by 马磊 on 2016/10/18.
//  Copyright © 2016年 MLCode.com. All rights reserved.
//

import UIKit

extension UIScrollView  {
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
    
    private struct AssociatedKeys {
        static var header:RefreshHeaderView?
        static var footer:RefreshFooterView?
    }
    // 1.1 添加属性  头部刷新控件
    var header: RefreshHeaderView?  {
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.header, newValue, .OBJC_ASSOCIATION_ASSIGN)
            }
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.header) as! RefreshHeaderView?
        }
    }
    // 1.2 添加属性  底部刷新控件
    var footer: RefreshFooterView?  {
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.footer, newValue, .OBJC_ASSOCIATION_ASSIGN)
            }
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.footer) as! RefreshFooterView?
        }
    }
    
    private func addHeader() -> Void {
        if self.header == nil {
            let headerView: RefreshHeaderView = RefreshHeaderView.header()
            self.addSubview(headerView)
            self.header = headerView
        }
    }
    
    private func addfooter() -> Void {
        if self.footer == nil {
            let footerView: RefreshFooterView = RefreshFooterView.footer()
            self.addSubview(footerView)
            self.footer = footerView
        }
    }
    // 2 增加添加头部func带回调
    public func addHeaderCallBack(_ callback:(()-> Void)?)  -> Void  {
        addHeader()
        self.header!.startRefreshingCallback = callback
        
    }
    public func addFooterCallBack(_ callback:(()-> Void)?)  -> Void  {
        addfooter()
        self.footer!.startRefreshingCallback = callback
    }
    //2.5 添加事件响应
    public func addHeaderWithTarget(_ target: Any , action: Selector) {
        addHeader()
        self.header?.startRefreshingTaget = target
        self.header?.startRefreshingAction = action
    }
    public func addFooterWithTarget(_ target: Any , action: Selector) {
        addfooter()
        self.footer?.startRefreshingTaget = target
        self.footer?.startRefreshingAction = action
    }
    // 3 增加开始刷新
    public func startHeaderRefresh()  -> Void {
        addHeader()
        header!.startRefreshing()
    }
    public func startFooterRefresh()  -> Void {
        addfooter()
        footer!.startRefreshing()
    }
    // 3 增加结束刷新
    public func endHeaderRefresh() -> Void {
        header?.endRefreshing()
    }
    public func endFooterRefresh() -> Void {
        footer?.endRefreshing()
    }
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

