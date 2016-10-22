//
//  RefreshHeaderView.swift
//  RefreshDemo
//
//  Created by 马磊 on 2016/10/18.
//  Copyright © 2016年 MLCode.com. All rights reserved.
//

import UIKit

class RefreshHeaderView: RefreshComponent {
    
    class func header () -> RefreshHeaderView {
        return RefreshHeaderView()
    }
    
    private var _lastUpdateTime: Date?
    private var lastUpdateTime: Date? {
        set {
            self._lastUpdateTime = newValue
            UserDefaults.standard.set(newValue, forKey: RefreshHeaderTimeKey)
            UserDefaults.standard.synchronize()
            self.updateTimeLabel()
        }
        get {
            return self._lastUpdateTime
        }
    }
    
    lazy private var lastUpdateTimeLabel: UILabel = {
        let label: UILabel = UILabel()
        label.autoresizingMask = .flexibleWidth
        label.font = UIFont.boldSystemFont(ofSize: RefreshTextSize)
        label.textColor = DefaltColor
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        self.addSubview(label)
        //这句话为了防止无限循环 - 懒加载的机制 属性没有值时自动调用懒加载赋值
        //        self.lastUpdateTimeLabel = label
        //        self.lastUpdateTime = UserDefaults.standard.object(forKey: RefreshHeaderTimeKey) as! Date?
        return label
    }()
    
    
    override var state: RefreshState {
        get {
            return super.state
        }
        set {
            if self.state == newValue {return}
            
            let oldState = self.state
            
            super.state = newValue
            
            switch newValue {
            case .normal: // 下拉可以刷新
                if oldState == .refreshing {// 刷新完毕
                    // 图片的变化
                    arrowImage.transform = .identity
                    
                    self.lastUpdateTime = Date()
                    
                    UIView.animate(withDuration: RefreshSlowAnimationDuration, animations: {
                        self.scrollView!.contentInset.top -= self.frame.size.height
                    })
                    
                } else {
                    // 动画
                    UIView.animate(withDuration: RefreshSlowAnimationDuration, animations: {
                        self.arrowImage.transform = .identity
                    })
                    
                }
                
            case .pulling:
                UIView.animate(withDuration: RefreshSlowAnimationDuration, animations: {
                    self.arrowImage.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
                })
            case .refreshing:
                UIView.animate(withDuration: RefreshSlowAnimationDuration, animations: {
                    //增加滚动区域
                    let top: CGFloat = self.scrollViewOriginalInset!.top + self.frame.size.height
                    self.scrollView!.contentInset.top = top
                    // 设置滚动位置
                    self.scrollView!.contentOffset.y = -top
                })
                
            default:
                break
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.pullToRefreshText = RefreshHeaderPullToRefresh
        self.releaseToRefreshText = RefreshHeaderReleaseToRefresh
        self.refreshingText = RefreshHeaderRefreshing
        self.lastUpdateTime = UserDefaults.standard.object(forKey: RefreshHeaderTimeKey) as! Date?
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let statusX: CGFloat = 0
        let statusY: CGFloat = 0
        let statusHeight: CGFloat = self.bounds.size.height * 0.5
        let statusWidth: CGFloat = self.bounds.size.width
        self.statusLabel.frame = CGRect(x: statusX, y: statusY, width: statusWidth, height: statusHeight)
        
        let lastUpdateY: CGFloat = statusHeight
        let lastUpdateX: CGFloat = 0
        let lastUpdateHeight: CGFloat = statusHeight
        let lastUpdateWidth: CGFloat = statusWidth
        self.lastUpdateTimeLabel.frame = CGRect(x: lastUpdateX, y: lastUpdateY, width: lastUpdateWidth, height: lastUpdateHeight)
        
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        self.frame.origin.y = -self.frame.size.height
    }
    
    /* KVO监听属性变化 */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // 不能交互就直接返回
        if isUserInteractionEnabled == false || self.alpha <= 0.01 || self.isHidden {
            return
        }
        // 正在刷新返回
        if self.state == .refreshing {
            return
        }
        
        if keyPath == RefreshContentOffset {
            adjustStateWithContentOffset()
        }
    }
    
    /**
     调整状态
     */
    private func adjustStateWithContentOffset()  {
        let currentOffsetY = scrollView!.contentOffset.y
        // 头部控件刚好出现的offsetY
        let happenOffsetY = -scrollView!.scrollIndicatorInsets.top
        
        // 如果是向上滚动到看不见头部控件，直接返回
        if currentOffsetY >= happenOffsetY {return}
        
        if scrollView!.isDragging {
            
            let normal2pullingOffsetY: CGFloat = happenOffsetY - self.frame.size.height
            
            if self.state == .normal && currentOffsetY < normal2pullingOffsetY {
                self.state = .pulling
            } else if self.state == .pulling && currentOffsetY >= normal2pullingOffsetY {
                self.state = .normal
            }
        } else if self.state == .pulling {// 即将开始刷新 && 手松开
            
            self.state = .refreshing
        }
    }
    
    func updateTimeLabel() -> Void {
        
        if lastUpdateTime == nil  {
            lastUpdateTimeLabel.text = "最后更新：无"
            return
        }
        
        let calendar: Calendar = Calendar.current
        let unitFlags = Set(arrayLiteral: Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute)
        let cmp1 = calendar.dateComponents(unitFlags, from: self.lastUpdateTime!)
        let cmp2 = calendar.dateComponents(unitFlags, from: Date())
        
        let formatter = DateFormatter()
        
        if cmp1.day == cmp2.day {//今天
            formatter.dateFormat = "今天 HH:mm"
        } else if cmp1.year == cmp2.year {// 今年
            formatter.dateFormat = "MM-dd HH:mm"
        } else {
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
        }
        
        let time = formatter.string(from: self.lastUpdateTime!)
        
        lastUpdateTimeLabel.text = "最后更新：\(time)"
    }
}
