//
//  ViewController.swift
//  QHExcelView
//
//  Created by Qihe_mac on 2020/6/18.
//  Copyright © 2020 QiHe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       // self.view.adds
        
        // Do any additional setup after loading the view.
        
        var play = QHExcelModel()
        play.title = "球员"
        
        var time = QHExcelModel()
        //time.icon = UIImage(named: "wode")
        time.title = "时间"
        
        var onPlaying = QHExcelModel()
        onPlaying.title = "在场"
        
        var isFirst = QHExcelModel()
        isFirst.title = "首发"
        
        var score = QHExcelModel()
        score.title = "得分"
        
        var backboard = QHExcelModel()
        backboard.title = "篮板"
        
        var assist = QHExcelModel()
        assist.title = "助攻"
        
        var steal = QHExcelModel()
        steal.title = "抢断2"
        
        var steal2 = QHExcelModel()
        steal2.title = "抢断3"
        
        var steal3 = QHExcelModel()
        steal3.title = "抢断4"
        
        var steal4 = QHExcelModel()
        steal4.title = "抢断5"
        
        var steal5 = QHExcelModel()
        steal5.title = "抢断6"
        
        let menus = [play,time,onPlaying,isFirst,score,backboard,assist,steal,steal2,steal3,steal4,steal5]
        var contens: [QHExcelModel] = []
        for index in 0..<600 {
            var item = QHExcelModel()
            item.title = String(index)
            if index % 8 == 0 {
                item.titleColor = .red
            }
            contens.append(item)
        }

        var config = QHExcelConfig(column: menus.count,menu: menus, contents: contens)
        config.lockMenu = true
        config.lockColumn = true
        config.lockColumnItems = [0,1]
        let contentView = QHExcelView(config: config)

        contentView.frame = CGRect(x: 0, y: 88, width: self.view.bounds.width, height: self.view.bounds.height - 88)
        self.view.addSubview(contentView)
        
        
//        var config2 = QHExcelConfig()
//        config2.row = 5
//        config2.column = 8
//        config2.lockFirstColumn = true
//        config2.menuContents = [(nil,"球员"),(nil,"时间"),(nil,"在场"),(nil,"首发"),(nil,"得分"),(nil,"篮板"),(nil,"助攻"),(nil,"抢断")]
//
//        for index in 0..<40 {
//            config2.contents.append((nil,String(index)))
//        }
//
//        let contentView2 = QHExcelView(config: config2)
//
//        contentView2.frame = CGRect(x: 0, y: contentView.frame.origin.y + contentView.frame.height + 20, width: self.view.bounds.width, height: 180)
//        self.view.addSubview(contentView2)
//
//
//        var config3 = QHExcelConfig()
//        config3.row = 6
//        config3.column = 8
//        config3.lockMenu = true
//        config3.menuContents = [(nil,"球员"),(nil,"时间"),(nil,"在场"),(nil,"首发"),(nil,"得分"),(nil,"篮板"),(nil,"助攻"),(nil,"抢断")]
//
//        for index in 0..<40 {
//            config3.contents.append((nil,String(index)))
//        }
//
//        let contentView3 = QHExcelView(config: config3)
//
//        contentView3.frame = CGRect(x: 0, y: contentView2.frame.origin.y + contentView.frame.height + 20, width: self.view.bounds.width, height: 180)
//        self.view.addSubview(contentView3)
//
//
//        var config4 = QHExcelConfig()
//        config4.row = 6
//        config4.column = 8
//        config4.lockMenu = true
//        config4.lockFirstColumn = true
//        config4.menuContents = [(nil,"球员"),(nil,"时间"),(nil,"在场"),(nil,"首发"),(nil,"得分"),(nil,"篮板"),(nil,"助攻"),(nil,"抢断")]
//
//        for index in 0..<40 {
//            config4.contents.append((nil,String(index)))
//        }
//
//        let contentView4 = QHExcelView(config: config4)
//
//        contentView4.frame = CGRect(x: 0, y: contentView3.frame.origin.y + contentView.frame.height + 20, width: self.view.bounds.width, height: 180)
//        self.view.addSubview(contentView4)
    }


    private lazy var contentView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 44, width: self.view.bounds.width, height: self.view.bounds.height - 44), style: .plain)
        
        return tableView
    }()
}


