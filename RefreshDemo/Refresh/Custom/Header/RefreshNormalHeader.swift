//
//  RefreshNormalHeader.swift
//  Refresh
//
//  Created by 马磊 on 2019/1/14.
//  Copyright © 2019 MLCode.com. All rights reserved.
//

import UIKit

open class RefreshNormalHeader: RefreshStateHeader {
    
    public let arrowView: UIImageView = UIImageView()
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
        
        addSubview(arrowView)
        arrowView.image = UIImage.bundleImage(named: "arrow@2x")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        
        addSubview(loadingView)
        
    }
    
    open override func placeSubViews() {
        super.placeSubViews()
        
        // 箭头的中心点
        var arrowCenterX = self.frame.size.width * 0.5
        if !self.stateLabel.isHidden {
            let stateWidth = self.stateLabel.textWidth
            var timeWidth: CGFloat = 0.0
            if !self.lastUpdatedTimeLabel.isHidden {
                timeWidth = self.lastUpdatedTimeLabel.textWidth
            }
            let textWidth = max(stateWidth, timeWidth)
            arrowCenterX -= textWidth / 2 + self.labelLeftInset
        }
        let arrowCenterY = self.frame.size.height * 0.5
        let arrowCenter = CGPoint(x: arrowCenterX, y: arrowCenterY)
        
        // 箭头
        if self.arrowView.constraints.isEmpty {
            self.arrowView.frame.size = self.arrowView.image?.size ?? .zero
            self.arrowView.center = arrowCenter
        }
        
        // 圈圈
        if self.loadingView.constraints.isEmpty {
            self.loadingView.center = arrowCenter
        }
        
        self.arrowView.tintColor = self.stateLabel.textColor
        
    }
    
    public override var state: RefreshState {
        didSet {
            
            // 根据状态
            if state == .idle {
                if (oldValue == .refreshing) {
                    self.arrowView.transform = CGAffineTransform.identity
                    UIView.animate(withDuration: RefreshSlowAnimationDuration, animations: {
                        self.loadingView.alpha = 0.0
                        
                    }) { (_) in
                        // 如果执行完动画发现不是idle状态，就直接返回，进入其他状态
                        if self.state != .idle { return }
                        
                        self.loadingView.alpha = 1.0
                        self.loadingView.stopAnimating()
                        self.arrowView.isHidden = false
                    }
                } else {
                    self.loadingView.stopAnimating()
                    self.arrowView.isHidden = false
                    UIView.animate(withDuration: RefreshFastAnimationDuration, animations: {
                        self.arrowView.transform = CGAffineTransform.identity
                    })
                }
            } else if state == .pulling {
                loadingView.stopAnimating()
                self.arrowView.isHidden = false
                UIView.animate(withDuration: RefreshFastAnimationDuration, animations: {
                    self.arrowView.transform = CGAffineTransform.init(rotationAngle: 0.000001 - CGFloat(Double.pi))
                })
            } else if state == .refreshing {
                self.loadingView.alpha = 1.0 // 防止refreshing -> idle的动画完毕动作没有被执行
                self.loadingView.startAnimating()
                self.arrowView.isHidden = true
            }
        }
    }
    
}
