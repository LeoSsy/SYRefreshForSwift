//
//  RefreshViewGifTextHeaderFooter.swift
//  SYRefreshExample_swift
//
//  Created by shusy on 2017/6/9.
//  Copyright © 2017年 SYRefresh. All rights reserved.
//

import UIKit

class RefreshViewGifTextHeaderFooter: RefreshViewGifHeaderFooter {
    private var textItem:TextItem //文本视图
    init(data:Data?,textItem:TextItem,orientation:RefreshViewOrientation,height:CGFloat,contentMode:UIViewContentMode,completion:@escaping ()->Void){
        self.textItem = textItem
        super.init(data: data, orientation: orientation, height: height, contentMode: contentMode, completion: completion)
        addSubview(self.textItem.label)
    }
    
    override func updateRefreshState(isRefreshing: Bool) {
        super.updateRefreshState(isRefreshing: isRefreshing)
        textItem.updateRefreshState(isRefreshing: isRefreshing)
    }
    
    override func updatePullProgress(progress: CGFloat) {
      super.updatePullProgress(progress: progress)
      textItem.updatePullProgress(progress: progress)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        UIView.performWithoutAnimation {
            self.imageView.frame = CGRect(x: 0, y: 0, width:bounds.height-2, height: bounds.height-2)
            imageView.center = CGPoint(x: (bounds.width - textItem.label.bounds.width - 8) * 0.5, y: bounds.midY)
            textItem.label.center = CGPoint(x: (bounds.width + imageView.bounds.width + 8) * 0.5, y: bounds.midY+5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
