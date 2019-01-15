//
//  ViewController.swift
//  RefreshDemo
//
//  Created by 马磊 on 2016/10/18.
//  Copyright © 2016年 MLCode.com. All rights reserved.
//

import UIKit

import Refresh

class ViewController: UIViewController {
    var headerRefresh: Bool = false
    var count: Int = 10
    var refreshHeight: CGFloat  = 50
    
    lazy var tableView: UITableView = {
        let table: UITableView = UITableView(frame: self.view.bounds, style: UITableView.Style.plain)
//        table.frame.origin.y = 20
//        table.frame.size.height = table.frame.size.height - 40
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.purple
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.ml.header = RefreshNormalHeader({
        print("headerRefreshingCallback")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {[weak self] in
                self?.count = 10
                self?.tableView.ml.header?.endRefresh()
                self?.tableView.reloadData()
            }
        
        })
//        tableView.ml.header?.isAutomaticallyChangeAlpha = true
        tableView.ml.footer = RefreshBackNormalFooter({
            print("headerRefreshingCallback")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {[weak self] in
                self?.count += 10
                self?.tableView.ml.footer?.endRefresh()
                self?.tableView.reloadData()
            }
            
        })
    }
    
    @objc func refreshForHeader() -> Void {
        print("headerRefreshing")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {[weak self] in
            
            self?.count = 10
            self?.tableView.ml.header?.endRefresh()
            self?.tableView.reloadData()
            
        }
        
    }
    
    @objc func refreshForFooter() -> Void {
        print("footerRefreshing")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {[weak self] in
            self?.count += 10
            self?.tableView.ml.footer?.endRefresh()
            self?.tableView.reloadData()

        }
    }
}



extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    /* UITableViewDataSource */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    /* UITableViewDelegate */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        cell.imageView?.image = UIImage(named: "Icon")
        
        
        if indexPath.row % 2 == 1 {
            cell.backgroundColor = UIColor.white
        } else {
            cell.backgroundColor = UIColor.gray
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

