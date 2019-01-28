//
//  RefreshBackFooter.swift
//  Refresh
//
//  Created by 马磊 on 2019/1/13.
//  Copyright © 2019年 MLCode.com. All rights reserved.
//

import UIKit

open class RefreshBackFooter: RefreshFooter {
    
    var lastRefreshCount: Int = 0
    var lastBottomDelta: CGFloat = 0
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        scrollView(contentSize: nil)
    }
    
    open override func scrollView(contentOffset changed: [NSKeyValueChangeKey : Any]?) {
        super.scrollView(contentOffset: changed)
        guard let scrollView = scrollView else { return }
        // 如果正在刷新，直接返回
        if state == .refreshing { return }
        
        scrollViewOriginalInset = scrollView.mlInset
        
        // 当前的contentOffset
        let currentOffsetY = scrollView.contentOffset.y
        // 尾部控件刚好出现的offsetY
        let happenOffsetY = self.happenOffsetY
        // 如果是向下滚动到看不见尾部控件，直接返回
        if currentOffsetY <= happenOffsetY { return }
        
        let pullingPercent = (currentOffsetY - happenOffsetY) / self.frame.size.height
        
        // 如果已全部加载，仅设置pullingPercent，然后返回
        if self.state == .noMoreData {
            self.pullingPercent = pullingPercent
            return
        }
        
        if scrollView.isDragging {
            self.pullingPercent = pullingPercent
            // 普通 和 即将刷新 的临界点
            let normal2pullingOffsetY = happenOffsetY + self.frame.size.height
            
            if self.state == .idle && currentOffsetY > normal2pullingOffsetY {
                // 转为即将刷新状态
                self.state = .pulling
            } else if state == .pulling && currentOffsetY <= normal2pullingOffsetY {
                // 转为普通状态
                self.state = .idle
            }
        } else if state == .pulling {// 即将刷新 && 手松开
            // 开始刷新
            beginRefreshing()
        } else if pullingPercent < 1 {
            self.pullingPercent = pullingPercent
        }
    }
    
    open override func scrollView(contentSize changed: [NSKeyValueChangeKey : Any]?) {
        super.scrollView(contentSize: changed)
        guard let scrollView = scrollView else { return }
        // 内容的高度
        let contentHeight = scrollView.contentSize.height + ignoredScrollViewContentInsetBottom
        // 表格的高度
        let scrollHeight = scrollView.frame.size.height - (scrollViewOriginalInset?.top ?? 0) - (scrollViewOriginalInset?.bottom ?? 0) + ignoredScrollViewContentInsetBottom
        // 设置位置和尺寸
        frame.origin.y = max(contentHeight, scrollHeight)
        
    }
    
    public override var state: RefreshState {
        didSet {
            if oldValue == state { return }
            
            // 根据状态来设置属性
            if state == .noMoreData || state == .idle {
                // 刷新完毕
                if oldValue == .refreshing  {
                    UIView.animate(withDuration: RefreshSlowAnimationDuration, animations: {
                        self.scrollView?.mlInset.bottom -= self.lastBottomDelta
                        // 自动调整透明度
                        if self.isAutomaticallyChangeAlpha { self.alpha = 0.0 }
                    }, completion: { (_) in
                        self.pullingPercent = 0.0
                        self.endRefreshingCompletionBlock?()
                    })
                }
                
                let deltaH = heightForContentBreakView()
                // 刚刷新完毕
                if oldValue == .refreshing && deltaH > 0 && self.scrollView?.mlTotalDataCount != self.lastRefreshCount {
                    self.scrollView?.contentOffset.y = self.scrollView?.contentOffset.y ?? 0
                }
            } else if (state == .refreshing) {
                // 记录刷新前的数量
                self.lastRefreshCount = self.scrollView?.mlTotalDataCount ?? 0
                
                UIView.animate(withDuration: RefreshFastAnimationDuration, animations: {
                    var bottom = self.frame.size.height + (self.scrollViewOriginalInset?.bottom ?? 0)
                    let deltaH = self.heightForContentBreakView()
                    if (deltaH < 0) { // 如果内容高度小于view的高度
                        bottom -= deltaH
                    }
                    self.lastBottomDelta = bottom - (self.scrollView?.mlInset.bottom ?? 0)
                    self.scrollView?.mlInset.bottom = bottom
                    self.scrollView?.contentOffset.y = self.happenOffsetY + self.frame.size.height
                }) { (_) in
                    self.executeRefreshingCallback()
                }
            }
        }
    }
    
    //MARK:  获得scrollView的内容 超出 view 的高度
    func heightForContentBreakView() -> CGFloat {
        guard let scrollView = scrollView else { return 0 }
        let h = scrollView.frame.size.height - (scrollViewOriginalInset?.bottom ?? 0) - (scrollViewOriginalInset?.top ?? 0)
        return scrollView.contentSize.height - h
    }
    //MARK: 刚好看到上拉刷新控件时的contentOffset.y
    var happenOffsetY: CGFloat {
        let deltaH = heightForContentBreakView()
        if (deltaH > 0) {
        return deltaH - (scrollViewOriginalInset?.top ?? 0)
    } else {
        return -(scrollViewOriginalInset?.top ?? 0)
    }
    }
    
}
