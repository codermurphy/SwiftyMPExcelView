//
//  QHExcelConfig.swift
//  QHExcelView
//
//  Created by Qihe_mac on 2020/6/18.
//  Copyright © 2020 QiHe. All rights reserved.
//

import UIKit

struct QHExcelConfig {
    
    init(column: Int,menu: [QHExcelModel],contents: [QHExcelModel],collectionViewWidth: CGFloat = UIScreen.main.bounds.width) {
        self.column = column
        let groupContents = contents.mp_group(by: column)
        self.row = groupContents.count
        self.menuContents = menu
        self.showMenu = !menu.isEmpty
        self.contents = contents
        self.collectionViewWidth = collectionViewWidth
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
                self.lockColumn = false
            }
        }
    }
    
    /// 是否锁定菜单栏
    var lockMenu: Bool = false
    
    /// 显示边框
    var showBorder: Bool = false
    var borderColor: UIColor = .lightGray
    var borderWidth: CGFloat = 1
    
    /// 首付锁定第一列
    var lockColumn: Bool = false
    var lockColumnItems: [Int] = []
    
    /// 是否显示横向分割线 颜色
    var showXAisLine: Bool = false
    var xAxisColor: UIColor = .lightGray
    var xAxisHWidth: CGFloat = 1
    
    /// 是否显示纵向分割线
    var showYAxiaiLine: Bool = false
    var yAxisColor: UIColor = .lightGray
    var yAxisHeight: CGFloat = 1
    
    
    /// 菜单栏字体和颜色,背景色
    var menuTitleFont: UIFont = .systemFont(ofSize: 12)
    var menuTitleColor: UIColor = .lightGray
    var menuBackgroundColor: UIColor = .brown
    var menuLineNubmer: Int = 1
    /// 第一列字体颜色，背景色
    var firstColumnFont: UIFont = .systemFont(ofSize: 14)
    var firstColumnColor: UIColor = .black
    var firstColumnBackgroundColor: UIColor = .white
    
    /// 内容字体颜色，背景色
    var contentFont: UIFont = .systemFont(ofSize: 12)
    var contentColor: UIColor = .black
    var contentBackgroundColor: UIColor = .white
    
    /// 文本和图片的间距
    var titleAndIconMargin: CGFloat = 5
    
    /// item的间距
    var itemSpacing: CGFloat = 0
    
    /// cell的最大宽度
    var contentMaxWidth: CGFloat = 100
    var contentLineNubmer: Int = 1
    
    /// cell的最大最小高度
    var contentMaxHeight: CGFloat = 50
    
    var contentIconSize: CGSize = CGSize(width: 24, height: 24)
    /// contentView宽度
    private var collectionViewWidth: CGFloat
    
    /// cell内容边距
    var contentEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    
    var menuEdggetInset: UIEdgeInsets = .zero

    
    var emptyTitle: String = "--"
    
    
    /// 行数 -> 不包括菜单栏
    private(set) var row: Int = 0
    
    /// 列数
    private(set) var column: Int = 0
        
    /// 菜单
    var menuContents: [QHExcelModel]
    
    /// 数据源
    var contents: [QHExcelModel]
    
    /// 处理数据源 对数据进行分组
    var _contents: [[QHExcelModel]] {

        return self.contents.mp_group(by: self.column)
    }
    
    /// 所有cell 宽度
    private(set) var contentsWidths: [CGFloat] = []
    
    /// 所有cell的高度
    private(set) var contentsHeights: [CGFloat] = []
    
    var totalHeight: CGFloat  {
        
        
        let result = self.contentsHeights.reduce(0) { $0 + $1 }
        
        return result
    }
    
    /// 刷新数据
    mutating func reloadContents(contents: [QHExcelModel]) {
        self.contents.removeAll()
        self.contents.append(contentsOf: contents)
        self.row = contents.mp_group(by: self.column).count
        self.calFitWidthAndHeights()
    }
    
    /// 获取自适应宽高
    mutating func calFitWidthAndHeights() {
        
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
            menuHeight = self.calContentSize(contents: self.menuContents, isMenu: true, isFirstColuom: false,needCalHeight: self.menuLineNubmer == 0).height
            menuWidths = self.menuContents.map { self.calContentSize(contents: [$0], isMenu: true, isFirstColuom: false,needCalHeight: self.menuLineNubmer == 0).width}
        }
        
        /// 过滤第一列，获取所有非菜单和非第一列的内容
        let contents = self._contents.map { (element) -> [QHExcelModel] in
            var result = element
            result.removeFirst()
            return result
            
        }
        
        /// 所有非菜单和非第一列的内容每一行高度
        let rowHeight = contents.map { self.calContentSize(contents: $0, isMenu: false, isFirstColuom: false,needCalHeight: self.contentLineNubmer == 0).height}
        
        /// 列内容
        var columnContents: [[QHExcelModel]] = []
        for index in 0..<self.column {
            var result: [QHExcelModel] = []
            for item in self._contents {
                if index < item.count{
                    result.append(item[index])
                }
            }
            columnContents.append(result)
        }
        
        if columnContents.isEmpty == false {
            let firstColumnConents = columnContents[0]
            /// 第一列的size信息
            fistColumnSize = firstColumnConents.map { self.calContentSize(contents: [$0], isMenu: false, isFirstColuom: true,needCalHeight: self.contentLineNubmer == 0)}
            
            columnContents.removeFirst()
            
            contentSize = columnContents.map { self.calContentSize(contents: $0, isMenu: false, isFirstColuom: false,needCalHeight: self.contentLineNubmer == 0)}
            
        }
        
        /// 构建每行的高度
        for (index,size) in fistColumnSize.enumerated() {
            resultHeight.append(max(size.height, rowHeight[index]))
        }
        
        resultHeight.insert(menuHeight, at: 0)
        if self.showMenu  {
            if resultHeight.count < self.row + 1 {
                for _ in 0..<((self.row + 1) - resultHeight.count) {
                    let min = resultHeight.min() ?? 0
                    resultHeight.append(min)
                }
            }
        }
        else {
            if resultHeight.count < self.row {
                for _ in 0..<(self.row - resultHeight.count) {
                    let min = resultHeight.min() ?? 0
                    resultHeight.append(min)
                }
            }
        }
        
        /// 构建每列的宽度
        
        
        if self.showMenu {
            
            if !menuWidths.isEmpty {
                let firstWidth = max(fistColumnSize.max { $0.width < $1.width }?.width ?? 0, menuWidths[0])
                ressultWidth.append(firstWidth)
                for (index,item) in contentSize.enumerated() {
                    ressultWidth.append(max(item.width, menuWidths[index + 1]))
                }
            }
            else {
                let firstWidth = fistColumnSize.max { $0.width < $1.width }?.width ?? 0
                ressultWidth.append(firstWidth)
                ressultWidth.append(contentsOf: contentSize.map{ $0.width})
            }
        }
        else {
            let firstWidth = fistColumnSize.max { $0.width < $1.width }?.width ?? 0
            ressultWidth.append(firstWidth)
            ressultWidth.append(contentsOf: contentSize.map{ $0.width})
        }
        
        if ressultWidth.count < self.column {
            for _ in 0..<(self.column -  ressultWidth.count) {
                let min = ressultWidth.min() ?? 0
                ressultWidth.append(min)
            }
        }
        
        let totalWidth = ressultWidth.reduce(0) { $0 + $1 }
        
        
        if totalWidth < self.collectionViewWidth {
            if self.column > 0 {
                self.itemSpacing = (self.collectionViewWidth - totalWidth) / CGFloat(self.column + 1)
            }
        }
        
        for (index,width) in ressultWidth.enumerated() {
            
            if index == 0 || index == ressultWidth.count - 1 {
                self.contentsWidths.append(width + self.itemSpacing + self.itemSpacing * 0.5)
            }
            else {
                self.contentsWidths.append(width + self.itemSpacing)
            }
        }

        
        //self.contentsWidths = ressultWidth.map { $0 + self.itemSpacing + self.itemSpacing * 0.5 }
        self.contentsHeights = resultHeight
        
    }
    
    private func calContentSize(contents:  [QHExcelModel],isMenu: Bool,isFirstColuom: Bool,needCalHeight: Bool) -> CGSize {
        guard contents.isEmpty == false else { return CGSize(width: 0, height: 0)}
        var width: CGFloat = 0
        
        var iconHeight: CGFloat = 0
        var iconWidth: CGFloat = 0
        var titleWidth: CGFloat = 0
        var titleHeight: CGFloat = 0
        
        var font: UIFont = self.contentFont

        let info = (isMenu,isFirstColuom)
        var edgeInset: UIEdgeInsets = .zero
        switch info {
        case (true,true):
            font = self.menuTitleFont
            edgeInset = self.menuEdggetInset
        case (true,false):
            font = self.menuTitleFont
            edgeInset = self.menuEdggetInset
        case (false,true):
            font = self.firstColumnFont
            edgeInset = self.contentEdgeInsets
        case (false,false):
            edgeInset = self.contentEdgeInsets
            font = self.contentFont
        }
        

        
        let maxContent = contents.reduce(contents[0]) { (pre, next) -> QHExcelModel in
            let preImage = pre.icon != nil ? self.contentIconSize.width : 0
            let preTitleCount = pre.title != nil ? NSAttributedString(string: pre.title!, attributes: [NSAttributedString.Key.font : font]).size().width : 0
            let preSum = CGFloat(preImage) + preTitleCount
            let nextImage = next.icon != nil ? self.contentIconSize.width : 0
            let nexTitleCount = next.title != nil ? NSAttributedString(string: next.title!, attributes: [NSAttributedString.Key.font : font]).size().width : 0
            let nextSum = CGFloat(nextImage) + nexTitleCount
            return max(preSum, nextSum) == preSum ? pre : next
        }
        
        
        if let _ = maxContent.icon {
            iconWidth = self.contentIconSize.width
            iconHeight = self.contentIconSize.height
        }
        if let title = maxContent.title {
            let attrString = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font : font])
            var size = attrString.size()
            titleHeight = size.height
            if iconWidth != 0 {
                if size.width + iconWidth + self.titleAndIconMargin + edgeInset.left + edgeInset.right > self.contentMaxWidth {
                    
                    let rect = CGSize(width: self.contentMaxWidth - (iconWidth + self.titleAndIconMargin + edgeInset.left + edgeInset.right), height: CGFloat.greatestFiniteMagnitude)
                    
                    size = attrString.boundingRect(with: rect, options: [.usesLineFragmentOrigin,.usesFontLeading], context: nil).size
                        
                    titleWidth = rect.width
                    if needCalHeight { titleHeight = size.height }
                    width = titleWidth + iconWidth + self.titleAndIconMargin + edgeInset.left + edgeInset.right
                    
                }
                else {
                    titleWidth = size.width
                    titleHeight = size.height
                    width = titleWidth + iconWidth + self.titleAndIconMargin + edgeInset.left + edgeInset.right
                }
            }
            else {
                if size.width + edgeInset.left + edgeInset.right > self.contentMaxWidth {
                    let rect = CGSize(width: self.contentMaxWidth - (edgeInset.left + edgeInset.right), height: CGFloat.greatestFiniteMagnitude)
                                           
                    size = attrString.boundingRect(with: rect, options: [.usesLineFragmentOrigin,.usesFontLeading], context: nil).size
                    
                    titleWidth = rect.width
                    if needCalHeight { titleHeight = size.height }
                    width = titleWidth + edgeInset.left + edgeInset.right
                }
                else {
                    titleWidth = size.width
                    width = titleWidth + edgeInset.left + edgeInset.right
                }
            }
        }
        
        let height = max(iconHeight,titleHeight) + edgeInset.top + edgeInset.bottom
        
        
        return CGSize(width: width, height: height)
    }
}
