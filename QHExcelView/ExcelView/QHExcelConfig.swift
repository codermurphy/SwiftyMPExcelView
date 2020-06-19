//
//  QHExcelConfig.swift
//  QHExcelView
//
//  Created by Qihe_mac on 2020/6/18.
//  Copyright © 2020 QiHe. All rights reserved.
//

import UIKit

struct QHExcelConfig {
    
    /// 是否显示菜单
    var showMenu: Bool = true {
        didSet {
            if self.showMenu == false {
                self.lockFirstCell = false
            }
        }
    }
    
    /// 锁定第一个单元格
    var lockFirstCell: Bool = false {
        didSet {
            if self.lockFirstCell == true {
                self.lockMenu = false
                self.lockFirstColumn = false
            }
        }
    }
    
    /// 是否锁定菜单栏
    var lockMenu: Bool = false
    
    /// 首付锁定第一列
    var lockFirstColumn: Bool = false
    
    /// 是否显示横坐标分割线
    var showXAaixLine: Bool = true
    
    /// 是否显示纵坐标分割线
    var showYAaxiLine: Bool = true
    
    /// 菜单栏字体和颜色
    var menuTitleFont: UIFont = .systemFont(ofSize: 12)
    var menuTitleColor: UIColor = .lightGray
    
    /// 第一列字体颜色
    var firstColumnFont: UIFont = .systemFont(ofSize: 14)
    var firstColumnColor: UIColor = .black
    
    /// 内容字体颜色
    var contentFont: UIFont = .systemFont(ofSize: 12)
    var contentColor: UIColor = .black
    
    /// 文本和图片的间距
    var titleAndIconMargin: CGFloat = 5
    
    /// cell的最大宽度
    var contentMaxWidth: CGFloat = 100
    
    /// cell内容边距
    var contentEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    
    
    /// 行数 -> 不包括菜单栏
    var row: Int = 0
    
    /// 列数
    var column: Int = 0
    
    /// 菜单
    var menuContents: [(icon: UIImage?,title: String?)] = []
    
    /// 数据源
    var contents: [(icon: UIImage?,title: String?)] = []
    
    /// 处理数据源 对数据进行分组
    var _contents: [[(icon: UIImage?,title: String?)]] {
        let result: [[(icon: UIImage?,title: String?)]] = self.contents.reduce(into: []) { (group, element) in
            
            if group.isEmpty {
                return group.append([element])
            }
            if group.last!.count < self.column  {
                group.append(group.removeLast() + [element])
            } else {
                group.append([element])
            }
        }
        return result
    }
}
