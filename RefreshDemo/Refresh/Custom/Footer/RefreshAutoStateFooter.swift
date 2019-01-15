//
//  File.swift
//  Refresh
//
//  Created by 马磊 on 2019/1/14.
//  Copyright © 2019 MLCode.com. All rights reserved.
//

import UIKit

open class RefreshAutoStateFooter: RefreshAutoFooter {
    
    /** 文字距离圈圈、箭头的距离 */
    open var labelLeftInset: CGFloat = RefreshLabelLeftInset
    /** 显示刷新状态的label */
    public let stateLabel: UILabel = UILabel.mlLabel()
    
    public private(set) var stateTitles: [RefreshState: String] = [:]
    
    /** 设置state状态下的文字 */
    open func set(title: String, state: RefreshState) {
        
        stateTitles[state] = title
        stateLabel.text = stateTitles[self.state]
        
    }
    /** 隐藏刷新状态的文字 */
    open var isRefreshingTitleHidden: Bool = false
    
    open override func prepare() {
        super.prepare()
        
        addSubview(stateLabel)
        
        // 初始化文字
        set(title: "上拉刷新", state: .idle)
        set(title: "正在努力刷新中", state: .refreshing)
        set(title: "没有更多数据了", state: .noMoreData)
        
        // 监听label
        stateLabel.isUserInteractionEnabled = true
        stateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(stateLabelClick)))
        
    }
    
    @objc private func stateLabelClick() {
        if state == .idle {
            beginRefreshing()
        }
    }
    
    open override func placeSubViews() {
        super.placeSubViews()
        
        if !stateLabel.constraints.isEmpty { return }
        // 状态标签
        stateLabel.frame = bounds
    }
    
    public override var state: RefreshState {
        didSet {
            if oldValue == state { return }
            if isRefreshingTitleHidden && state == .refreshing {
                stateLabel.text = nil
            } else {
                stateLabel.text = stateTitles[state]
            }
        }
    }
    
}
