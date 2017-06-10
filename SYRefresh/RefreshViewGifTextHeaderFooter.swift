//
//  RefreshViewGifTextHeaderFooter.swift
//  SYRefreshExample_swift
//
//  Created by shusy on 2017/6/9.
//  Copyright © 2017年 SYRefresh. All rights reserved.
//

import UIKit
class RefreshViewGifTextHeaderFooter: RefreshView {
    private var textItem:TextItem //文本视图
    public var imageView  =  GIFAnimatedImageView(frame: .zero)
    init(data:Data?,textItem:TextItem,orientation:RefreshViewOrientation,height:CGFloat,contentMode:UIViewContentMode,completion:@escaping ()->Void){
        self.textItem = textItem
        if data != nil {
            imageView.animatedImage = GIFAnimatedImage(data: data!)
            imageView.bounds.size.height = height
        }
        super.init(orientaton: orientation, height: height, completion: completion)
        addSubview(imageView)
        addSubview(self.textItem.label)
        imageView.contentMode = contentMode
    }
    
    override func updateRefreshState(isRefreshing: Bool) {
        isRefreshing ? imageView.startAnimating() : imageView.stopAnimating()
        textItem.updateRefreshState(isRefreshing: isRefreshing)
    }
    
    override func updatePullProgress(progress: CGFloat) {
        textItem.updatePullProgress(progress: progress)
        if progress == 1 {
            imageView.startAnimating()
        } else {
            imageView.stopAnimating()
            guard let count = imageView.animatedImage?.frameCount else { return }
            imageView.index = UInt(Int(CGFloat(count - 1) * progress))
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin:CGFloat = 2.0
        UIView.performWithoutAnimation {
            if isLeftOrRightOrientation() { //如果是水平刷新
                imageView.frame = CGRect(x: 0, y: 0, width:bounds.width-margin, height: bounds.width-margin)
                imageView.center = CGPoint(x: bounds.midX, y: bounds.midY-bounds.width*0.5)
                textItem.label.center = CGPoint(x: bounds.midX, y: bounds.midY+15)
            }else{
                self.imageView.frame = CGRect(x: 0, y: 0, width:bounds.height-margin, height: bounds.height-margin)
                imageView.center = CGPoint(x: (bounds.width - textItem.label.bounds.width - 8) * 0.5, y: bounds.midY)
                textItem.label.center = CGPoint(x: (bounds.width + imageView.bounds.width + 8) * 0.5, y: bounds.midY+5)
            }
           
        }
    }
    deinit {
        print("deinit ===\(self)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
