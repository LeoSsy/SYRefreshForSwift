//
//  AccessoryView.swift
//  SYRefreshExample_swift
//
//  Created by shusy on 2017/6/8.
//  Copyright © 2017年 SYRefresh. All rights reserved.
//

import UIKit

final class TextItem  {
    
    private let normalText:String
    private let pullingText:String
    private let refreshingText:String
    private let font:UIFont
    private let color:UIColor
    let label = UILabel()
    init(normalText:String,pullingText:String,refreshingText:String,font:UIFont,color:UIColor){
        self.normalText = normalText
        self.pullingText = pullingText
        self.refreshingText = refreshingText
        self.font = font
        self.color = color
        self.label.font = font
        self.label.textColor = color
    }
    
    /// 根据状态更新当前的控件提示文字
    /// - Parameter isRefreshing: 是否正在刷新
    func updateRefreshState(isRefreshing:Bool){
        label.text =  isRefreshing ? self.refreshingText : self.normalText
        label.sizeToFit()
    }
    
    /// 根据拖拽比例 设置状态文字
    /// - Parameters:
    ///   - progress: 拖拽比例
    func updatePullProgress(progress:CGFloat){
       label.text = progress == 1 ? self.pullingText : self.normalText
       label.sizeToFit()
    }
    
}

final class AccessoryView { // 不允许子类继承
    
    /// 视图颜色
    private let color :UIColor
    public  var isLeftOrRightOrientation:Bool = false //是否是左右刷新控件 通过外界设置
    /// 菊花控件
    lazy var indicatorView:UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()
    
    /// 箭头控件
    lazy var arrowLayer:CAShapeLayer =  {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: 8))
        bezierPath.addLine(to: CGPoint(x: 0, y: -8))
        bezierPath.move(to: CGPoint(x: 0, y: 8))
        bezierPath.addLine(to: CGPoint(x: 6, y: 2))
        bezierPath.move(to: CGPoint(x: 0, y: 8))
        bezierPath.addLine(to: CGPoint(x: -6, y: 2))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.strokeColor = RefreshConfig.color.cgColor
        shapeLayer.lineWidth = 2
        return shapeLayer
    }()
    
    /// 初始化方法
    /// - Parameter color: 初始颜色
    init(color:UIColor){
        self.color = color
    }

    /// 更新当前的控件状态
    /// - Parameter isRefreshing: 是否正在刷新
    func updateRefreshState(isRefreshing:Bool){
        arrowLayer.isHidden = isRefreshing
        isRefreshing ? indicatorView.startAnimating() : indicatorView.stopAnimating()
    }

    /// 更新拖拽比例
    /// - Parameters:
    ///   - progress: 拖拽比例
    ///   - isFooter: 是否是尾部控件
    func updatePullProgress(progress:CGFloat,isFooter:Bool = false){
        if self.isLeftOrRightOrientation {
            if isFooter {
                arrowLayer.transform = progress == 1 ? CATransform3DIdentity : CATransform3DMakeRotation(CGFloat.pi, 1, 0, 0)
            }else{
                arrowLayer.transform = progress == 1 ? CATransform3DMakeRotation(CGFloat.pi, 1, 0, 0) : CATransform3DIdentity
            }
        }else{
            if isFooter {
                arrowLayer.transform = progress == 1 ? CATransform3DIdentity : CATransform3DMakeRotation(CGFloat.pi, 0, 0, 1)
            }else{
                arrowLayer.transform = progress == 1 ? CATransform3DMakeRotation(CGFloat.pi, 0, 0, 1) : CATransform3DIdentity
            }
        }
        
    }
}
