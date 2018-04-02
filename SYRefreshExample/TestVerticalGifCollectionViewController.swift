//
//  TestVerticalGifCollectionViewController.swift
//  SYRefreshExample_swift
//
//  Created by shusy on 2017/6/9.
//  Copyright © 2017年 SYRefresh. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
class TestVerticalGifCollectionViewController: UICollectionViewController {
    private var count = 10;
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.bounces = true
        let data = try! Data(contentsOf: Bundle.main.url(forResource: "demo-small.gif", withExtension: nil)!)
        let textItem = TextItem(normalText: VerticalHintText.headerNomalText, pullingText: VerticalHintText.headerPullingText, refreshingText: VerticalHintText.headerRefreshText, nomoreDataText: nil, font: UIFont.systemFont(ofSize: 13), color: UIColor.black)
        collectionView?.sy_header = GifTextHeaderFooter(data: data,textItem:textItem, orientation: .top, height: 60,contentMode:.scaleAspectFit,completion: { [weak self] in
            self?.count = 50;
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self?.collectionView?.sy_header?.endRefreshing()
                self?.collectionView?.reloadData()
            }
        })
        
        let textItem2 = TextItem(normalText: VerticalHintText.footerNomalText, pullingText: VerticalHintText.footerPullingText, refreshingText: VerticalHintText.footerRefreshText, nomoreDataText:nil ,font: UIFont.systemFont(ofSize: 13), color: UIColor.black)

        collectionView?.sy_footer = GifTextHeaderFooter(data: data,textItem:textItem2, orientation: .bottom, height: 60,contentMode:.scaleAspectFit,completion: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self?.count += 20;
                guard let count = self?.count else {
                    return
                }
                if count > 100 {
                    self?.collectionView?.sy_footer?.noMoreData()
                }else{
                    self?.collectionView?.sy_footer?.endRefreshing()
                }
                self?.collectionView?.reloadData()
            }
        })
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = UIColor.darkGray
        return cell
    }

}
