<p align="center">
<img src="https://github.com/121372288/Refresh/blob/master/images/logo.jpg" alt="TheRefresh" title="TheRefresh" width="557"/>
</p>

TheRefresh 是针对swift 刷新控件

## 引入项目

`pod 'TheRefresh'`


## 使用方法

` import TheRefresh ` 导入项目

```swift
    // 增加头部刷新控件
    tableView.ml.add(optional: .header(.normal)) {
        // 开始刷新  
    }
    
    // 增加底部刷新控件
    tableView.ml.add(optional: .footer(.normal)) {
        // 开始刷新  
    }
```

```
// 结束头部刷新动画
tableView.ml.header?.endRefresh()
// 结束底部刷新动画
tableView.ml.footer?.endRefresh()
```
```
或者 添加自定义视图

tableView.ml.add(optional: .header(.custom(<#自定义的刷新视图#>))) {

}

```
