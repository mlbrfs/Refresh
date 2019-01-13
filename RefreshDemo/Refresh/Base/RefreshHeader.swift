//
//  RefreshHeaderView.swift
//  RefreshDemo
//
//  Created by 马磊 on 2016/10/18.
//  Copyright © 2016年 MLCode.com. All rights reserved.
//

import UIKit

open class RefreshHeader: RefreshComponent {
    
    class func refreshing(_ refreshingCallback: (()->())?) -> RefreshHeader {
        let header = RefreshHeader()
        header.refreshingBlock = refreshingCallback
        return header
    }
    
    class func refresh(_ target: NSObject?, action: Selector?) -> RefreshHeader {
        let header = RefreshHeader()
        header.addRefreshingTarget(target, action: action)
        return header
    }
    
    /** 这个key用来存储上一次下拉刷新成功的时间 */
    let lastUpdatedTimeKey: String = RefreshHeaderTimeKey
    /** 上一次下拉刷新成功的时间 */
    open var lastUpdatedTime: Date? {
        return UserDefaults.standard.object(forKey: lastUpdatedTimeKey) as? Date
    }
    
    var insetTDelta: CGFloat = 0
    
    /** 忽略多少scrollView的contentInset的top */
    open var ignoredScrollViewContentInsetTop: CGFloat = 0
    
    open override func prepare() {
        super.prepare()
        
        frame.size.height = RefreshHeaderHeight

        
    }
    
    open override func placeSubViews() {
        super.placeSubViews()
        
        // 设置y值(当自己的高度发生改变了，肯定要重新调整Y值，所以放到placeSubviews方法中设置y值)
        self.frame.origin.y = -self.frame.size.height - self.ignoredScrollViewContentInsetTop
        
    }
    
    open override func scrollView(contentOffset changed: [NSKeyValueChangeKey : Any]?) {
        super.scrollView(contentOffset: changed)
        guard let scrollView = scrollView else {
            return
        }
        
        // 在刷新的refreshing状态
        switch state {
        case .refreshing:
            if self.window == nil { return }
            // sectionheader停留解决
            if let scrollViewOriginalInset = scrollViewOriginalInset {
                var insetT = max(-scrollView.contentOffset.y, scrollViewOriginalInset.top)
                insetT = min(insetT, frame.size.height + scrollViewOriginalInset.top)
                scrollView.contentInset.top = insetT
                insetTDelta = scrollViewOriginalInset.top - insetT
            } else {
                self.insetTDelta = scrollViewOriginalInset?.top ?? 0
            }
        default:
            // 跳转到下一个控制器时，contentInset可能会变
            scrollViewOriginalInset = scrollView.mlInset
            // 当前的contentOffset
            let offsetY = scrollView.contentOffset.y
            // 头部控件刚好出现的offsetY
            let happenOffsetY = -(scrollViewOriginalInset?.top ?? 0)
            // 如果是向上滚动到看不见头部控件，直接返回
            // >= -> >
            if offsetY > happenOffsetY { return }
            
            // 普通 和 即将刷新 的临界点
            let normal2pullingOffsetY = happenOffsetY - self.frame.size.height
            let pullingPercent = (happenOffsetY - offsetY) / self.frame.size.height
            
            if scrollView.isDragging { // 如果正在拖拽
                self.pullingPercent = pullingPercent
                if state == .idle, offsetY < normal2pullingOffsetY {
                    // 转为即将刷新状态
                    state = .pulling
                } else if state == .pulling, offsetY >= normal2pullingOffsetY {
                    // 转为普通状态
                    state = .idle;
                }
            } else if state == .pulling {// 即将刷新 && 手松开
                // 开始刷新
                beginRefreshing()
            } else if pullingPercent < 1 {
                self.pullingPercent = pullingPercent
            }
        }
    }
    
    public override var state: RefreshState {
        set {
            let oldValue = state
            if state == newValue { return }
            super.state = newValue
            
            switch newValue {
            case .idle:
                if oldValue != .refreshing { return }
                
                // 保存刷新时间
                UserDefaults.standard.set(Date(), forKey: lastUpdatedTimeKey)
                UserDefaults.standard.synchronize()
                
                // 恢复inset和offset
                UIView.animate(withDuration: RefreshSlowAnimationDuration, animations: { [weak self] in
                    self?.scrollView?.mlInset.top = ((self?.scrollView?.mlInset.top) ?? 0) + (self?.insetTDelta ?? 0)
                    // 自动调整透明度
                    if self?.isAutomaticallyChangeAlpha == true {
                        self?.alpha = 0.0
                    }
                }) { [weak self] (isFinished) in
                    self?.endRefreshingCompletionBlock?()
                }
                
            case .refreshing:
                DispatchQueue.main.async { [weak self] in
                    UIView.animate(withDuration: RefreshFastAnimationDuration, animations: {
                        if self?.scrollView?.panGestureRecognizer.state != .cancelled {
                            let top = (self?.scrollViewOriginalInset?.top ?? 0) + (self?.frame.size.height ?? 0)
                            // 增加滚动区域top
                            self?.scrollView?.mlInset.top = top
                            // 设置滚动位置
                            var offset = (self?.scrollView?.contentOffset) ?? .zero
                            offset.y = -top
                            self?.scrollView?.setContentOffset(offset, animated: false)
                        }
                    }, completion: { (isFinished) in
                        self?.executeRefreshingCallback()
                    })
                }
            default: break
            }
            
        }
        get {
            return super.state
        }
    }
    
}
