//
//  TestVerticalGifTableViewController.swift
//  SYRefreshExample_swift
//
//  Created by shusy on 2017/6/9.
//  Copyright © 2017年 SYRefresh. All rights reserved.
//

import UIKit

class TestVerticalGifTableViewController: UITableViewController {

    var count  = 35

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        let data = try! Data(contentsOf: Bundle.main.url(forResource: "other.gif", withExtension: nil)!)
        tableView.sy_header = GifHeaderFooter(data: data, orientation: .top, height: 160,contentMode:.scaleAspectFill,completion: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.tableView.sy_header?.endRefreshing()
                self?.count = 35
                self?.tableView.reloadData()
            }
        })
        
        let data1 = try! Data(contentsOf: Bundle.main.url(forResource: "other.gif", withExtension: nil)!)
        tableView.sy_footer = GifHeaderFooter(data: data1, orientation: .bottom, height: 160,contentMode:.scaleAspectFill,completion: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.tableView.sy_footer?.endRefreshing()
                self?.count += 15
                self?.tableView.reloadData()
            }
        })
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = "indepath==\(indexPath.row)"
        return cell
    }
    
    deinit {
        print("deinit ===\(self)")
    }


}
