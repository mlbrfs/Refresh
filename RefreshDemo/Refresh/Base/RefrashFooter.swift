//
//  RefrashFooterView.swift
//  RefreshDemo
//
//  Created by 马磊 on 2016/10/18.
//  Copyright © 2016年 MLCode.com. All rights reserved.
//

import UIKit

open class RefreshFooter: RefreshComponent {
    
    class func refreshing(_ refreshingCallback: (()->())?) -> RefreshFooter {
        let footer = RefreshFooter()
        footer.refreshingBlock = refreshingCallback
        return footer
    }
    
    class func refresh(_ target: NSObject?, action: Selector?) -> RefreshFooter {
        let footer = RefreshFooter()
        footer.addRefreshingTarget(target, action: action)
        return footer
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
//    private var lastRefreshCount: Int = 0
//
//    class func footer() ->  RefreshFooterView {
//        return RefreshFooterView()
//    }
//
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.pullToRefreshText = RefreshFooterPullToRefresh
//        self.releaseToRefreshText = RefreshFooterReleaseToRefresh
//        self.refreshingText = RefreshFooterRefreshing
//    }
//
//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override open func layoutSubviews() {
//        super.layoutSubviews()
//
//        self.statusLabel.frame = self.bounds
//
//    }
//
//    override open func willMove(toSuperview newSuperview: UIView?) {
//        super.willMove(toSuperview: newSuperview)
//
//        self.superview?.removeObserver(self, forKeyPath: RefreshContentSize, context: nil)
//
//        newSuperview?.addObserver(self, forKeyPath: RefreshContentSize, options: .new, context: nil)
//
//        if newSuperview != nil {
//            self.adjustFrameWithContentSize()
//        }
//    }
//
//    private func adjustFrameWithContentSize() -> Void {
//
//        let contentHeight = scrollView!.contentSize.height
//
//        let scrollHeight = scrollView!.frame.size.height - scrollViewOriginalInset!.top - scrollViewOriginalInset!.bottom
//
//        self.frame.origin.y = contentHeight > scrollHeight ? contentHeight : scrollHeight
//
//    }
//
//    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//
//        // 不能交互就直接返回
//        if isUserInteractionEnabled == false || self.alpha <= 0.01 || self.isHidden {
//            return
//        }
//
//        if keyPath == RefreshContentSize {
//
//            self.adjustFrameWithContentSize()
//
//        } else if keyPath == RefreshContentOffset {
//
//            // 正在刷新返回
//            if self.state == .refreshing {
//                return
//            }
//
//            self.adjustStateWithContentOffset()
//
//        }
//    }
//
//    private func adjustStateWithContentOffset() -> Void {
//        // 当前的contentOffset
//        let currentOffsetY = scrollView!.contentOffset.y
//        // 尾部控件刚好出现的offsetY
//        let happenOffsetY = self.happenOffsetY()
//        // 如果是向下滚动到看不见尾部控件，直接返回
//        if currentOffsetY <= happenOffsetY {
//            return
//        }
//
//        if scrollView!.isDragging {
//            // 刷新临界点
//            let normal2pullingOffsetY = happenOffsetY + frame.size.height
//
//            if self.state == .normal && currentOffsetY > normal2pullingOffsetY {
//                // 即将刷新
//                self.state = .pulling
//            } else if state == .pulling && currentOffsetY <= normal2pullingOffsetY {
//                //
//                self.state = .normal
//            }
//        } else if self.state == .pulling {// 手松开 即将刷新
//            self.state = .refreshing
//        }
//    }
//
//    override public var state: RefreshState {
//        get {
//            return super.state
//        }
//        set {
//            if self.state == newValue {
//                return
//            }
//
//            let oldState = self.state
//
//            super.state = newValue
//
//            switch newValue {
//            case .normal:
//                if oldState == .refreshing {// 结束刷新
//
//                    self.arrowImage.transform = .init(rotationAngle: CGFloat(Double.pi))
//
//                    UIView.animate(withDuration: RefreshSlowAnimationDuration, animations: {
//
//                        self.scrollView!.contentInset.bottom = self.scrollViewOriginalInset!.bottom
//
//                    })
//                } else {//
//                    UIView.animate(withDuration: RefreshFastAnimationDuration, animations: {
//
//                        self.arrowImage.transform = .init(rotationAngle: CGFloat(Double.pi))
//
//                    })
//                }
//
//                let deltaH: CGFloat = heightForContentBreakView()
//                let currentCount: Int = totalDataCountInScrollView()
//                // 刚刷新完毕
//                if oldState == .refreshing && deltaH > 0 && currentCount != lastRefreshCount {
//                    scrollView!.contentOffset.y = scrollView!.contentOffset.y
//                }
//
//            case .pulling:
//                UIView.animate(withDuration: RefreshFastAnimationDuration, animations: {
//                    self.arrowImage.transform = .identity
//                })
//
//            case .refreshing:
//
//                lastRefreshCount = totalDataCountInScrollView()
//
//                UIView.animate(withDuration: RefreshFastAnimationDuration, animations: {
//
//                    var bottom: CGFloat = self.frame.size.height + self.scrollViewOriginalInset!.bottom
//                    let deltaH: CGFloat = self.heightForContentBreakView()
//
//                    if deltaH < 0 {
//                        bottom -= deltaH
//                    }
//
//                    self.scrollView!.contentInset.bottom = bottom
//
//                })
//            default:
//                break
//            }
//
//        }
//    }
//
//    private func totalDataCountInScrollView() -> Int {
//
//        var totalCount = 0
//        if scrollView!.classForCoder == UITableView.classForCoder() {
//
//            let tableView = scrollView  as! UITableView
//
//            for section: Int in 0 ..< tableView.numberOfSections {
//                totalCount += tableView.numberOfRows(inSection: section)
//            }
//        } else if scrollView!.classForCoder == UICollectionView.classForCoder() {
//
//            let collection = scrollView as! UICollectionView
//
//            for section: Int in 0 ..< collection.numberOfSections {
//                totalCount += collection.numberOfItems(inSection: section)
//            }
//        }
//
//        return totalCount
//    }
//
//    /**
//     *  获得scrollView的内容 超出 view 的高度
//     */
//    private func heightForContentBreakView() -> CGFloat {
//
//        let h = frame.size.height - scrollViewOriginalInset!.bottom - self.scrollViewOriginalInset!.top
//
//        return scrollView!.contentSize.height - h
//    }
//
//    /**
//     *  刚好看到上拉刷新控件时的contentOffset.y
//     */
//    private func happenOffsetY() -> CGFloat {
//
//        return 5
//
//    }
//
//}
//
