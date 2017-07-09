//
//  AccessoryView.swift
//  SYRefreshExample_swift
//
//  Created by shusy on 2017/6/8.
//  Copyright © 2017年 SYRefresh. All rights reserved.
//  代码地址: https://github.com/shushaoyong/SYRefreshForSwift

import UIKit

extension UIView {
    
    ///获取当前View的所在的控制器
    func currentViewController() -> UIViewController! {
        return self.findControllerWithClass(UIViewController.self)
    }
    
    ///获取当前View的所在的导航控制器
    func currentNvagationController() -> UINavigationController! {
        return self.findControllerWithClass(UINavigationController.self)
    }
    
    ///原理根据事件响应者链条
    func findControllerWithClass<T>(_ clzz: AnyClass) -> T? {
        var responder = self.next
        while(responder != nil) {
            if (responder!.isKind(of: clzz)) {
                return responder as? T
            }
            responder = responder?.next
        }
        return nil
    }
}

struct VerticalHintText {
    static let headerNomalText:String = "下拉即可刷新"   /// 头部默认状态提示文字
    static let headerPullingText:String = "松手即可刷新" ///头部拖拽状态提示文字
    static let headerRefreshText:String = "刷新中..."   ///头部刷新状态提示文字
    static let footerNomalText:String = "上拉加载更多"   /// 尾部默认状态提示文字
    static let footerPullingText:String = "松手加载更多" ///尾部拖拽状态提示文字
    static let footerRefreshText:String = "加载中..."   ///尾部刷新状态提示文字
    static let footerNomoreDataText:String = "———— 别再拉了，再拉我也长不高 ————"   ///尾部刷新状态提示文字
}

struct HorizontalHintText {
    static let headerNomalText:String = "右边拉即可刷新"   /// 头部默认状态提示文字
    static let headerPullingText:String = "松手即可刷新" ///头部拖拽状态提示文字
    static let headerRefreshText:String = "刷新中"   ///头部刷新状态提示文字
    static let footerNomalText:String = "左拉加载更多"   /// 尾部默认状态提示文字
    static let footerPullingText:String = "松手加载更多" ///尾部拖拽状态提示文字
    static let footerRefreshText:String = "加载中"   ///尾部刷新状态提示文字
    static let footerNomoreDataText:String = "没有更多数据"   ///尾部刷新状态提示文字
}

struct RefreshConfig {
    static let animationDuration:TimeInterval = 0.3   /// 默认动画时间
    static let height:CGFloat = 44                     /// 默认刷新控件高度
    static let color:UIColor = UIColor.black           /// 默认字体颜色
    static let font:UIFont = UIFont.systemFont(ofSize:14)/// 默认字体大小
}

final class TextItem {
    private let normalText:String //默认状态提示文字
    private let pullingText:String //拖拽到临界点松开即可刷新状态提示文字
    private let refreshingText:String //刷新状态提示文字
    private let nomoreDataText:String? //没有更多数据状态提示文字
    private let font:UIFont //提示文字字体
    private let color:UIColor//提示文字颜色
    let label = UILabel()
    init(normalText:String,pullingText:String,refreshingText:String,nomoreDataText:String?,font:UIFont,color:UIColor){
        self.normalText = normalText
        self.pullingText = pullingText
        self.refreshingText = refreshingText
        self.nomoreDataText = nomoreDataText
        self.font = font
        self.color = color
        self.label.font = font
        self.label.textColor = color
        self.label.text = normalText
    }
    
    /// 没有更多数据提示文字
    func noMoreData(){
        self.label.text = self.nomoreDataText
        self.label.sizeToFit()
    }
    
    /// 重置更多数据提示文字
    func resentMoreData(){
        self.label.text = self.normalText
        self.label.sizeToFit()
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
    
    private let color :UIColor /// 视图颜色
    public  var isLeftOrRightOrientation:Bool = false //是否是左右刷新控件 通过外界设置
    lazy var indicatorView:UIActivityIndicatorView = {/// 菊花控件
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()
    open var isNoMoreData:Bool = false //是否没有更多数据
    
    /// 垂直箭头控件
    lazy var arrowLayerV:CAShapeLayer =  {
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
    
    /// 水平箭头控件
    lazy var arrowLayerH:CAShapeLayer =  {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 8, y: 0))
        bezierPath.addLine(to: CGPoint(x: -8, y: 0))
        bezierPath.move(to: CGPoint(x: 8, y: 0))
        bezierPath.addLine(to: CGPoint(x: 2, y: 6))
        bezierPath.move(to: CGPoint(x: 8, y: 0))
        bezierPath.addLine(to: CGPoint(x: 2, y: -6))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.strokeColor = RefreshConfig.color.cgColor
        shapeLayer.lineWidth = 2
        return shapeLayer
    }()
    
    /// 返回当前正在显示的箭头控件
    /// - Returns: CAShapeLayer
    func arrowLayer() -> CAShapeLayer {
        return isLeftOrRightOrientation ? arrowLayerH : arrowLayerV
    }
    
    /// 初始化方法
    /// - Parameter color: 初始颜色
    init(color:UIColor){
        self.color = color
    }

    /// 更新当前的控件状态
    /// - Parameter isRefreshing: 是否正在刷新
    func updateRefreshState(isRefreshing:Bool){
        if isNoMoreData == false { indicatorView.isHidden = false }
        arrowLayer().isHidden = isRefreshing
        isRefreshing ? indicatorView.startAnimating() : indicatorView.stopAnimating()
    }

    /// 更新拖拽比例
    /// - Parameters:
    ///   - progress: 拖拽比例
    ///   - isFooter: 是否是尾部控件
    func updatePullProgress(progress:CGFloat,isFooter:Bool = false){
        if isFooter {
            arrowLayer().transform = progress == 1 ? CATransform3DIdentity : CATransform3DMakeRotation(CGFloat.pi, 0, 0, 1)
        }else{
            arrowLayer().transform = progress == 1 ? CATransform3DMakeRotation(CGFloat.pi, 0, 0, 1) : CATransform3DIdentity
        }
    }
}
