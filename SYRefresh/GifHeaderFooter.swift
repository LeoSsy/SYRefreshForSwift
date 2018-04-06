//
//  RefreshViewGifHeaderFooter.swift
//  SYRefreshExample_swift
//
//  Created by shusy on 2017/6/9.
//  Copyright © 2017年 SYRefresh. All rights reserved.
//  代码地址: https://github.com/shushaoyong/SYRefreshForSwift

import UIKit

public class GifHeaderFooter: RefreshView {
    public var imageView  =  GifAnimatedImageView(frame: .zero)
    /// 创建一个GIF刷新控件
    /// - Parameters:
    ///   - data:  gif数据
    ///   - orientation: 刷新控件的方向
    ///   - height: 刷新控件的高度
    ///   - contentMode: gif图片显示模式
    ///   - completion: 开始刷新之后回调
    public init(data:Data?,orientation:RefreshViewOrientation,height:CGFloat,contentMode:UIViewContentMode,completion:@escaping ()->Void){
        if data != nil {
            imageView.animatedImage = GIFAnimatedImage(data: data!)
            imageView.bounds.size.height = height
            
        }
        super.init(orientaton: orientation, height: height, completion: completion)
        addSubview(imageView)
        imageView.contentMode = contentMode
        imageView.clipsToBounds = true
    }
    
    /// 当前的控件状态
    /// - Parameter isRefreshing: 是否正在刷新中
    override public func updateRefreshState(isRefreshing: Bool) {
        isRefreshing ? imageView.startAnimating() : imageView.stopAnimating()
    }
    
    /// 用户拖拽的比例 0 - 1
    /// - Parameter progress: 当前拖拽值
    override public func updatePullProgress(progress: CGFloat) {
        if progress == 1 {
            imageView.startAnimating()
        } else {
            imageView.stopAnimating()
            guard let count = imageView.animatedImage?.frameCount else { return }
            imageView.index = UInt(Int(CGFloat(count - 1) * progress))
        }
    }

    /// 开始刷新
    override func beginRefreshing() {
        super.beginRefreshing()
        imageView.startAnimating()
    }
    
    /// 结束刷新
    override func endRefreshing() {
        super.endRefreshing()
        imageView.stopAnimating()
        imageView.index = 0
    }
    
    /// 布局子控件
    override public func layoutSubviews() {
        super.layoutSubviews()
        UIView.performWithoutAnimation {
            imageView.bounds.size.width = bounds.width
            imageView.center = CGPoint(x: bounds.midX, y: bounds.midY)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
 
