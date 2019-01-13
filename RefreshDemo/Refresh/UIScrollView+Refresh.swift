//
//  UIScrollView+Refresh.swift
//  RefreshDemo
//
//  Created by 马磊 on 2016/10/18.
//  Copyright © 2016年 MLCode.com. All rights reserved.
//

import UIKit

extension UIScrollView  {


    private struct AssociatedKeys {
        static var header:RefreshHeader?
        static var footer:RefreshFooter?
    }
    // 1.1 添加属性  头部刷新控件
    var header: RefreshHeader?  {
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.header, newValue, .OBJC_ASSOCIATION_ASSIGN)
            }
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.header) as! RefreshHeader?
        }
    }
    // 1.2 添加属性  底部刷新控件
    var footer: RefreshFooter?  {
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.footer, newValue, .OBJC_ASSOCIATION_ASSIGN)
            }
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.footer) as! RefreshFooter?
        }
    }
}

extension UIScrollView {
    
    var mlInset: UIEdgeInsets {
        get {
            if #available(iOS 11.0, *){
                return adjustedContentInset
            }
            return contentInset
        }
        set {
            var inset = contentInset
            if #available(iOS 11.0, *) {
                inset = UIEdgeInsets(top: adjustedContentInset.top - contentInset.top, left: adjustedContentInset.left - contentInset.left, bottom: adjustedContentInset.bottom - contentInset.bottom, right: adjustedContentInset.right - contentInset.right)
            }
            contentInset = inset
        }
    }
    
    var mlTotalDataCount: Int {
        
        var totalCount = 0
        if let tableView = self as? UITableView {
            for scetion in 0..<tableView.numberOfSections {
                totalCount += tableView.numberOfRows(inSection: scetion)
            }
        } else if let collectionView = self as? UICollectionView {
            for scetion in 0..<collectionView.numberOfSections {
                totalCount += collectionView.numberOfItems(inSection: scetion)
            }
        }
        return totalCount;
        
    }
    
    
}
