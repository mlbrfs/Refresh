//
//  HomeViewController.swift
//  RefreshDemo
//
//  Created by 马磊 on 2019/1/15.
//  Copyright © 2019 MLCode.com. All rights reserved.
//

import UIKit
import Refresh

class HomeViewController: UITableViewController {
    var count: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")

        tableView.ml.add(optional: .header(.normal), target: self, selector: #selector(headRefresh))
//        header = RefreshNormalHeader(self, action: #selector(headRefresh))
        tableView.ml.header?.beginRefreshing()
    }
    
    @objc func headRefresh() {
        print("headerRefreshingCallback")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {[weak self] in
            self?.count = 10
            self?.tableView.ml.header?.endRefresh()
            self?.tableView.reloadData()
        }
    }
    
}

extension HomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
