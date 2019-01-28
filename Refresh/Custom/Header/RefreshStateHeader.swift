//
//  RefreshStateHeader.swift
//  Refresh
//
//  Created by 马磊 on 2019/1/14.
//  Copyright © 2019 MLCode.com. All rights reserved.
//

import UIKit

open class RefreshStateHeader: RefreshHeader {
    /** 显示上一次刷新时间的label */
    public let lastUpdatedTimeLabel = UILabel.mlLabel()
    
    public var lastUpdatedTimeText: ((Date?)->(String?))?
    
    /** 文字距离圈圈、箭头的距离 */
    var labelLeftInset: CGFloat = 15
    /** 显示刷新状态的label */
    public let stateLabel = UILabel.mlLabel()
    
    public fileprivate(set) var stateTitles: [RefreshState: String] = [:]
    
    /** 设置state状态下的文字 */
    public func set(_ title: String, state: RefreshState) {
        
        if title.isEmpty { return }
        stateTitles[state] = title
        stateLabel.text = stateTitles[self.state]
        
    }
    
    //MARK: - 日历获取在9.x之后的系统使用currentCalendar会出异常。在8.0之后使用系统新API。
    var currentCalendar: Calendar {
        if #available(iOS 8.0, *) {
            return Calendar(identifier: Calendar.Identifier.gregorian)
        }
        return Calendar.current
    }
    
    open override var lastUpdatedTimeKey: String {
        didSet {
            // 如果label隐藏了，就不用再处理
            if lastUpdatedTimeLabel.isHidden { return }

            lastUpdatedTimeLabel.text = lastUpdatedTimeText?(lastUpdatedTime)
            
            if let lastUpdatedTime = lastUpdatedTime {
                let calendar = currentCalendar
                let componentunits: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
                
                let lastCmp = calendar.dateComponents(componentunits, from: lastUpdatedTime)
                let currnetCmp = calendar.dateComponents(componentunits, from: Date())
                
                let formatter = DateFormatter()
                
                if lastCmp.day == currnetCmp.day {
                    formatter.dateFormat = " HH:mm"
                } else if lastCmp.month == currnetCmp.month {
                    formatter.dateFormat = " MM-dd HH:mm"
                } else {
                    formatter.dateFormat = " yyyy-MM-dd HH:mm"
                }
                
                let time = formatter.string(from: lastUpdatedTime)
                
                lastUpdatedTimeLabel.text = Bundle.localizedString(for: RefreshText.Time.HeaderLastTime) + time
                
            } else {
                
                lastUpdatedTimeLabel.text = Bundle.localizedString(for: RefreshText.Time.HeaderNoneLastDate)
            }
        }
    }
    
    //MARK: - 覆盖父类的方法
    open override func prepare() {
        super.prepare()
        
        labelLeftInset = RefreshLabelLeftInset
        
        addSubview(stateLabel)
        addSubview(lastUpdatedTimeLabel)
        
        set(Bundle.localizedString(for: RefreshText.Header.idle), state: .idle)
        set(Bundle.localizedString(for: RefreshText.Header.pulling), state: .pulling)
        set(Bundle.localizedString(for: RefreshText.Header.refreshing), state: .refreshing)
        layoutIfNeeded()
    }
    
    open override func placeSubViews() {
        super.placeSubViews()
        
        if self.stateLabel.isHidden { return }
        
        let noConstrainsOnStatusLabel = stateLabel.constraints.isEmpty
        
        if lastUpdatedTimeLabel.isHidden {
            // 状态
            if noConstrainsOnStatusLabel { stateLabel.frame = bounds }
        } else {
            let stateLabelH = self.frame.size.height * 0.5
            // 状态
            if noConstrainsOnStatusLabel {
                stateLabel.frame.origin.x = 0
                stateLabel.frame.origin.y = 0
                stateLabel.frame.size.width = self.frame.size.width
                stateLabel.frame.size.height = stateLabelH
            }
            
            // 更新时间
            if lastUpdatedTimeLabel.constraints.isEmpty {
                lastUpdatedTimeLabel.frame.origin.x = 0
                lastUpdatedTimeLabel.frame.origin.y = stateLabelH
                lastUpdatedTimeLabel.frame.size.width = self.frame.size.width
                lastUpdatedTimeLabel.frame.size.height = self.frame.size.height - self.lastUpdatedTimeLabel.frame.origin.y
            }
        }
    }
    
    public override var state: RefreshState {
        didSet {
            
            if oldValue == state { return }
            // 设置状态文字
            stateLabel.text = stateTitles[state]
            // 重新设置key（重新显示时间）
            let lastUpdatedTimeKey = self.lastUpdatedTimeKey
            self.lastUpdatedTimeKey = lastUpdatedTimeKey
        }
    }
    
}
