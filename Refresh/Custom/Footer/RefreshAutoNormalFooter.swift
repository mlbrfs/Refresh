//
//  RefreshAutoNormalFooter.swift
//  Refresh
//
//  Created by 马磊 on 2019/1/14.
//  Copyright © 2019 MLCode.com. All rights reserved.
//

import UIKit

open class RefreshAutoNormalFooter: RefreshAutoStateFooter {
    /** 菊花的样式 */
    open var activityIndicatorViewStyle: UIActivityIndicatorView.Style = .gray {
        didSet {
            loadingView.style = activityIndicatorViewStyle
        }
    }
    
    lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(style: activityIndicatorViewStyle)
        loadingView.hidesWhenStopped = true
        return loadingView
    }()
    
    open override func prepare() {
        super.prepare()
        
        addSubview(loadingView)
    }
    
    open override func placeSubViews() {
        super.placeSubViews()
        
        if !self.loadingView.constraints.isEmpty { return }
        
        // 圈圈
        var loadingCenterX = frame.size.width * 0.5
        if !isRefreshingTitleHidden {
            loadingCenterX -= stateLabel.textWidth * 0.5 + labelLeftInset
        }
        let loadingCenterY = frame.size.height * 0.5
        loadingView.center = CGPoint(x: loadingCenterX, y: loadingCenterY)
    }
    
    public override var state: RefreshState {
        didSet {
            // 根据状态做事情
            if state == .noMoreData || state == .idle {
                loadingView.stopAnimating()
            } else if state == .refreshing {
                loadingView.startAnimating()
            }
        }
    }
    
}
