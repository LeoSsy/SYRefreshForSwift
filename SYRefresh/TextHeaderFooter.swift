//
//  RefreshTextHeader.swift
//  SYRefreshExample_swift
//
//  Created by shusy on 2017/6/8.
//  Copyright © 2017年 SYRefresh. All rights reserved.
//  代码地址: https://github.com/shushaoyong/SYRefreshForSwift

import UIKit

class TextHeaderFooter: RefreshView {
    private var accessoryView:AccessoryView //辅助试图
    private var textItem:TextItem //文本视图
    /// 创建一个刷新控件
    /// - Parameters:
    ///   - normalText: 默认状态提示文字
    ///   - pullingText: 拖拽到临界点松开即可刷新状态提示文字
    ///   - refreshingText: 刷新状态提示文字
    ///   - orientation: 刷新控件的方向
    ///   - height: 刷新控件的高度
    ///   - font:   提示文字字体
    ///   - color:  提示文字颜色
    ///   - completion: 开始刷新之后回调
    init(normalText:String,pullingText:String,refreshingText:String,nomoreDataText:String?,orientation:RefreshViewOrientation,height:CGFloat,font:UIFont,color:UIColor,completion: @escaping ()->Void){
        self.accessoryView = AccessoryView(color: color)
        self.textItem = TextItem(normalText: normalText, pullingText: pullingText, refreshingText: refreshingText,nomoreDataText:nomoreDataText , font: font, color: color)
        super.init(orientaton: orientation, height: height, completion: completion)
        if self.isLeftOrRightOrientation() { textItem.label.numberOfLines = 0 }
        self.accessoryView.isLeftOrRightOrientation = self.isLeftOrRightOrientation() //传递刷新的方向
        layer.addSublayer(accessoryView.arrowLayer())
        addSubview(accessoryView.indicatorView)
        addSubview(textItem.label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateRefreshState(isRefreshing: Bool) {
            guard let scrollview = self.scrollview else { return }
            if (isFooter == false  && scrollview.contentInset.bottom > 0 ) || (isFooter == false  && scrollview.contentInset.right > 0)  {
                resentNoMoreData()
            }
            if  isNoMoreData == false {
                accessoryView.isNoMoreData = isNoMoreData
                accessoryView.updateRefreshState(isRefreshing: isRefreshing)
                textItem.updateRefreshState(isRefreshing: isRefreshing)
          }
    }
    
    override func updatePullProgress(progress: CGFloat) {
        if  isNoMoreData == false {
            if accessoryView.arrowLayer().isHidden == true {
                accessoryView.arrowLayer().isHidden = false
            }
             accessoryView.updatePullProgress(progress: progress, isFooter: isFooter)
             textItem.updatePullProgress(progress: progress)
        }
    }
    
    override func noMoreData(){
        super.noMoreData()
        textItem.noMoreData()
        accessoryView.arrowLayer().isHidden = true
        accessoryView.indicatorView.isHidden = true
        self.setNeedsLayout()
    }
    
    override  func resentNoMoreData() {
        textItem.resentMoreData()
        accessoryView.arrowLayer().isHidden = false
        accessoryView.indicatorView.isHidden = false
        self.setNeedsLayout()
        super.resentNoMoreData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let scrollview = self.scrollview else { return }
        var contentW = bounds.width
        if  superview?.superview != nil {
            if (superview?.isKind(of: UIScrollView.self))! { contentW = (superview?.superview?.bounds.width)! }
        }
        //全部加载完成只需要显示文本即可
        if isNoMoreData {
            UIView.performWithoutAnimation {
                textItem.label.frame.origin.x = (contentW-textItem.label.bounds.width)*0.5
            }
            return
        }
        //普通状态下
        var point = CGPoint(x: (contentW - textItem.label.bounds.width*0.65-8)*0.5, y: bounds.midY)
        var indicatorViewPoint = CGPoint(x: point.x-8, y: point.y)
        var labelCenter = CGPoint(x: (contentW+textItem.label.bounds.width*0.5+8)*0.5, y: bounds.midY)
        if isLeftOrRightOrientation() { //如果是水平刷新
            textItem.label.frame.size.width = textItem.label.font.pointSize
            textItem.label.frame.size.height = scrollview.bounds.height*0.5
            if (self.scrollview?.contentOffset.x)! <= CGFloat(0.0) {
                labelCenter = CGPoint(x: bounds.midX-textItem.label.font.pointSize+5, y: scrollview.bounds.midY)
                point = CGPoint(x: bounds.midX+textItem.label.font.pointSize+5, y: scrollview.bounds.midY)
                indicatorViewPoint = CGPoint(x: point.x, y: point.y)
            }else{
                point = CGPoint(x: bounds.midX-textItem.label.font.pointSize-5, y: scrollview.bounds.midY)
                labelCenter = CGPoint(x: bounds.midX+textItem.label.font.pointSize+5, y: scrollview.bounds.midY)
                indicatorViewPoint = CGPoint(x: point.x, y: point.y)
            }
        }
        //去除动画效果
        UIView.performWithoutAnimation {
            accessoryView.arrowLayer().position = point
            accessoryView.indicatorView.center = indicatorViewPoint
            textItem.label.center = labelCenter
        }
    }
    
}
