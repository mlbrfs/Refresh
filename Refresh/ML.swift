//
//  ML.swift
//  Refresh
//
//  Created by 马磊 on 2019/1/13.
//  Copyright © 2019年 MLCode.com. All rights reserved.
//

import UIKit

public protocol RefreshCompatible: class { }

public extension RefreshCompatible {
    /// A proxy which hosts reactive extensions for `self`.
    /// Gets a namespace holder for Kingfisher compatible types.
    public var ml: RefreshWrapper<Self> {
        get { return RefreshWrapper(self) }
        set { }
    }
    
}

public struct RefreshWrapper<Base> {
    public let base: Base
    
    // Construct a proxy.
    //
    // - parameters:
    //   - base: The object to be proxied.
    fileprivate init(_ base: Base) {
        self.base = base
    }
    
}

public extension RefreshWrapper where Base: UIScrollView {
    // 1.1 添加属性  头部刷新控件
    public var header: RefreshHeader? {
        set {
            base.header = newValue
        }
        get {
            return base.header
        }
    }
    // 1.2 添加属性  底部刷新控件
    public var footer: RefreshFooter?  {
        set {
            base.footer = newValue
        }
        get {
            return base.footer
        }
    }

    public mutating func add(optional: RefreshOptional, target: Any, selector: Selector) {
        
        switch optional {
        case .footer(let footer):
            switch footer {
            case .none:
                self.footer = nil
            case .normal(isAuto: let isAuto):
                if isAuto {
                    self.footer = RefreshAutoFooter(target, action: selector)
                } else {
                    self.footer = RefreshBackFooter(target, action: selector)
                }
            case .animation(isAuto: let isAuto):
                if isAuto {
                    self.footer = RefreshAutoAnimationFooter(target, action: selector)
                } else {
                    self.footer = RefreshBackAnimationFooter(target, action: selector)
                }
            case .custom(let footType):
                self.footer = footType.init(target, action: selector)
            }
        case .header(let header):
            switch header {
            case .none:
                self.header = nil
            case .normal:
                self.header = RefreshNormalHeader(target, action: selector)
            case .animation:
                self.header = RefreshAnimationHeader(target, action: selector)
            case .custom(let headerType):
                self.header = headerType.init(target, action: selector)
            }
        }
    }
    
    public mutating func add(optional: RefreshOptional, refreshCallback: (()->())?) {
        
        switch optional {
        case .footer(let footer):
            switch footer {
            case .none:
                self.footer = nil
            case .normal(isAuto: let isAuto):
                if isAuto {
                    self.footer = RefreshAutoFooter(refreshCallback)
                } else {
                    self.footer = RefreshBackFooter(refreshCallback)
                }
            case .animation(isAuto: let isAuto):
                if isAuto {
                    self.footer = RefreshAutoAnimationFooter(refreshCallback)
                } else {
                    self.footer = RefreshBackAnimationFooter(refreshCallback)
                }
            case .custom(let footType):
                self.footer = footType.init(refreshCallback)
            }
        case .header(let header):
            switch header {
            case .none:
                self.header = nil
            case .normal:
                self.header = RefreshNormalHeader(refreshCallback)
            case .animation:
                self.header = RefreshAnimationHeader(refreshCallback)
            case .custom(let headerType):
                self.header = headerType.init(refreshCallback)
            }
        }
        
    }
    
    // 是否正在刷新
    public var isHeaderRefreshing: Bool {
        return header?.isRefreshing ?? false
    }
    public var isFooterRefreshing: Bool {
        return footer?.isRefreshing ?? false
    }
    
}

// scrollView 添加属性
extension UIScrollView: RefreshCompatible {
    
}

public enum RefreshOptional {
    
    public enum Header {
        
        case none
        
        case normal
        
        case animation
        
        case custom(RefreshHeader.Type)
    }
    
    public enum Footer {
        
        case none
        
        case normal(isAuto: Bool)
        
        case animation(isAuto: Bool)
        
        case custom(RefreshFooter.Type)
        
    }
    
    case header(Header)
    case footer(Footer)
    
}


