//
//  ViewController.swift
//  SYRefreshExample
//
//  Created by shusy on 2017/6/8.
//  Copyright © 2017年 SYRefresh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollview: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        scrollview.sy_header = RefreshTextHeaderFooter(normalText: VerticalHintText.headerNomalText, pullingText: VerticalHintText.headerPullingText, refreshingText: VerticalHintText.headerRefreshText, orientation: .top, height: 60, font: UIFont.systemFont(ofSize: 14), color: UIColor.black, completion: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.scrollview.sy_header?.endRefreshing()
            }
        })
        
        scrollview.sy_footer = RefreshTextHeaderFooter(normalText: VerticalHintText.footerNomalText, pullingText: VerticalHintText.footerPullingText, refreshingText: VerticalHintText.footerRefreshText, orientation: .bottom, height: 60, font: UIFont.systemFont(ofSize: 14), color: UIColor.black, completion: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.scrollview.sy_footer?.endRefreshing()
            }
        })

        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 700))
        contentView.backgroundColor = UIColor.gray
        self.scrollview.addSubview(contentView)
        
        
        self.scrollview.contentSize = CGSize(width: 0, height: contentView.bounds.maxY)

    }
}

