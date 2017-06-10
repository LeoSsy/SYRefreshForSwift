//
//  TestVerticalGifTableViewController.swift
//  SYRefreshExample_swift
//
//  Created by shusy on 2017/6/9.
//  Copyright © 2017年 SYRefresh. All rights reserved.
//

import UIKit

class TestVerticalGifTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        let data = try! Data(contentsOf: Bundle.main.url(forResource: "other.gif", withExtension: nil)!)
        tableView.sy_header = RefreshViewGifHeaderFooter(data: data, orientation: .top, height: 160,contentMode:.scaleAspectFill,completion: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.tableView.sy_header?.endRefreshing()
            }
        })
        
        tableView.sy_footer = RefreshViewGifHeaderFooter(data: data, orientation: .bottom, height: 160,contentMode:.scaleAspectFill,completion: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.tableView.sy_footer?.endRefreshing()
            }
        })
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 50
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
