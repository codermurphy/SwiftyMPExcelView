//
//  ViewController.swift
//  QHExcelView
//
//  Created by Qihe_mac on 2020/6/18.
//  Copyright © 2020 QiHe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var menus: [MPExcelCellModel] = []
    var contents: [MPExcelCellModel] = []
    
    var configs: MPExcelConfig!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        
        let play = MPExcelCellModel()
        play.image = UIImage(named: "wode")
        play.title = "球员"
        
        let time = MPExcelCellModel()
        //time.icon = UIImage(named: "wode")
        time.title = "时间"
        
        let onPlaying = MPExcelCellModel()
        onPlaying.title = "在场"
        
        let isFirst = MPExcelCellModel()
        isFirst.title = "首发"
        
        let score = MPExcelCellModel()
        score.title = "得分"
        
        let backboard = MPExcelCellModel()
        backboard.title = "篮板"
        
        let assist = MPExcelCellModel()
        assist.title = "助攻"
        
        
        self.menus = [play,time,onPlaying,isFirst,score,backboard,assist]
        for index in 0..<100 {
            let item = MPExcelCellModel()
            item.title = String(index)
            if index % 8 == 0 {
                //item.titleColor = .red
            }
            self.contents.append(item)
        }
//        let layout = MPExcelCollectionViewLayout(configs: MPExcelConfig(), column: menus.count, menus: menus, contents: contens)
//        layout.autoCalCellWidth()
        
        self.configs.isAutoCalWidth = true
        self.configs.isAutoCalHeight = true
        
        let excelView = MPExcelView(configs: self.configs)
        
        let totolContent = self.menus + self.contents
        let row = totolContent.count % self.menus.count == 0 ? totolContent.count / self.menus.count : totolContent.count / self.menus.count + 1
        excelView.autoCalCellWidth(contents: totolContent,totoalColumn: self.menus.count,totalRow: row,contentWidth: self.view.frame.size.width)

        excelView.frame = CGRect(x: 0, y: 88, width: self.view.frame.width, height: self.view.frame.height - 88)
        excelView.dataSource = self

        self.view.addSubview(excelView)
    }

}

extension ViewController: MPExcelViewDataSource {
    func numberOfColumn(_ excelView: MPExcelView) -> Int {
        return self.menus.count
    }
    
    func numberOfRow(_ excelView: MPExcelView) -> Int {
        let totolContent = self.menus + self.contents
        let row = totolContent.count % self.menus.count == 0 ? totolContent.count / self.menus.count : totolContent.count / self.menus.count + 1
        return row
    }
    
    func excelView(_ excelView: MPExcelView,collectionView: UICollectionView,indexPath: IndexPath,column: Int,row: Int) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MPExcelCollectionCellIdentifer", for: indexPath) as! MPExcelCollectionCell
        let totolContent = self.menus + self.contents
        if indexPath.row < totolContent.count {
            let content = totolContent[indexPath.row]
            cell.titleLabel.text = content.title

        }
        return cell
    }
    
}


