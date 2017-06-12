//
//  TestGifImagesCollectionViewController.swift
//  SYRefreshExampleforSwift
//
//  Created by shusy on 2017/6/12.
//  Copyright © 2017年 SYRefresh. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class TestGifImagesCollectionViewController: UICollectionViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        let header  = GifImagesHeaderFooter(orientation: .top, height: 80, contentMode: .scaleAspectFit, completion: {  [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.collectionView?.sy_header?.endRefreshing()
            }
        })
        let stateIdleImages = (1..<20).map { index->UIImage in
            let imageName = "refresh_camera_frame".appending("\(index)")
            let image = UIImage(named: imageName)
            return image!
        }
        let pullingImages = (20..<21).map { index->UIImage in
            let imageName = "refresh_camera_frame".appending("\(index)")
            let image = UIImage(named: imageName)
            return image!
        }
        let refreshingImages = (21...45).map { index->UIImage in
            let imageName = "refresh_camera_frame".appending("\(index)")
            let image = UIImage(named: imageName)
            return image!
        }
        header.setRefreshState(state: .stateIdle, images: stateIdleImages)
        header.setRefreshState(state: .pulling, images: pullingImages)
        header.setRefreshState(state: .refreshing, images: refreshingImages)
        collectionView?.sy_header =  header

        
        let footer = GifImagesHeaderFooter(orientation: .bottom, height: 60, contentMode: .scaleAspectFit, completion: {  [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.collectionView?.sy_footer?.endRefreshing()
            }
        })
        footer.setRefreshState(state: .stateIdle, images: stateIdleImages)
        footer.setRefreshState(state: .pulling, images: pullingImages)
        footer.setRefreshState(state: .refreshing, images: refreshingImages)
        collectionView?.sy_footer = footer
        
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
