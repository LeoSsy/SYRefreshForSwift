//
//  GIFAnimatedImageView.swift
//  SYRefreshExampleforSwift
//
//  Created by shusy on 2017/6/10.
//  Copyright © 2017年 SYRefresh. All rights reserved.
//  代码地址: https://github.com/shushaoyong/SYRefreshForSwift

import UIKit
import ImageIO

// MARK GifProxy
private class GifProxy : NSObject  {
    private  weak var target : GIFAnimatedImageView?
    init(target:GIFAnimatedImageView){
        self.target = target
        super.init()
    }
    
    class func proxy(target:AnyObject) -> GifProxy {
        return GifProxy(target: target as! GIFAnimatedImageView)
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        return target
    }
    
    override func method(for aSelector: Selector!) -> IMP! {
        return NSObject.instanceMethod(for:#selector(refresFrames))
    }
    
    func refresFrames(){
        target?.refresFrames()
    }
}

// MARK AnimatedImage
public protocol AnimatedImage {
    var size:CGSize {get} //图片尺寸
    /// On 32-bit platforms, `UInt` is the same size as `UInt32`, and
    /// on 64-bit platforms, `UInt` is the same size as `UInt64`.
    var frameCount:UInt {get} //对应的总帧数
    func frameDurationForImage(index:UInt)->TimeInterval
    subscript(index:UInt)->UIImage{get} //自定义下标 直接可以理解为一个方法
}

// MARK GIFAnimatedImage
public class GIFAnimatedImage : NSObject , AnimatedImage {
    fileprivate typealias imageInfo = (image:UIImage,duration:TimeInterval)
    fileprivate var images : [imageInfo]
    public var size: CGSize = .zero
    public var frameCount: UInt {
        return UInt( images.count)
    }
    
    /// 获取当前下标的duration
    /// - Parameter index: 下标
    /// - Returns: 对应时间
    public func frameDurationForImage(index: UInt) -> TimeInterval {
        return images[Int(index)].duration
    }
    
    /// 获取当前下标对应的图片
    /// - Parameter index: 下标
    /// - Returns: 对应图片
    public subscript(index: UInt) -> UIImage {
        return images[Int(index)].image
    }
    
    public init?(data:Data) {
        
        //获取CGImageSource对象
        let source = CGImageSourceCreateWithData(data as CFData, nil)
        guard source != nil else {
            images = []
            size = .zero
            return nil
        }
        //获取总帧数
        let count = CGImageSourceGetCount(source!)
        //获取每一帧对应的图片对象和时间间隔
        images = (0..<count).map{ index ->imageInfo in
            //获取对应帧的图片
            let image = CGImageSourceCreateImageAtIndex(source!, index, nil)
            guard image != nil else {
                return (UIImage(),0)
            }
            //获取对应帧的时间间隔
            let delayTime:TimeInterval = {
                let info = CGImageSourceCopyPropertiesAtIndex(source!, index, nil)
                // unsafeBitCast    http://swifter.tips/unsafe/
                // Unmanaged.passUnretained  http://www.jianshu.com/p/62354aea4034
                let gifInfo = unsafeBitCast(CFDictionaryGetValue(info, (Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque())), to: CFDictionary.self)
                var delayTime =  unsafeBitCast(CFDictionaryGetValue(gifInfo, Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()), to: NSNumber.self)
                if delayTime.doubleValue < 0 {
                    delayTime =  unsafeBitCast(CFDictionaryGetValue(gifInfo, Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: NSNumber.self)
                }
                return delayTime.doubleValue
            }()
            return (UIImage(cgImage: image!),delayTime)
        }
        if let imageInfo = images.first {
            size = imageInfo.image.size
        }else{
            size = CGSize(width: 0, height: 60)
        }
        super.init()
    }
    
}

// MARK  GIFAnimatedImageView
open class GIFAnimatedImageView : UIImageView {
    var isAnimated = false //是否正动画
    var lastTimestamp:TimeInterval = 0.0 //上一次的时间
    var animatedImage : GIFAnimatedImage? { //图片对象 存储图片相关信息
        didSet{
            image = animatedImage?[0]
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.clipsToBounds = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var index = UInt(0){ //下标通过改变它的值 切换图片
        didSet{
            if index != oldValue {
                image = animatedImage?[index]
            }
        }
    }
    lazy var displayLink : CADisplayLink = { //定时器
        let displayLink  = CADisplayLink(target: GifProxy(target: self), selector: #selector(refresFrames))
        displayLink.add(to:.main, forMode:.commonModes)
        displayLink.isPaused = true
        return displayLink
    }()
    
    /// 更新当前显示的图片
    func refresFrames(){
        if  animatedImage != nil {
            let currentD = animatedImage?.frameDurationForImage(index: index)
            let dlt = displayLink.timestamp - lastTimestamp
            if dlt >= currentD! {
                index = (index+1)%animatedImage!.frameCount
                lastTimestamp = displayLink.timestamp
            }
        }
    }
    
    override open func startAnimating() {
        if  !isAnimated {
            displayLink.isPaused = false
            isAnimated = true
        }
    }
    
    override open func stopAnimating() {
        if isAnimated {
            displayLink.isPaused = true
            isAnimated = false
        }
    }
    
}
