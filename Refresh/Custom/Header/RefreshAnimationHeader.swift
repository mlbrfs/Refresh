//
//  RefreshAnimationHeader.swift
//  Refresh
//
//  Created by 马磊 on 2019/1/14.
//  Copyright © 2019 MLCode.com. All rights reserved.
//

import UIKit

open class RefreshAnimationHeader: RefreshStateHeader {
    
    public let animationView = UIImageView()
    
    public private(set) var stateImages: [RefreshState: [UIImage]] = [:]
    public private(set) var stateDurations: [RefreshState: TimeInterval] = [:]
    /** 设置state状态下的动画图片images 动画持续时间duration */
    open func set(images: [UIImage], duration: TimeInterval = 0, state: RefreshState) {
        
        stateImages[state] = images
        if duration == 0 {
            stateDurations[state] = TimeInterval(images.count) * 0.1
        } else {
            stateDurations[state] = duration
        }
        
    }
    
    open override func prepare() {
        super.prepare()
        
        addSubview(animationView)
        labelLeftInset = 20
    }
    
    public override var pullingPercent: CGFloat {
        didSet {
            guard let images = self.stateImages[.idle], state == .idle else { return }
            // 停止动画
            animationView.stopAnimating()
            // 设置当前需要显示的图片
            var index =  Int(CGFloat(images.count) * pullingPercent)
            if index >= images.count {
                index = images.count - 1
            }
            animationView.image = images[index]
        }
    }
    
    open override func placeSubViews() {
        super.placeSubViews()
        
        if !self.animationView.constraints.isEmpty { return }
        
        self.animationView.frame = self.bounds
        if self.stateLabel.isHidden && self.lastUpdatedTimeLabel.isHidden {
            self.animationView.contentMode = .center
        } else {
            self.animationView.contentMode = .right
            
            let stateWidth = self.stateLabel.textWidth
            var timeWidth: CGFloat = 0.0
            if !self.lastUpdatedTimeLabel.isHidden {
                timeWidth = self.lastUpdatedTimeLabel.textWidth
            }
            let textWidth = max(stateWidth, timeWidth)
            self.animationView.frame.size.width = self.frame.size.width * 0.5 - textWidth * 0.5 - self.labelLeftInset
        }
    }
    
    public override var state: RefreshState {
        didSet {
            
            // 根据状态调整UI
            if state == .pulling || state == .refreshing {
                guard let images = stateImages[state], images.isEmpty else { return }
                animationView.stopAnimating()
                if images.count == 1 { // 单张图片
                    animationView.image = images.first
                } else { // 多张图片
                    animationView.animationImages = images
                    animationView.animationDuration = stateDurations[state] ?? TimeInterval(images.count) * 0.1
                    animationView.startAnimating()
                }
            } else if state == .idle {
                animationView.stopAnimating()
            }
        }
    }
    
}
