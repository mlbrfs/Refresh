//
//  RefreshComponent.swift
//  RefreshDemo
//
//  Created by 马磊 on 2016/10/18.
//  Copyright © 2016年 MLCode.com. All rights reserved.
//

import UIKit
import ObjectiveC

public enum RefreshState: Int {
    /** 闲置状态 */
    case idle
    /** 松开就可以刷新 */
    case pulling
    /** 正在刷新 */
    case refreshing
    /** 将要刷新 */
    case willRefresh
    /** 所有数据加载完毕，没有更多数据 */
    case noMoreData
}

open class RefreshComponent: UIView {
    /** 拉拽的百分比 */
    public var pullingPercent: CGFloat = 0 {
        didSet {
            if isRefreshing { return }
            if isAutomaticallyChangeAlpha {
                self.alpha = pullingPercent
            }
        }
    }
    /** 根据拖拽比例自动切换透明度 */
    public var isAutomaticallyChangeAlpha: Bool = false {
        didSet {
            if isRefreshing { return }
            self.alpha = isAutomaticallyChangeAlpha ? self.pullingPercent : 1.0
        }
    }
    /** 是否正在刷新 */
    public var isRefreshing: Bool {
        return state == .refreshing || state == .willRefresh
    }
    
    var refreshingTarget: NSObject?
    var refreshingAction: Selector?
    /** 刷新回调 */
    var refreshingBlock: (()->())?
    
    var beginRefreshingCompletionBlock: (()->())?
    var endRefreshingCompletionBlock: (()->())?
    
    /* 父控件 */
    weak var scrollView: UIScrollView?
    /** 开始刷新前的偏移量 */
    var scrollViewOriginalInset: UIEdgeInsets?
    /** scrollView 手势 */
    weak var pan: UIPanGestureRecognizer?
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func prepare() {
        // 基本属性
        self.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        self.backgroundColor = UIColor.clear
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        // 如果不是UIScrollView 就返回
        removeObservers()
        guard let newSuperview = newSuperview as? UIScrollView else {
            return
        }
        
        // 设置宽度
        self.frame.size.width = newSuperview.frame.size.width
        // 设置位置
        self.frame.origin.x = -(scrollView?.contentInset.left ?? 0)
        
        // 记录scrollView
        scrollView = newSuperview
        scrollView?.alwaysBounceVertical = true
        // 记录UIScrollView最开始的contentInset
        self.scrollViewOriginalInset = self.scrollView?.contentInset
        addObservers()
    }
    
    open override func layoutSubviews() {
        placeSubViews()
        super.layoutSubviews()
    }
    
    open func placeSubViews() { }
    
    func addObservers() {
        let options: NSKeyValueObservingOptions = [.new, .old]
        
        scrollView?.addObserver(self, forKeyPath: RefreshContentOffset, options: options, context: nil)
        scrollView?.addObserver(self, forKeyPath: RefreshContentSize, options: options, context: nil)
        pan = scrollView?.panGestureRecognizer
        pan?.addObserver(self, forKeyPath: RefreshPathPanState, options: options, context: nil)
    }
    
    /// 移除所有监听
    func removeObservers() {
        scrollView?.removeObserver(self, forKeyPath: RefreshContentOffset, context: nil)
        scrollView?.removeObserver(self, forKeyPath: RefreshContentSize, context: nil)
        pan?.removeObserver(self, forKeyPath: RefreshPathPanState, context: nil)
        pan = nil
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if !isUserInteractionEnabled { return }
        switch keyPath {
        case RefreshContentOffset:
            if self.isHidden { return }
            scrollView(contentOffset: change)
        case RefreshContentSize: // 这个就算看不见也需要处理
            scrollView(contentSize: change)
        case RefreshPathPanState:
            if self.isHidden { return }
            scrollView(panState: change)
        default: break
        }
        
    }
    
    public var state: RefreshState = .idle {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.layoutIfNeeded()
            }
        }
    }
    
    open func scrollView(contentSize changed: [NSKeyValueChangeKey : Any]?) { }
    open func scrollView(panState changed: [NSKeyValueChangeKey : Any]?) { }
    open func scrollView(contentOffset changed: [NSKeyValueChangeKey : Any]?) { }
    
    open func addRefreshingTarget(_ target: NSObject?, action: Selector?) {
        refreshingTarget = target
        refreshingAction = action
    }
    
    /** 进入刷新状态 */
    open func beginRefreshing(completion: (()->())? = nil) {
        
        beginRefreshingCompletionBlock = completion
        
        UIView.animate(withDuration: RefreshFastAnimationDuration) { [weak self] in
            self?.alpha = 1.0
        }
        pullingPercent = 1.0
        // 只要正在刷新，就完全显示
        if (self.window) != nil {
            state = .refreshing
        } else {
            // 预防正在刷新中时，调用本方法使得header inset回置失败
            if state != .refreshing {
                state = .willRefresh
                // 刷新(预防从另一个控制器回到这个控制器的情况，回来要重新刷新一下)
                setNeedsDisplay()
            }
        }
    }
    open func endRefresh(completion: (()->())? = nil) {
    
        endRefreshingCompletionBlock = completion
        DispatchQueue.main.async { [weak self] in
            self?.state = .idle
        }
    }
    
    open func executeRefreshingCallback() {
        DispatchQueue.main.async { [weak self] in
            self?.refreshingBlock?()
        }
        beginRefreshingCompletionBlock?()
        guard let refreshingAction = refreshingAction else {
            return
        }
        refreshingTarget?.perform(refreshingAction)
        
        
    }
    
}

public extension UILabel {
    
    class func mlLabel() -> UILabel {
        let label = UILabel()
        label.font = .mlFont
        label.textColor = .text
        label.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        return label
    }
    
    var textWidth: CGFloat {
        var stringWidth: CGFloat = 0
        let size = CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT))
        if let text = text, !text.isEmpty {
            if #available(iOS 7.0, *) {
            stringWidth = (text as NSString).boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil).size.width
            } else {
            stringWidth = (text as NSString).size(withAttributes: [NSAttributedString.Key.font : font]).width
            }
        }
        return stringWidth
    }
    
}
