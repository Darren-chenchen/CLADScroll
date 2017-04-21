//
//  CLAdCell.swift
//  CLADScroll
//
//  Created by Darren on 16/8/27.
//  Copyright © 2016年 darren. All rights reserved.
//

import UIKit
typealias cellLableClickClosure = (HomeAdModel) -> Void

class CLAdCell: UICollectionViewCell {
    
    var lableClickClosure:cellLableClickClosure?
    
    var modelArray:Array<HomeAdModel> = [] {
        didSet{
            let model = modelArray[0]
            titleBtn1.setTitle(model.Title2, for: UIControlState())
            contentLable1.text = model.Title
            
            let model2 = modelArray[1]
            titleBtn2.setTitle(model2.Title2, for: UIControlState())
            contentLable2.text = model2.Title
        }
    }
    
    fileprivate lazy var titleBtn1 = UIButton()
    fileprivate lazy var titleBtn2 = UIButton()
    fileprivate lazy var contentLable1 = UILabel()
    fileprivate lazy var contentLable2 = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        titleBtn1.frame = CGRect(x: 10, y: 15, width: 30, height: 15)
        titleBtn1.setTitleColor(UIColor.orange, for: UIControlState())
        titleBtn1.layer.cornerRadius = 3
        titleBtn1.layer.borderWidth = 1
        titleBtn1.layer.borderColor = UIColor.orange.cgColor
        titleBtn1.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        self.contentView.addSubview(titleBtn1)
        
        titleBtn2.frame = CGRect(x: 10, y: 35, width: 30, height: 15)
        titleBtn2.setTitleColor(UIColor.orange, for: UIControlState())
        titleBtn2.layer.cornerRadius = 3
        titleBtn2.layer.borderWidth = 1
        titleBtn2.layer.borderColor = UIColor.orange.cgColor
        titleBtn2.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        self.contentView.addSubview(titleBtn2)
        
        contentLable1.frame = CGRect(x: titleBtn1.frame.maxX+5, y: 15, width: self.contentView.frame.size.width-titleBtn1.frame.maxX+5, height: 15)
        contentLable1.font = UIFont.systemFont(ofSize: 12)
        contentLable1.isUserInteractionEnabled = true
        contentLable1.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(CLAdCell.clickContentLable1)))

        self.contentView.addSubview(contentLable1)
        contentLable2.frame = CGRect(x: titleBtn1.frame.maxX+5, y: 35, width: self.contentView.frame.size.width-titleBtn1.frame.maxX+5, height: 15)
        contentLable2.font = UIFont.systemFont(ofSize: 12)
        contentLable2.isUserInteractionEnabled = true
        contentLable2.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(CLAdCell.clickContentLable2)))

        self.contentView.addSubview(contentLable2)
        
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func clickContentLable1(){
        let model = modelArray[0]
        lableClickClosure!(model)
    }
    @objc fileprivate func clickContentLable2(){
        let model = modelArray[1]
        lableClickClosure!(model)
    }

}
