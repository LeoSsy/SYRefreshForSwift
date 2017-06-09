//
//  TestHorizontalCollectionViewController.swift
//  SYRefreshExample_swift
//
//  Created by shusy on 2017/6/9.
//  Copyright © 2017年 SYRefresh. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class TestHorizontalCollectionViewController: UICollectionViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        let data = try! Data(contentsOf: Bundle.main.url(forResource: "giphy.gif", withExtension: nil)!)
        collectionView?.sy_header = RefreshViewGifHeaderFooter(data: data, orientation: .left, height: 40,contentMode:.scaleAspectFit,completion: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.collectionView?.sy_header?.endRefreshing()
            }
        })
        
        collectionView?.sy_footer = RefreshViewGifHeaderFooter(data: data, orientation: .right, height: 40,contentMode:.scaleAspectFit,completion: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
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
