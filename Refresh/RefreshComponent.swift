//
//  RefreshComponent.swift
//  RefreshDemo
//
//  Created by 马磊 on 2016/10/18.
//  Copyright © 2016年 MLCode.com. All rights reserved.
//

import UIKit


enum RefreshState: Int {
    case pulling = 1 // 松开刷新
    case normal = 2 // 普通状态
    case refreshing = 3 // 正在刷新
    case willRefreshing = 4 // 将要刷新
}

class RefreshComponent: UIView {
    /*
     父控件
     */
    weak var scrollView: UIScrollView?
    var scrollViewOriginalInset: UIEdgeInsets?
    
    /*
     子控件
     */
    lazy var statusLabel: UILabel = {
        let label: UILabel = UILabel()
        label.autoresizingMask = UIViewAutoresizing.flexibleWidth
        label.font = UIFont.boldSystemFont(ofSize: RefreshTextSize)
        label.textColor = DefaltColor
        label.backgroundColor = UIColor.clear
        label.textAlignment = NSTextAlignment.center
        self.addSubview(label)
        return label
    }()
    
    lazy var arrowImage: UIImageView = {
        //拿到当前图片的bundle 通过当前类去拿path  通过path获取bundle
        let bundle: Bundle = Bundle.init(path: Bundle(for: RefreshComponent.classForCoder()).path(forResource: "Refresh", ofType: "bundle")!)!
        
        let image:UIImage = UIImage.init(contentsOfFile: bundle.path(forResource: "arrow@2x", ofType: "png")!)!.withRenderingMode(.alwaysOriginal)
        
        let arrowImg: UIImageView = UIImageView(image: image)
        let flexible = UIViewAutoresizing.flexibleRightMargin.rawValue | UIViewAutoresizing.flexibleLeftMargin.rawValue
        arrowImg.autoresizingMask = UIViewAutoresizing(rawValue: flexible)
        self.addSubview(arrowImg)
        return arrowImg
    }()
    
    lazy var activityView: UIActivityIndicatorView = {
        let activity: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activity.bounds = self.arrowImage.bounds
        activity.autoresizingMask = self.arrowImage.autoresizingMask
        self.addSubview(activity)
        return activity
    }()
    override init(frame: CGRect) {
        var frame = frame
        frame.size.height = RefreshViewHeight
        super.init(frame: frame)
        self.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let arrowX: CGFloat = self.frame.size.width * 0.5 + 100
        self.arrowImage.center = CGPoint(x: arrowX, y: self.frame.size.height * 0.5)
        
        self.activityView.center = self.arrowImage.center
        
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        //添加监听者
        self.superview?.removeObserver(self, forKeyPath: RefreshContentOffset, context: nil)
        newSuperview?.addObserver(self, forKeyPath: RefreshContentOffset, options: .new, context: nil)
        //设置属性
        self.frame.size.width = newSuperview == nil ? 0 : (newSuperview?.frame.size.width)!
        self.frame.origin.x = 0
        // 记录scrollView
        self.scrollView = newSuperview as! UIScrollView?
        // 记录最开始的ScrollView
        self.scrollViewOriginalInset = self.scrollView?.contentInset
        
    }
    
    override func draw(_ rect: CGRect) {
        if self.state == .willRefreshing {
            self.state = .refreshing
        }
    }
    
    /*
     当前状态
     */
    private var _state: RefreshState = .normal
    var state: RefreshState {
        get {
            return self._state
        }
        set {
            if _state != .refreshing {
                scrollViewOriginalInset = scrollView?.contentInset
            }
            if _state == newValue {
                return
            }
            
            switch newValue {
            case .normal:
                isRefreshing = false
                if _state == .refreshing {
                    UIView.animate(withDuration: 0.6 * RefreshSlowAnimationDuration, animations: {
                        self.activityView.alpha = 0.0
                        }, completion: { (true) in
                            self.activityView.stopAnimating()
                            self.activityView.alpha = 1.0
                    })
                    let deadlineTime = DispatchTime.now() + .milliseconds(RefreshSlowDelayDuration)
                    DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                        self._state = .pulling
                        self.state = .normal
                    }
                    //直接返回
                    return
                } else {
                    //显示箭头 停止转圈圈
                    self.arrowImage.isHidden = false
                    
                    activityView.stopAnimating()
                }
                
            case .pulling:
                break
            case .refreshing:
                isRefreshing = true
                activityView.startAnimating()
                //隐藏箭头
                self.arrowImage.isHidden = true
                //这里做回调 由于runtime不算太熟  只能选择迂回的方式了
                if let startRefreshingTaget = startRefreshingTaget {
                    Timer.scheduledTimer(timeInterval: 0, target: startRefreshingTaget, selector: startRefreshingAction!, userInfo: nil, repeats: false)
                }
                
                startRefreshingCallback?()
            default:
                break
            }
            
            self._state = newValue
            
            settingLabelText()
        }
    }
    
    func settingLabelText() -> Void {
        switch state {
        case .normal:
            statusLabel.text = pullToRefreshText
        case .pulling:
            statusLabel.text = releaseToRefreshText
        case .refreshing:
            statusLabel.text = refreshingText
        default:
            break
        }
        
    }
    
    var startRefreshingTaget: Any?
    var startRefreshingAction: Selector?
    /*
     开始进入刷新状态就会调用
     */
    var startRefreshingCallback: (()->())?
    
    /**
     是否正在刷新
     */
    var isRefreshing: Bool = false
    
    /*
     开始刷新
     */
    func startRefreshing() -> Void {
        if state == .refreshing {
            if let startRefreshingTaget = startRefreshingTaget {
                Timer.scheduledTimer(timeInterval: 0, target: startRefreshingTaget, selector: startRefreshingAction!, userInfo: nil, repeats: false)
            }
            
            startRefreshingCallback?()
            
        } else {
            if self.window != nil {
                self.state = .refreshing
            } else {
                _state = .willRefreshing
                super.setNeedsDisplay()
            }
        }
        
    }
    
    /*
     结束刷新
     */
    func endRefreshing() -> Void {
        
        let deadlineTime = DispatchTime.now() + .milliseconds(RefreshSlowDelayDuration)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.state = .normal
        }
        
    }
    
    var pullToRefreshText: String?
    var releaseToRefreshText: String?
    var refreshingText: String?
}

