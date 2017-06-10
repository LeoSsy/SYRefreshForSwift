//
//  RefreshViewGifHeaderFooter.swift
//  SYRefreshExample_swift
//
//  Created by shusy on 2017/6/9.
//  Copyright © 2017年 SYRefresh. All rights reserved.
//

import UIKit

class RefreshViewGifHeaderFooter: RefreshView {
    public var imageView  =  GIFAnimatedImageView(frame: .zero)
    init(data:Data?,orientation:RefreshViewOrientation,height:CGFloat,contentMode:UIViewContentMode,completion:@escaping ()->Void){
        if data != nil {
            imageView.animatedImage = GIFAnimatedImage(data: data!)
            imageView.bounds.size.height = height
        }
        super.init(orientaton: orientation, height: height, completion: completion)
        addSubview(imageView)
        imageView.contentMode = contentMode
    }
    
    override func updateRefreshState(isRefreshing: Bool) {
        isRefreshing ? imageView.startAnimating() : imageView.stopAnimating()
    }
    
    override func updatePullProgress(progress: CGFloat) {
        if progress == 1 {
            imageView.startAnimating()
        } else {
            imageView.stopAnimating()
            guard let count = imageView.animatedImage?.frameCount else { return }
            imageView.index = UInt(Int(CGFloat(count - 1) * progress))
        }
    }
    
    override func beginRefreshing() {
        super.beginRefreshing()
        imageView.startAnimating()
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        imageView.stopAnimating()
        imageView.index = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        UIView.performWithoutAnimation {
            imageView.bounds.size.width = bounds.width
            imageView.center = CGPoint(x: bounds.midX, y: bounds.midY)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
    }
    deinit {
        print("deinit ===\(self)")
    }

}
