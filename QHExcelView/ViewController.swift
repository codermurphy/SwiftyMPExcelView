//
//  ViewController.swift
//  QHExcelView
//
//  Created by Qihe_mac on 2020/6/18.
//  Copyright © 2020 QiHe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
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
        
        
        _ = [play,time,onPlaying,isFirst,score,backboard,assist]
        var contens: [MPExcelCellModel] = []
        for index in 0..<10000 {
            let item = MPExcelCellModel()
            item.title = String(index)
            if index % 8 == 0 {
                //item.titleColor = .red
            }
            contens.append(item)
        }
//        let layout = MPExcelCollectionViewLayout(configs: MPExcelConfig(), column: menus.count, menus: menus, contents: contens)
//        layout.autoCalCellWidth()
        let excelView = MPExcelView(configs: self.configs)
        excelView.frame = CGRect(x: 0, y: 88, width: self.view.frame.width, height: self.view.frame.height - 88)
        excelView.dataSource = self
        self.view.addSubview(excelView)
    }

}

extension ViewController: MPExcelViewDataSource {
    func numberOfColumn(_ excelView: MPExcelView) -> Int {
        return 7
    }
    
    func numberOfRow(_ excelView: MPExcelView) -> Int {
        return 100
    }
    
    func excelView(_ excelView: MPExcelView,collectionView: UICollectionView,indexPath: IndexPath,column: Int,row: Int) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MPExcelCollectionCellIdentifer", for: indexPath) as! MPExcelCollectionCell
        cell.titleLabel.text = "row: \(row) column: \(column)"
        return cell
    }
    
}


