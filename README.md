# SYRefresh

 首先感谢你的支持，SYRefresh 是一款简洁易用的刷新控件，支持scrolview,Tableview,collectionview刷新功能，具备灵活的扩展功能。

示例程序：

![MacDown Screenshot](./demoExample.gif)

[oc版本地址点击进入](https://github.com/shushaoyong/SYRefresh)

支持pod安装：

pod 'SYRefresh', '~> 1.1.2'

默认刷新控件使用方法：
	
        //添加头部刷新控件 
        scrollview：
        scrollview.sy_header = TextHeader(normalText: "12", pullingText: "222", refreshingText: "333", orientation: .top, height: 60, font: UIFont.systemFont(ofSize: 14), color: UIColor.black, completion: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self?.scrollview.sy_header?.endRefreshing()
            }
        })


        tableView：
        tableView.sy_header =  TextHeaderFooter(normalText:  "下拉可以刷新", pullingText:  "松手即可刷新", refreshingText:  "刷新中.....", nomoreDataText:  nil, orientation: .top, height: 60, font: UIFont.systemFont(ofSize: 14), color: UIColor.black) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        self.tableView.sy_header?.endRefreshing()
        }
        }
        
        //添加尾部刷新控件  
        scrollview：
        scrollview.sy_footer = TextHeader(normalText: "12", pullingText: "222", refreshingText: "333", orientation: .bottom, height: 60, font: UIFont.systemFont(ofSize: 14), color: UIColor.black, completion: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self?.scrollview.sy_footer?.endRefreshing()
            }
        })
            
        tableView：
        tableView.sy_header =  TextHeaderFooter(normalText:  "下拉可以刷新", pullingText:  "松手即可刷新", refreshingText:  "刷新中.....", nomoreDataText:  “全部加在完成”, orientation: .top, height: 60, font: UIFont.systemFont(ofSize: 14), color: UIColor.black) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        self.tableView.sy_header?.endRefreshing()
        }
        }

GIF图片刷新控件使用方法：

      let data = try! Data(contentsOf: Bundle.main.url(forResource: "giphy.gif", withExtension: nil)!)
        tableView.sy_header = GifHeaderFooter(data: data, orientation: .top, height: 100,contentMode:.scaleAspectFill,completion: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.tableView.sy_header?.endRefreshing()
            }
        })
        
        tableView.sy_footer = GifHeaderFooter(data: data, orientation: .bottom, height: 100,contentMode:.scaleAspectFill,completion: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.tableView.sy_footer?.endRefreshing()
            }
        })

GIF图片加文字刷新控件使用方法：
	
       let data = try! Data(contentsOf: Bundle.main.url(forResource: "demo-small.gif", withExtension: nil)!)
        let textItem = TextItem(normalText: RefreshConfig.headerNomalText, pullingText: RefreshConfig.headerPullingText, refreshingText: RefreshConfig.headerRefreshText, font: UIFont.systemFont(ofSize: 13), color: UIColor.black)
        collectionView?.sy_header = GifTextHeaderFooter(data: data,textItem:textItem, orientation: .top, height: 60,contentMode:.scaleAspectFit,completion: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self?.collectionView?.sy_header?.endRefreshing()
            }
        })
        
        let textItem2 = TextItem(normalText: RefreshConfig.footerNomalText, pullingText: RefreshConfig.footerPullingText, refreshingText: RefreshConfig.footerRefreshText, font: UIFont.systemFont(ofSize: 13), color: UIColor.black)

        collectionView?.sy_footer = GifTextHeaderFooter(data: data,textItem:textItem2, orientation: .bottom, height: 60,contentMode:.scaleAspectFit,completion: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self?.collectionView?.sy_footer?.endRefreshing()
            }
        })

传入gif图片数组实现gif播放：
	     
	     let header  = GifImagesHeaderFooter(orientation: .top, height: 80, contentMode: .scaleAspectFit, completion: {  [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.collectionView?.sy_header?.endRefreshing()
            }
        })
        let stateIdleImages = (1..<20).map { index->UIImage in
            let imageName = "refresh_camera_frame".appending("\(index)")
            let image = UIImage(named: imageName)
            return image!
        }
        let pullingImages = (20..<21).map { index->UIImage in
            let imageName = "refresh_camera_frame".appending("\(index)")
            let image = UIImage(named: imageName)
            return image!
        }
        let refreshingImages = (21...45).map { index->UIImage in
            let imageName = "refresh_camera_frame".appending("\(index)")
            let image = UIImage(named: imageName)
            return image!
        }
        header.setRefreshState(state: .stateIdle, images: stateIdleImages)
        header.setRefreshState(state: .pulling, images: pullingImages)
        header.setRefreshState(state: .refreshing, images: refreshingImages)
        collectionView?.sy_header =  header

        
        let footer = GifImagesHeaderFooter(orientation: .bottom, height: 60, contentMode: .scaleAspectFit, completion: {  [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.collectionView?.sy_footer?.endRefreshing()
            }
        })
        footer.setRefreshState(state: .stateIdle, images: stateIdleImages)
        footer.setRefreshState(state: .pulling, images: pullingImages)
        footer.setRefreshState(state: .refreshing, images: refreshingImages)
        collectionView?.sy_footer = footer

文字绘制动画：

        let textItem = TextItem(normalText: VerticalHintText.headerNomalText, pullingText: VerticalHintText.headerPullingText, refreshingText: VerticalHintText.headerRefreshText, font: UIFont.systemFont(ofSize: 18), color: UIColor.black)

            tableView.sy_header = CoreTextHeaderFooter(textItem: textItem, orientation: .top, height: 44,completion: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self?.tableView.sy_header?.endRefreshing()
            self?.count = 15
            self?.tableView.reloadData()
            }
        })

        let textItem1 = TextItem(normalText: VerticalHintText.headerNomalText, pullingText: VerticalHintText.headerPullingText, refreshingText: VerticalHintText.headerRefreshText, font: UIFont.systemFont(ofSize: 18), color: UIColor.black)

        tableView.sy_footer = CoreTextHeaderFooter(textItem: textItem1, orientation: .bottom, height: 44,completion: { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self?.tableView.sy_footer?.endRefreshing()
                self?.count += 15
                self?.tableView.reloadData()
                }
        })

UICollectionView的使用方法同上，如果UICollectionView需要支持水平刷新功能，请设置布局的方向为水平方向即可！

目前还不会支持cocopods，因为它还在起步阶段，等到它功能完善得到大家的认可的时候，我会放到cocopods仓库

如果你在使用中遇到了什么问题，可以直接在讨论区提出，我会及时的解决。

更多功能敬请期待！ 
