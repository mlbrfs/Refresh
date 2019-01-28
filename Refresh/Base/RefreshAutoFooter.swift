//
//  RefreshAutoFooter.swift
//  Refresh
//
//  Created by 马磊 on 2019/1/13.
//  Copyright © 2019年 MLCode.com. All rights reserved.
//

import UIKit

open class RefreshAutoFooter: RefreshFooter {
    
    /** 是否自动刷新(默认为YES) */
    open var isAutomaticallyRefresh: Bool = true
    
    /** 当底部控件出现多少时就自动刷新(默认为1.0，也就是底部控件完全出现时，才会自动刷新) */
    open var triggerAutomaticallyRefreshPercent: CGFloat = 1.0
    
    /** 是否每一次拖拽只发一次请求 */
    open var isOnlyRefreshPerDrag: Bool = false
    /** 一个新的拖拽 */
    var isOneNewPan: Bool = false
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if let _ = newSuperview {
            if !isHidden {
                scrollView?.mlInset.bottom += frame.size.height
            }
            
            // 设置位置
            self.frame.origin.y = scrollView?.contentSize.height ?? 0
        } else {
            if !isHidden {
                scrollView?.mlInset.bottom -= frame.size.height
            }
        }
    }
    
    open override func prepare() {
        super.prepare()
        
        // 默认底部控件100%出现时才会自动刷新
        triggerAutomaticallyRefreshPercent = 1.0
        // 设置为默认状态
        isAutomaticallyRefresh = true
        // 默认是当offset达到条件就发送请求（可连续）
        isOnlyRefreshPerDrag = false
    }
    
    open override func scrollView(contentOffset changed: [NSKeyValueChangeKey : Any]?) {
        super.scrollView(contentSize: changed)
        guard let changed = changed else { return }
        if state != .idle || !isAutomaticallyRefresh || frame.origin.y == 0 { return }
        
        guard let scrollView = scrollView else { return }
        if (scrollView.mlInset.top + scrollView.contentSize.height > scrollView.frame.size.height) { // 内容超过一个屏幕
            // 这里的_scrollView.mj_contentH替换掉self.mj_y更为合理
            if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height + self.frame.size.height * triggerAutomaticallyRefreshPercent + scrollView.mlInset.bottom - self.frame.size.height) {
                // 防止手松开时连续调用
                let old = (changed[NSKeyValueChangeKey.oldKey] as? CGPoint) ?? .zero
                let new = (changed[NSKeyValueChangeKey.newKey] as? CGPoint) ?? .zero
                if new.y <= old.y { return }
                // 当底部刷新控件完全出现时，才刷新
                beginRefreshing()
            }
        }
    }
    
    open override func scrollView(panState changed: [NSKeyValueChangeKey : Any]?) {
        super.scrollView(panState: changed)
        if state != .idle { return }
        guard let scrollView = scrollView else { return }
        switch scrollView.panGestureRecognizer.state {
        case .ended:
            if scrollView.mlInset.top + scrollView.contentSize.height <= scrollView.frame.size.height {  // 不够一个屏幕
                if (scrollView.contentOffset.y >= -scrollView.mlInset.top) { // 向上拽
                    beginRefreshing()
                }
            } else { // 超出一个屏幕
                if scrollView.contentOffset.y >= scrollView.contentSize.height + scrollView.mlInset.bottom - scrollView.frame.size.height {
                    beginRefreshing()
                }
            }
        case .began:
            isOneNewPan = true
        default:
            break
        }
    }
    
    open override func beginRefreshing(completion: (() -> ())? = nil) {
        if !isOneNewPan && isOnlyRefreshPerDrag { return }
        
        super.beginRefreshing(completion: completion)
        
        isOneNewPan = false
    }
    
    public override var state: RefreshState {
        didSet {
            if oldValue == state { return }
            if state == .refreshing {
                executeRefreshingCallback()
            } else if state == .noMoreData || state == .idle {
                if oldValue == .refreshing {
                    endRefreshingCompletionBlock?()
                }
            }
        }
    }
    
    open override var isHidden: Bool {
        didSet {
            if (!oldValue && isHidden) {
                state = .idle
                scrollView?.mlInset.bottom -= frame.size.height
            } else if oldValue && !isHidden {
                self.scrollView?.mlInset.bottom += frame.size.height
                                // 设置位置
                self.frame.origin.y = scrollView?.contentSize.height ?? 0
            }
            
        }
    }
    
}
