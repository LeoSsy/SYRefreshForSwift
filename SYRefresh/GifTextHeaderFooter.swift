//
//  RefreshViewGifTextHeaderFooter.swift
//  SYRefreshExample_swift
//
//  Created by shusy on 2017/6/9.
//  Copyright © 2017年 SYRefresh. All rights reserved.
//  代码地址: https://github.com/shushaoyong/SYRefreshForSwift

import UIKit

public class GifTextHeaderFooter: RefreshView {
    private var textItem:TextItem //文本视图
    public var imageView  =  GifAnimatedImageView(frame: .zero)
    /// 创建一个GIF刷新控件
    /// - Parameters:
    ///   - data:  gif数据
    ///   - textItem: 提示文本 TextItem对象
    ///   - orientation: 刷新控件的方向
    ///   - height: 刷新控件的高度
    ///   - contentMode: gif图片显示模式
    ///   - completion: 开始刷新之后回调
public init(data:Data?,textItem:TextItem,orientation:RefreshViewOrientation,height:CGFloat,contentMode:UIViewContentMode,completion:@escaping ()->Void){
        self.textItem = textItem
        if data != nil {
            imageView.animatedImage = GIFAnimatedImage(data: data!)
            imageView.bounds.size.height = height
        }
        super.init(orientaton: orientation, height: height, completion: completion)
        if self.isHorizontalOrientation() { textItem.label.numberOfLines = 0 }
        addSubview(imageView)
        addSubview(self.textItem.label)
        imageView.contentMode = contentMode
    }
    
    
    /// 更新控件状态
    ///
    /// - Parameter isRefreshing: 是否正在刷新
    override public func updateRefreshState(isRefreshing: Bool) {
        isRefreshing ? imageView.startAnimating() : imageView.stopAnimating()
        textItem.updateRefreshState(isRefreshing: isRefreshing)
        self.setNeedsLayout()
    }
    
    
    /// 更新拖动的比例
    ///
    /// - Parameter progress: 0 - 1
    override public func updatePullProgress(progress: CGFloat) {
        textItem.updatePullProgress(progress: progress)
        if progress == 1 {
            imageView.startAnimating()
        } else {
            imageView.stopAnimating()
            guard let count = imageView.animatedImage?.frameCount else { return }
            imageView.index = UInt(Int(CGFloat(count - 1) * progress))
        }
    }
    
    /// 布局控件位置
    override public func layoutSubviews() {
        super.layoutSubviews()
        let margin:CGFloat = 2.0
        if isRefreshing { return }
        UIView.performWithoutAnimation {
            if isHorizontalOrientation() { //如果是水平刷新
                imageView.frame = CGRect(x: 0, y: 0, width:bounds.width-margin, height: bounds.width-margin)
                imageView.center = CGPoint(x: bounds.midX, y: bounds.midY-bounds.width*0.5)
                textItem.label.frame.size.width = textItem.label.font.pointSize
                textItem.label.frame.size.height = (textItem.label.text?.textItemHeight(width: textItem.label.font.pointSize, fontSize: textItem.label.font.pointSize))!
                textItem.label.center = CGPoint(x: bounds.midX, y: bounds.midY+bounds.width*0.5+5)
            }else{
                self.imageView.frame = CGRect(x: 0, y: 0, width:bounds.height-margin, height: bounds.height-margin)
                imageView.center = CGPoint(x: (bounds.width - textItem.label.bounds.width - 8) * 0.5, y: bounds.midY)
                textItem.label.center = CGPoint(x: (bounds.width + imageView.bounds.width + 8) * 0.5, y: bounds.midY+5)
            }
        }
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension String {
    /// 计算文本的高度
    /// - Parameters:
    ///   - width: 显示的最大宽度
    ///   - fontSize: 字体
    /// - Returns: 高度
    func textItemHeight(width:CGFloat,fontSize:CGFloat)->CGFloat{
        let font:UIFont! = UIFont.systemFont(ofSize: fontSize)
        let attributes = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = self.boundingRect(with: CGSize(width:width, height:CGFloat(MAXFLOAT)), options: option, attributes: attributes as? [NSAttributedStringKey : Any], context: nil)
        return rect.size.height
    }
}
 
