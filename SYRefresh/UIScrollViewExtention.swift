//
//  UIScrollView.swift
//  SYRefreshExample
//
//  Created by shusy on 2017/6/8.
//  Copyright © 2017年 SYRefresh. All rights reserved.
//  代码地址: https://github.com/shushaoyong/SYRefreshForSwift

import UIKit

private var headerKey: Void?
private var footerKey: Void?

extension UIScrollView {
    
    var sy_header:RefreshView?{
        set{
            objc_setAssociatedObject(self, &headerKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
            newValue.map{ //http://www.jianshu.com/p/449cfe1b8fbb
                insertSubview($0, at: 0)
            }
        }
        get{
           return objc_getAssociatedObject(self, &headerKey) as? RefreshView
        }
    }
    
    var sy_footer:RefreshView?{
        set{
            objc_setAssociatedObject(self, &footerKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
            newValue.map{
                insertSubview($0, at: 0)
            }
        }
        get{
            return objc_getAssociatedObject(self, &footerKey) as? RefreshView
        }
    }
    
}

