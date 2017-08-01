//
//  SYRefreshView.swift
//  SYRefreshExample
//
//  Created by shusy on 2017/6/8.
//  Copyright © 2017年 SYRefresh. All rights reserved.
//  代码地址: https://github.com/shushaoyong/SYRefreshForSwift

import UIKit

/**刷新控件的状态 */
enum SYRefreshViewState {
    case stateIdle       /** 普通闲置状态 */
    case pulling        /** 松开就可以进行进行刷新的状态 */
    case refreshing   /** 正在刷新的状态 */
    case noMoreData   /** 没有更多数据的状态 */
}

/// 刷新控件的方向
enum RefreshViewOrientation {
    case top // 上边
    case left// 左边
    case bottom//下边
    case right//右边
}

class RefreshView: UIView {
    
    /**是否是尾部控件*/
    open var isFooter:Bool = false
    /**设置尾部自动刷新 比例，当用户拖拽到百分之几的时候开始自动加载更多数据 取值：0.0-1.0 默认值1.0代表100%，也就是刷新控件完全显示的时候开始刷新*/
    open var footerAutoRefreshProgress:CGFloat = 1.0
    /**保存当前刷新控件方向*/
    open var orientation:RefreshViewOrientation
    /**保存当前刷新控件的状态*/
    open var state : SYRefreshViewState = .stateIdle
    /**UIScrollView控件*/
    open weak var scrollview:UIScrollView?{
        return superview as? UIScrollView
    }
    open var isNoMoreData:Bool = false //是否没有更多数据 尾部控件需要此属性

    /**是否正在刷新*/
    var isRefreshing:Bool = false
    {
        didSet{
            if checkContentSizeValid() || isNoMoreData{ return }
            updateRefreshState(isRefreshing: isRefreshing)
        }
    }
    open var oldFooterInsets:UIEdgeInsets = .zero //记录原始的footer的contentInsets
    /**当前的拖拽比例*/
    private  var pullProgress:CGFloat = 0 {
        didSet{
            if isRefreshing || isNoMoreData  { return }
            if checkContentSizeValid() { return }
            updatePullProgress(progress: pullProgress)
        }
    }
    /**ScrollView的pan手势*/
    private var panGestureRecognizer: UIPanGestureRecognizer?
    
    /**开始刷新后的回调*/
    private let completionCallBack:()->Void
    
    /// 初始化方法
    /// - Parameters:
    ///   - orientaton: 控件的方向
    ///   - height: 控件的高度
    ///   - completion: 进入刷新后的回调
    public init(orientaton: RefreshViewOrientation,height:CGFloat,completion:@escaping ()->Void) {
        var isFooter = false
        if orientaton == .bottom || orientaton == .right { isFooter = true }
        self.completionCallBack = completion
        self.isFooter = isFooter
        self.orientation = orientaton
        super.init(frame: .zero)
        updatePullProgress(progress: pullProgress)
        self.isHidden = true
        self.bounds.size.height = height
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 更新刷新状态 此方法交给子类重写
    /// - Parameter isRefresh: 是否正在刷新
    open func updateRefreshState(isRefreshing:Bool){
        fatalError("updateRefreshState(isRefreshing:) has not been implemented")
    }
    
    /// 拖拽比例 此方法交给子类重写
    /// - Parameter progress: 拖拽比例
    open func updatePullProgress(progress:CGFloat){
        fatalError("updatePullProgress(progress:) has not been implemented")
    }
    
    /// 设置刷新控件的状态 交给子类重写
    /// - Parameter state: 状态
    open func setState(state:SYRefreshViewState){self.state = state}
    
    /// 返回是否是左右刷新方向
    open func isLeftOrRightOrientation()->Bool{
        return orientation == .left || orientation == .right
    }
    
    /// 将要添加到父控件的时候调用此方法 系统调用
    /// - Parameter newSuperview: 将要添加到的父控件
    override func willMove(toSuperview newSuperview: UIView?) {
        removeObserver()
    }
    
    /// 被添加到父控件上之后调用
    override func didMoveToSuperview() {
        panGestureRecognizer = scrollview?.panGestureRecognizer
        addObserver()
        guard let scrollview = scrollview else { return }
        if isLeftOrRightOrientation() {
            self.frame = CGRect(x: 0, y: 0, width: bounds.height, height: scrollview.bounds.height)
            if isFooter == false {
                self.frame.origin.x = -bounds.width
            }
        }else{
            self.frame = CGRect(x: 0, y: 0, width: scrollview.bounds.width, height: bounds.height)
            if isFooter == false {
                self.frame.origin.y = -bounds.height
            }
        }
        let currentVc = self.currentViewController()
        if (currentVc?.automaticallyAdjustsScrollViewInsets == false) { //如果用户设置了不要自定调整内边距我们就自己处理导航栏问题
            if currentVc?.parent is UINavigationController {
                self.scrollview?.contentInset.top = 64 //添加一个导航栏的高度
            }
        }
    }
    
    /// 监听scrollview的状态
    func addObserver(){
        scrollview?.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), options: .new, context: nil)
        panGestureRecognizer?.addObserver(self, forKeyPath: #keyPath(UIPanGestureRecognizer.state), options: .new, context: nil)
        if isFooter {
            scrollview?.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize), options: .new, context: nil)
        }
    }
    
    /// 移除监听scrollview的状态
    func removeObserver(){
        scrollview?.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset))
        panGestureRecognizer?.removeObserver(self, forKeyPath: #keyPath(UIPanGestureRecognizer.state))
        if isFooter {
            superview?.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize))
        }
    }
    
    /// 监听方法 由系统调用
    /// - Parameters:
    ///   - keyPath: 监听的值
    ///   - object: 监听的对象
    ///   - change: 被监听的值
    ///   - context: 上下文
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let scrollview = scrollview else { return }
        if keyPath == #keyPath(UIScrollView.contentOffset)  {
            contentOffsetChange()
        }else if keyPath == #keyPath(UIScrollView.contentSize){
            contentSizeChange()
        }else if keyPath == #keyPath(UIPanGestureRecognizer.state){
            if case .ended =  scrollview.panGestureRecognizer.state {
                scrollviewEndDraging()
            }
        }
    }
    
    //================================监听方法===============================
    /// contentOffset 改变之后调用此方法
    open func contentOffsetChange(){
        guard let scrollview = scrollview else { return }
        if isNoMoreData { return } //如果已经全部加载完毕 直接返回
        if isRefreshing { return}
        if scrollview.isDragging {
            if isLeftOrRightOrientation() { //水平刷新
                if isFooter {
                    pullProgress = min(1,max(0,(scrollview.contentOffset.x+scrollview.bounds.width-scrollview.contentSize.width-scrollview.contentInset.right)/self.bounds.width)) //去除无效的值
                    //设置刷新控件状态
                    let pullingOffsetX = scrollview.contentSize.width - scrollview.bounds.width+bounds.width;
                    let offsetX = scrollview.contentOffset.x
                    if (self.state == .stateIdle && offsetX>pullingOffsetX) {
                        self.setState(state: .pulling)
                    }else if(self.state == .pulling&&offsetX<pullingOffsetX){
                        self.setState(state: .stateIdle)
                    }
                }else{
                    pullProgress = min(1,max(0,-(scrollview.contentOffset.x + scrollview.contentInset.right)/self.bounds.width))
                    //设置刷新控件状态
                    let pullingOffsetX = -scrollview.contentInset.left - bounds.width
                    let offsetX = scrollview.contentOffset.x
                    if (self.state == .stateIdle && offsetX<pullingOffsetX) { //负数 往左拉
                        self.setState(state: .pulling)
                    }else if(self.state == .pulling&&offsetX>pullingOffsetX){
                        self.setState(state: .stateIdle)
                    }
                }
            }else{
                if isFooter {
                    //设置刷新控件状态
                    let pullingOffsetY = scrollview.contentSize.height - scrollview.bounds.height+bounds.height;
                    let offsetY = scrollview.contentOffset.y
                    if (self.state == .stateIdle && offsetY>pullingOffsetY) {
                        self.setState(state: .pulling)
                    }else if(self.state == .pulling&&offsetY<pullingOffsetY){
                        self.setState(state: .stateIdle)
                    }
                    pullProgress = min(1,max(0,(scrollview.contentOffset.y+scrollview.bounds.height-scrollview.contentSize.height-scrollview.contentInset.bottom)/self.bounds.height)) //去除无效的值
                }else{
                    //设置刷新控件状态
                    let pullingOffsetY = -scrollview.contentInset.top - bounds.height
                    let offsetY = scrollview.contentOffset.y
                    if (self.state == .stateIdle && offsetY<pullingOffsetY) { //负数 往下拉
                        self.setState(state: .pulling)
                    }else if(self.state == .pulling&&offsetY>pullingOffsetY){
                        self.setState(state: .stateIdle)
                    }
                    pullProgress = min(1,max(0,-(scrollview.contentOffset.y + scrollview.contentInset.top)/self.bounds.height))
                }
            }
            //控制控件的隐藏和显示
            if isFooter == false  {
                if scrollview.contentOffset.y < -(scrollview.contentInset.top) {
                    if isHidden { self.isHidden = false }
                }else if(scrollview.contentOffset.y >= 0){
                    if isHidden { self.isHidden = false }
                }
            }else{
                if scrollview.contentOffset.y <= 0 {
                    if isHidden { self.isHidden = false }
                }else if(scrollview.contentOffset.y >= scrollview.contentInset.bottom ){
                    if isHidden { self.isHidden = false }
                }
            }            //设置了拖拽比例 再 进行自动刷新
            if self.footerAutoRefreshProgress > 0.5 {
                footerAutoRefresh()
            }
        }
    }
    
    /// 开启尾部自动刷新
    private func footerAutoRefresh(){
        if isFooter == false {  return }
        guard let scrollview = scrollview else { return }
        if checkContentSizeValid() == false {
            if isLeftOrRightOrientation() {//水平方向自动刷新
                //开启自动刷新
                if footerAutoRefreshProgress >= 0.5 && footerAutoRefreshProgress < 1.0{
                    if (scrollview.contentOffset.x>=(scrollview.contentSize.width-scrollview.bounds.width-scrollview.contentInset.right-bounds.height)*footerAutoRefreshProgress) {
                        beginRefreshing()
                        return;
                    }
                }
            }else{ //垂直方向自动刷新
                //开启自动刷新
                if footerAutoRefreshProgress >= 0.5 && footerAutoRefreshProgress < 1.0{
                    if (scrollview.contentOffset.y>=(scrollview.contentSize.height-scrollview.bounds.height-scrollview.contentInset.bottom-bounds.height)*footerAutoRefreshProgress) {
                        beginRefreshing()
                        return;
                    }
                }
            }
        }
    }
    
    /// 校验contentsize是否有效果
    private func checkContentSizeValid()->Bool{
        guard let scrollview = scrollview else { return false} //作用：在下面使用scrollview的时候不用解包
        if isFooter == false { return false }
        if isNoMoreData { return false }
        if isLeftOrRightOrientation() {
            //当内容不满一个屏幕的时候就隐藏底部的刷新控件
            if (scrollview.contentSize.width < scrollview.bounds.width-(scrollview.contentInset.left+scrollview.contentInset.right)) {
                scrollview.sy_footer?.isHidden = true
                return true
            }else{
                scrollview.sy_footer?.isHidden = false
                return false
            }
        }else{
            //当内容不满一个屏幕的时候就隐藏底部的刷新控件
            if (scrollview.contentSize.height < scrollview.bounds.height-(scrollview.contentInset.top+scrollview.contentInset.bottom)) {
                scrollview.sy_footer?.isHidden = true
                return true
            }else{
                scrollview.sy_footer?.isHidden = false
                return false
            }
        }
    }
    
    /// contentSize 改变之后调用此方法
    open func contentSizeChange(){
        guard let scrollview = scrollview else { return } //作用：在下面使用scrollview的时候不用解包
        if isFooter && scrollview.isDragging { isNoMoreData = false }
        if checkContentSizeValid() { return }
        if isLeftOrRightOrientation() {
            if self.bounds.minX ==  scrollview.contentSize.width{return}
            self.frame.origin.x = scrollview.contentSize.width
        }else{
            if self.frame.origin.y ==  scrollview.contentSize.height{return}
            self.frame.origin.y = scrollview.contentSize.height
        }
    }
    
    /// 结束拖拽的时候调用此方法
    private func scrollviewEndDraging(){
        if isNoMoreData { return }
        if isRefreshing || pullProgress < 1 {return}  //如果正在刷新 或者 用户没有拖拽到临界点 就不要刷新
        beginRefreshing()
    }
    
    /// 开始刷新
    func beginRefreshing(){
        if isRefreshing {return}
        if checkContentSizeValid() { return }
        guard let scrollview = scrollview else { return } //作用：在下面使用scrollview的时候不用解包
        isRefreshing = true
        pullProgress = 1
        self.isHidden = false
        self.setState(state: .refreshing)
        if isLeftOrRightOrientation() {
            UIView.animate(withDuration: RefreshConfig.animationDuration, animations: {
                if self.isFooter {
                    if self.oldFooterInsets.bottom <= 0 {
                        scrollview.contentInset.right += self.bounds.width
                        self.oldFooterInsets = scrollview.contentInset
                    }else{
                        scrollview.contentInset.right = self.oldFooterInsets.right
                    }
                }else{
                    scrollview.contentOffset.y = self.bounds.width + scrollview.contentInset.left
                    scrollview.contentInset.left += self.bounds.width
                }
            }) { (true) in
                self.completionCallBack()
            }
        }else{
            UIView.animate(withDuration: RefreshConfig.animationDuration, animations: {
                if self.isFooter {
                    if self.oldFooterInsets.bottom <= 0 {
                        scrollview.contentInset.bottom += self.bounds.height
                        self.oldFooterInsets = scrollview.contentInset
                    }else{
                        scrollview.contentInset = self.oldFooterInsets
                    }
                }else{
                    scrollview.contentOffset.y = -self.bounds.height - scrollview.contentInset.top
                    scrollview.contentInset.top += self.bounds.height
                }
            }) { (true) in
                self.completionCallBack()
            }
        }
    }
    
    /// 结束刷新
    func endRefreshing(){
        guard let scrollview = scrollview else { return } //作用：在下面使用scrollview的时候不用解包
        if isLeftOrRightOrientation() {
            UIView.animate(withDuration: RefreshConfig.animationDuration, animations: {
                if self.isFooter {
                    scrollview.contentInset.right -= self.bounds.width
                }else{
                    scrollview.contentInset.left -= self.bounds.width
                }
            }) { (true) in
                self.isRefreshing = false
                self.pullProgress = 0
                self.setState(state: .stateIdle)
            }
        }else{
            UIView.animate(withDuration: RefreshConfig.animationDuration, animations: {
                if self.isFooter {
                    scrollview.contentInset.bottom -= self.bounds.height
                }else{
                    scrollview.contentInset.top -= self.bounds.height
                }
            }) { (true) in
                self.isRefreshing = false
                self.pullProgress = 0
                self.isHidden = true
                self.setState(state: .stateIdle)
            }
        }
    }
    
    /// 没有更多数据提示文字 子类重写该方法
    open func noMoreData(){
        guard let scrollview = scrollview else { return } //作用：在下面使用scrollview的时候不用解包
        isNoMoreData = true
        isRefreshing = false
        self.isHidden = false
        self.state = .noMoreData
        if isLeftOrRightOrientation() {
            UIView.animate(withDuration: RefreshConfig.animationDuration, animations: {
                if self.isFooter {
                    if self.oldFooterInsets.right <= 0 {
                        scrollview.contentInset.right += self.bounds.width
                        self.oldFooterInsets = scrollview.contentInset
                    }else{
                        scrollview.contentInset.right = self.oldFooterInsets.right
                    }
                }
            }) { (true) in }
        }else{
            UIView.animate(withDuration: RefreshConfig.animationDuration, animations: {
                if self.isFooter {
                    if self.oldFooterInsets.bottom <= 0 {
                        scrollview.contentInset.bottom += self.bounds.height
                        self.oldFooterInsets = scrollview.contentInset
                    }else{
                        scrollview.contentInset = self.oldFooterInsets
                    }
                }
            }) { (true) in }
        }
    }
    
    /// 重置刷新控件的状态
    open func resentNoMoreData(){
        guard let scrollview = scrollview else { return } //作用：在下面使用scrollview的时候不用解包
            if isLeftOrRightOrientation() {
                UIView.animate(withDuration: RefreshConfig.animationDuration, animations: {
                        scrollview.contentInset.right -= self.bounds.width
                }) { (true) in }
            }else{
                UIView.animate(withDuration: RefreshConfig.animationDuration, animations: {
                        scrollview.contentInset.bottom -= self.bounds.height
                }) { (true) in }
            }
    }

    deinit {
        removeObserver()
    }
}
