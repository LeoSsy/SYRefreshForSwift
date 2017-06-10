//
//  TestHorizontalGifCollectionViewController.swift
//  SYRefreshExample_swift
//
//  Created by shusy on 2017/6/9.
//  Copyright © 2017年 SYRefresh. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class TestHorizontalGifCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        let data = try! Data(contentsOf: Bundle.main.url(forResource: "demo-small.gif", withExtension: nil)!)
        let textItem = TextItem(normalText: HorizontalHintText.headerNomalText, pullingText: HorizontalHintText.headerPullingText, refreshingText: HorizontalHintText.headerRefreshText, font: UIFont.systemFont(ofSize: 10), color: UIColor.black)
        collectionView?.sy_header = RefreshViewGifTextHeaderFooter(data: data,textItem:textItem, orientation: .left, height: 80,contentMode:.scaleAspectFit,completion: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self?.collectionView?.sy_header?.endRefreshing()
            }
        })
        
        let textItem2 = TextItem(normalText: HorizontalHintText.footerNomalText, pullingText: HorizontalHintText.footerPullingText, refreshingText: HorizontalHintText.footerRefreshText, font: UIFont.systemFont(ofSize: 10), color: UIColor.black)
        
        collectionView?.sy_footer = RefreshViewGifTextHeaderFooter(data: data,textItem:textItem2, orientation: .right, height: 80,contentMode:.scaleAspectFit,completion: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self?.collectionView?.sy_footer?.endRefreshing()
            }
        })
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 100
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = UIColor.darkGray
        return cell
    }

}
