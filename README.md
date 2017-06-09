# SYRefresh
一款简洁易用的刷新控件

示例程序：

![MacDown Screenshot](./demoExample.gif)

此次更新了刷新控件的创建方式为传入指定方向设置指定方向的刷新控件，删除原来创建的方法

[oc版本地址点击进入](https://github.com/shushaoyong/SYRefresh)

默认刷新控件使用方法：
	
        //添加头部刷新控件 
        scrollview：
        scrollview.sy_header = RefreshTextHeader(normalText: "12", pullingText: "222", refreshingText: "333", orientation: .top, height: 60, font: UIFont.systemFont(ofSize: 14), color: UIColor.black, completion: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self?.scrollview.sy_header?.endRefreshing()
            }
        })


        tableView：
        tableView.sy_header = RefreshTextHeader(normalText: "12", pullingText: "222", refreshingText: "333", orientation: .top, height: 60, font: UIFont.systemFont(ofSize: 14), color: UIColor.black, completion: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self?.tableView.sy_header?.endRefreshing()
            }
        })
        
        //添加尾部刷新控件  
        scrollview：
        scrollview.sy_footer = RefreshTextHeader(normalText: "12", pullingText: "222", refreshingText: "333", orientation: .bottom, height: 60, font: UIFont.systemFont(ofSize: 14), color: UIColor.black, completion: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self?.scrollview.sy_footer?.endRefreshing()
            }
        })
            
        tableView：
        tableView.sy_footer = RefreshTextHeader(normalText: "12", pullingText: "222", refreshingText: "333", orientation: .bottom, height: 60, font: UIFont.systemFont(ofSize: 14), color: UIColor.black, completion: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self?.tableView.sy_footer?.endRefreshing()
            }
        })

GIF图片刷新控件使用方法：

      let data = try! Data(contentsOf: Bundle.main.url(forResource: "giphy.gif", withExtension: nil)!)
        tableView.sy_header = RefreshViewGifHeaderFooter(data: data, orientation: .top, height: 100,contentMode:.scaleAspectFill,completion: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.tableView.sy_header?.endRefreshing()
            }
        })
        
        tableView.sy_footer = RefreshViewGifHeaderFooter(data: data, orientation: .bottom, height: 100,contentMode:.scaleAspectFill,completion: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.tableView.sy_footer?.endRefreshing()
            }
        })

GIF图片加文字刷新控件使用方法：
	
       let data = try! Data(contentsOf: Bundle.main.url(forResource: "demo-small.gif", withExtension: nil)!)
        let textItem = TextItem(normalText: RefreshConfig.headerNomalText, pullingText: RefreshConfig.headerPullingText, refreshingText: RefreshConfig.headerRefreshText, font: UIFont.systemFont(ofSize: 13), color: UIColor.black)
        collectionView?.sy_header = RefreshViewGifTextHeaderFooter(data: data,textItem:textItem, orientation: .top, height: 60,contentMode:.scaleAspectFit,completion: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self?.collectionView?.sy_header?.endRefreshing()
            }
        })
        
        let textItem2 = TextItem(normalText: RefreshConfig.footerNomalText, pullingText: RefreshConfig.footerPullingText, refreshingText: RefreshConfig.footerRefreshText, font: UIFont.systemFont(ofSize: 13), color: UIColor.black)

        collectionView?.sy_footer = RefreshViewGifTextHeaderFooter(data: data,textItem:textItem2, orientation: .bottom, height: 60,contentMode:.scaleAspectFit,completion: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self?.collectionView?.sy_footer?.endRefreshing()
            }
        })

UICollectionView的使用方法同上，如果UICollectionView需要支持水平刷新功能，请设置布局的方向为水平方向即可！
 更多功能敬请期待！ 此控件会持续的更新和完善
