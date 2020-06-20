//
//  QHExcelConfig.swift
//  QHExcelView
//
//  Created by Qihe_mac on 2020/6/18.
//  Copyright © 2020 QiHe. All rights reserved.
//

import UIKit

struct QHExcelConfig {
    
    init(row: Int,column: Int,menu: [(icon: UIImage?,title: String)],contents: [(icon: UIImage?,title: String?)]) {
        self.row = row
        self.column = column
        self.menuContents = menu
        self.showMenu = !menu.isEmpty
        self.contents = contents
        self.calFitWidthAndHeights()
    }
    
    /// 是否显示菜单
    private(set) var showMenu: Bool = true {
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
    
    /// 菜单栏字体和颜色,背景色
    var menuTitleFont: UIFont = .systemFont(ofSize: 12)
    var menuTitleColor: UIColor = .lightGray
    var menuBackgroundColor: UIColor = .brown
    
    /// 第一列字体颜色，背景色
    var firstColumnFont: UIFont = .systemFont(ofSize: 14)
    var firstColumnColor: UIColor = .black
    var firstColumnBackgroundColor: UIColor = .blue
    
    /// 内容字体颜色，背景色
    var contentFont: UIFont = .systemFont(ofSize: 12)
    var contentColor: UIColor = .black
    var contentBackgroundColor: UIColor = .white
    
    /// 文本和图片的间距
    var titleAndIconMargin: CGFloat = 5
    
    /// cell的最大最小宽度
    var contentMaxWidth: CGFloat = 100
    var contentMinWidth: CGFloat = 50
    
    /// cell的最大最小高度
    var contentMaxHeight: CGFloat = 50
    var contentMinHeight: CGFloat = 30
    
    /// cell内容边距
    var contentEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    
    
    /// 行数 -> 不包括菜单栏
    private(set) var row: Int = 0
    
    /// 列数
    private(set) var column: Int = 0
        
    /// 菜单
    private(set) var menuContents: [(icon: UIImage?,title: String?)]
    
    /// 数据源
    private(set) var contents: [(icon: UIImage?,title: String?)]
    
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
    
    /// 所有cell 宽度
    private(set) var contentsWidths: [CGFloat] = []
    
    /// 所有cell的高度
    private(set) var contentsHeights: [CGFloat] = []
    
    var totalHeight: CGFloat  {
        
        
        let result = self.contentsHeights.reduce(0) { $0 + $1 }
        
        return result
    }
    
    /// 获取自适应宽高
    private mutating func calFitWidthAndHeights() {
        
        self.contentsWidths.removeAll()
        self.contentsHeights.removeAll()
        
        var resultHeight: [CGFloat] = []
        var ressultWidth: [CGFloat] = []
        
        /// 菜单栏高度
        var menuHeight: CGFloat = 0
        
        /// 菜单栏宽度
        var menuWidths: [CGFloat] = []
        
        /// 第一列宽高
        var fistColumnSize: [CGSize] = []
        
        /// 所有非菜单和非第一列的内容的size
        var contentSize: [CGSize] = []
        
        if self.showMenu {
            menuHeight = self.calContentSize(contents: self.menuContents, isMenu: true, isFirstColuom: false).height
            menuWidths = self.menuContents.map { self.calContentSize(contents: [$0], isMenu: true, isFirstColuom: false).width}
        }
        
        /// 过滤第一列，获取所有非菜单和非第一列的内容
        let contents = self._contents.map { (element) -> [(icon: UIImage?,title: String?)] in
            var result = element
            result.removeFirst()
            return result
            
        }
        
        /// 所有非菜单和非第一列的内容每一行高度
        let rowHeight = contents.map { self.calContentSize(contents: $0, isMenu: false, isFirstColuom: false).height}
        
        /// 列内容
        var columnContents: [[(icon: UIImage?,title: String?)]] = []
        for index in 0..<self.column {
            var result: [(icon: UIImage?,title: String?)] = []
            for item in self._contents {
                result.append(item[index])
            }
            columnContents.append(result)
        }
        
        if columnContents.isEmpty == false {
            let firstColumnConents = columnContents[0]
            /// 第一列的size信息
            fistColumnSize = firstColumnConents.map { self.calContentSize(contents: [$0], isMenu: true, isFirstColuom: false)}
            
            columnContents.removeFirst()
            
            contentSize = columnContents.map { self.calContentSize(contents: $0, isMenu: false, isFirstColuom: false)}
            
        }
        
        /// 构建每行的高度
        for (index,size) in fistColumnSize.enumerated() {
            resultHeight.append(max(size.width, rowHeight[index]))
        }
        
        resultHeight.insert(menuHeight, at: 0)
        if self.showMenu  {
            if resultHeight.count < self.row + 1 {
                for _ in 0..<((self.row + 1) - resultHeight.count) {
                    resultHeight.append(self.contentMinHeight)
                }
            }
        }
        else {
            if resultHeight.count < self.row {
                for _ in 0..<(self.row - resultHeight.count) {
                    resultHeight.append(self.contentMinHeight)
                }
            }
        }
        
        /// 构建每列的宽度
        
        
        if self.showMenu {
            
            if !menuWidths.isEmpty {
                let firstWidth = max(fistColumnSize.max { $0.width > $1.width }?.width ?? self.contentMinWidth, menuWidths[0])
                ressultWidth.append(firstWidth)
                for (index,item) in contentSize.enumerated() {
                    ressultWidth.append(max(item.width, menuWidths[index + 1]))
                }
            }
            else {
                let firstWidth = fistColumnSize.max { $0.width > $1.width }?.width ?? self.contentMinWidth
                ressultWidth.append(firstWidth)
                ressultWidth.append(contentsOf: contentSize.map{ $0.width})
            }
        }
        else {
            let firstWidth = fistColumnSize.max { $0.width > $1.width }?.width ?? self.contentMinWidth
            ressultWidth.append(firstWidth)
            ressultWidth.append(contentsOf: contentSize.map{ $0.width})
        }
        
        if ressultWidth.count < self.column {
            for _ in 0..<(self.column -  ressultWidth.count) {
                ressultWidth.append(self.contentMinWidth)
            }
        }
        
        let totalWidth = ressultWidth.reduce(0) { $0 + $1 }
        
        if totalWidth < UIScreen.main.bounds.width {
            let avgWidth = UIScreen.main.bounds.width / CGFloat(self.column)
            for index in 0..<self.column {
                if ressultWidth[index] > avgWidth {
                    self.contentsWidths.append(ressultWidth[index])

                }
                else {
                    self.contentsWidths.append(avgWidth)

                }
            }
        }
        else {
            self.contentsWidths = ressultWidth
        }
        
        //self.contentsWidths = ressultWidth
        self.contentsHeights = resultHeight
        
    }
    
    private func calContentSize(contents:  [(icon: UIImage?,title: String?)],isMenu: Bool,isFirstColuom: Bool) -> CGSize {
        guard contents.isEmpty == false else { return CGSize(width: self.contentMinWidth, height: self.contentMinHeight)}
        var width: CGFloat = 0
        
        var iconHeight: CGFloat = 0
        var iconWidth: CGFloat = 0
        var titleWidth: CGFloat = 0
        var titleHeight: CGFloat = 0
        
        var font: UIFont = self.contentFont

        let info = (isMenu,isFirstColuom)
        
        switch info {
        case (true,true):
            font = self.contentFont
        case (true,false):
            font = self.menuTitleFont
        case (false,true):
            font = self.firstColumnFont
        case (false,false):
            font = self.contentFont
        }
        
        
        
        let maxContent = contents.reduce(contents[0]) { (pre, next) -> (icon: UIImage?,title: String?) in
            let preImage = pre.icon != nil ? 1 : 0
            let preTitleCount = pre.title != nil ? pre.title!.count : 0
            let preSum = preImage + preTitleCount
            let nextImage = next.icon != nil ? 1 : 0
            let nexTitleCount = next.title != nil ? next.title!.count : 0
            let nextSum = nextImage + nexTitleCount
            return max(preSum, nextSum) == preSum ? pre : next
        }
        
        
        if let icon = maxContent.icon {
            iconWidth = icon.size.width
            iconHeight = icon.size.height
        }
        if let title = maxContent.title {
            let attrString = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font : font])
            var size = attrString.size()
            
            if iconWidth != 0 {
                if size.width + iconWidth + self.titleAndIconMargin + self.contentEdgeInsets.left + self.contentEdgeInsets.right > self.contentMaxWidth {
                    
                    let rect = CGSize(width: self.contentMaxWidth - (iconWidth + self.titleAndIconMargin + self.contentEdgeInsets.left + self.contentEdgeInsets.right), height: CGFloat.greatestFiniteMagnitude)
                    
                    size = attrString.boundingRect(with: rect, options: [.usesLineFragmentOrigin,.usesFontLeading], context: nil).size
                        
                    titleWidth = rect.width
                    titleHeight = size.height
                    width = titleWidth + iconWidth + self.titleAndIconMargin + self.contentEdgeInsets.left + self.contentEdgeInsets.right
                    
                }
                else {
                    titleWidth = size.width
                    titleHeight = size.height
                    width = titleWidth + iconWidth + self.titleAndIconMargin + self.contentEdgeInsets.left + self.contentEdgeInsets.right
                }
            }
            else {
                if size.width + self.contentEdgeInsets.left + self.contentEdgeInsets.right > self.contentMaxWidth {
                    let rect = CGSize(width: self.contentMaxWidth - (self.contentEdgeInsets.left + self.contentEdgeInsets.right), height: CGFloat.greatestFiniteMagnitude)
                                           
                    size = attrString.boundingRect(with: rect, options: [.usesLineFragmentOrigin,.usesFontLeading], context: nil).size
                    
                    titleWidth = rect.width
                    titleHeight = size.height
                    width = titleWidth + self.contentEdgeInsets.left + self.contentEdgeInsets.right
                }
                else {
                    titleWidth = size.width
                    titleHeight = size.height
                    width = titleWidth + self.contentEdgeInsets.left + self.contentEdgeInsets.right
                }
            }
        }
        
        let height = max(iconHeight,titleHeight) + self.contentEdgeInsets.top + self.contentEdgeInsets.bottom
        
        
        return CGSize(width: width == 0 ? self.contentMinWidth : width, height: height == 0 ? self.contentMinHeight : height)
    }
}
