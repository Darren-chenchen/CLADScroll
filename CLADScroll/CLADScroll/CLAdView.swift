//
//  CLAdView.swift
//  CLADScroll
//
//  Created by Darren on 16/8/27.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit
typealias cellClickClosure = (HomeAdModel) -> Void

class CLAdView: UIView {
    var CLMaxSections = 100
    let ID = "adcell"
    var timer = Timer()
    var scrollSecond = 2.0
    
    var adClickClosure:cellClickClosure?

    var collectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
    var adArray = [] as NSArray
    
    static func showAdView(_ rect:CGRect,dataArray:NSArray, cellClick:@escaping cellClickClosure) -> UIView {

        let adView:CLAdView = CLAdView.init(frame: rect)
        adView.showAdDataWithModelArray(dataArray,cellClick:cellClick)
        return adView
    }
    
    fileprivate func showAdDataWithModelArray(_ dataArray:NSArray, cellClick:@escaping cellClickClosure){
        adClickClosure = cellClick
        adArray = dataArray
        // 创建collectionView
        self.setupCollectionView()
    }
    fileprivate func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame:CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height), collectionViewLayout:layout)
        layout.itemSize = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self;
        collectionView.backgroundColor = UIColor.white
        self.addSubview(collectionView)
        
        collectionView.register(CLAdCell.self, forCellWithReuseIdentifier: ID)
        // 默认显示最中间的那组
        collectionView.scrollToItem(at: IndexPath.init(row: 0, section: CLMaxSections/2), at: UICollectionViewScrollPosition.top, animated: false)
        
        self.starTimer()
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
        
        if nextItem == adArray.count {
            nextItem = 0
            nextSection += 1
        }
        
        let nextIndexPath = IndexPath.init(item: nextItem, section: nextSection)
        //3.通过动画滚动到下一个位置
        collectionView.scrollToItem(at: nextIndexPath, at: .top, animated: true)
    }
    
    func resetIndexPath() -> IndexPath{
        let itemArr = collectionView.indexPathsForVisibleItems as NSArray
        // 当前正在展示的位置
        let currentIndexPath = itemArr.lastObject

        if currentIndexPath == nil {
            return IndexPath.init(item: 0, section: CLMaxSections/2)
        }

        // 马上显示回最中间那组的数据
        let currentIndexPathReset:IndexPath = IndexPath.init(item: ((currentIndexPath! as AnyObject).item), section: CLMaxSections/2)
        collectionView .scrollToItem(at: currentIndexPathReset, at: UICollectionViewScrollPosition.top, animated: false)
        return currentIndexPathReset
    }

}

//MARK : - UICollectionViewDataSource
extension CLAdView:UICollectionViewDelegate,UICollectionViewDataSource {
func numberOfSections(in collectionView: UICollectionView) -> Int {
    return CLMaxSections
}
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return adArray.count
}
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ID, for: indexPath) as! CLAdCell
    cell.modelArray = adArray[indexPath.row] as! Array<HomeAdModel>
    cell.lableClickClosure = {(model:HomeAdModel) in
        self.adClickClosure!(model)
    }
    return cell
}
}


