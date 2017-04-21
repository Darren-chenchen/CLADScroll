//
//  CLPictureScrollView.swift
//  CLADScroll
//
//  Created by Darren on 16/8/27.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit
 typealias pictureClickClosure = (HomeAdModel) -> Void

class CLPictureScrollView: UIView {
    var CLMaxSections = 100
    let ID = "picturecell"
    var timer = Timer()
    var scrollSecond = 2.0
    var stopAotuScroll = Bool(){
        didSet{
            if stopAotuScroll == true {
                self.stopTimer()
            }
        }
    }
    var pageController = UIPageControl()

    var netPictureClickClosure:pictureClickClosure?
    
    var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
    var adArray = [] as NSArray
    var localAdArray = [] as NSArray

    // 本地的图片
    static func showPictureViewWithLocal(_ rect:CGRect,dataArray:NSArray, cellClick:cellClickClosure) -> UIView {
        let adView:CLPictureScrollView = CLPictureScrollView.init(frame: rect)
        adView.showLocalAdDataWithLocalArray(dataArray,cellClick:cellClick)
        return adView
    }
    fileprivate func showLocalAdDataWithLocalArray(_ dataArray:NSArray, cellClick:cellClickClosure){
        localAdArray = dataArray
        // 创建collectionView
        self.setupCollectionView()
    }

    // 网络图片
    static func showNetPictureViewWithModel(_ rect:CGRect,dataArray:NSArray, cellClick:@escaping cellClickClosure) -> UIView {
        let adView:CLPictureScrollView = CLPictureScrollView.init(frame: rect)
        adView.showAdDataWithModelArray(dataArray,cellClick:cellClick)
        return adView
    }
    fileprivate func showAdDataWithModelArray(_ dataArray:NSArray, cellClick:@escaping cellClickClosure){
        netPictureClickClosure = cellClick
        adArray = dataArray
        // 创建collectionView
        self.setupCollectionView()
    }
    fileprivate func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame:CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height), collectionViewLayout:layout)
        layout.itemSize = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self;
        collectionView.backgroundColor = UIColor.white
        self.addSubview(collectionView)
        
        collectionView.register(CLPictureCell.self, forCellWithReuseIdentifier: ID)
        // 默认显示最中间的那组
        collectionView.scrollToItem(at: IndexPath.init(row: 0, section: CLMaxSections/2), at: UICollectionViewScrollPosition.left, animated: false)
        
        let pageController = UIPageControl()
        pageController.frame = CGRect(x: 0, y: self.frame.size.height-40, width: self.frame.size.width, height: 40)
        var arrayCount = 0
        if adArray.count == 0 {   // 本地图片
            arrayCount = localAdArray.count
        }
        if localAdArray.count == 0 {   // 网络图片
            arrayCount = adArray.count
        }
        pageController.numberOfPages = arrayCount
        pageController.currentPageIndicatorTintColor = UIColor.red
        pageController.pageIndicatorTintColor = UIColor.white
        
        if localAdArray.count == 1 || adArray.count == 1 {
            
        } else {
            self.addSubview(pageController)
        }
        self.pageController = pageController
        
        if stopAotuScroll == false {
            self.starTimer()
        }
    }
    
    // MARK:- 开启定时器
    func starTimer(){
        timer = Timer.scheduledTimer(timeInterval: scrollSecond, target: self, selector: #selector(nextPage), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
    }
    // MARK:- 关闭定时器
    func stopTimer(){
        timer.invalidate()
    }
    
    @objc func nextPage(){
        // 1.马上显示回最中间那组的数据
        let currentIndexPathReset:IndexPath = self.resetIndexPath()
        // 2.计算出下一个需要展示的位置
        var nextItem:Int = currentIndexPathReset.item + 1
        var nextSection:Int = currentIndexPathReset.section
        
        if localAdArray.count==0 {
            if nextItem == adArray.count {
                nextItem = 0
                nextSection += 1
            }
        } else {
            if nextItem == localAdArray.count {
                nextItem = 0
                nextSection += 1
            }
        }
        
        let nextIndexPath = IndexPath.init(item: nextItem, section: nextSection)
        //3.通过动画滚动到下一个位置
        collectionView.scrollToItem(at: nextIndexPath, at: .left, animated: true)
    }
    
    func resetIndexPath() -> IndexPath{
        let itemArr = collectionView.indexPathsForVisibleItems as NSArray
        // 当前正在展示的位置
        let currentIndexPath = itemArr.lastObject
        
        // 马上显示回最中间那组的数据
        let currentIndexPathReset:IndexPath = IndexPath.init(item: ((currentIndexPath! as AnyObject).item), section: CLMaxSections/2)
        collectionView .scrollToItem(at: currentIndexPathReset, at: UICollectionViewScrollPosition.left, animated: false)
        return currentIndexPathReset
    }
    
}

//MARK : - UICollectionViewDataSource
extension CLPictureScrollView:UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return CLMaxSections
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if localAdArray.count != 0 {
            return localAdArray.count
        } else {
            return adArray.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ID, for: indexPath) as! CLPictureCell
        if localAdArray.count != 0 {
            cell.localPictureStr = localAdArray[indexPath.row] as! String
        }
        
        // 网络图片
        if adArray.count != 0 {
            cell.model = adArray[indexPath.row] as! HomeAdModel
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 网络图片
        if adArray.count != 0 {
            let model = adArray[indexPath.row] as! HomeAdModel
            self.netPictureClickClosure!(model)
        }
    }
}

extension CLPictureScrollView:UIScrollViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.stopTimer()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if stopAotuScroll == false {
            self.starTimer()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var arrayCount = 0
        if adArray.count == 0 {   // 本地图片
            arrayCount = localAdArray.count
        }
        if localAdArray.count == 0 {   // 网络图片
            arrayCount = adArray.count
        }

        let page = Int(scrollView.contentOffset.x/scrollView.bounds.size.width+0.5)%(arrayCount)
        self.pageController.currentPage = page
    }
}

