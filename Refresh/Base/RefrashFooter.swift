//
//  RefrashFooterView.swift
//  RefreshDemo
//
//  Created by 马磊 on 2016/10/18.
//  Copyright © 2016年 MLCode.com. All rights reserved.
//

import UIKit

open class RefreshFooter: RefreshComponent {
    
    public required init(_ refreshingCallback: (()->())?) {
        super.init()
        refreshingBlock = refreshingCallback
    }
    public required init(_ target: Any?, action: Selector) {
        super.init()
        addRefreshingTarget(target, action: action)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /** 忽略多少scrollView的contentInset的bottom */
    var ignoredScrollViewContentInsetBottom: CGFloat = 0
    
    open override func prepare() {
        super.prepare()
        
        frame.size.height = RefreshFooterHeight
        
    }
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
//        guard let newSuperview = newSuperview else { return }
//        if let tableView = newSuperview as? UITableView {
//        } else if let collection = newSuperview as? UICollectionView {
//        }
        
    }
    
    /** 提示没有更多的数据 */
    open func endRefreshingWithNoMoreData() {
        DispatchQueue.main.async { [weak self] in
            self?.state = .noMoreData
        }
        
    }
    
    
    /** 重置没有更多的数据（消除没有更多数据的状态） */
    func resetNoMoreData() {
        DispatchQueue.main.async { [weak self] in
            self?.state = .idle
        }
        
    }
}
