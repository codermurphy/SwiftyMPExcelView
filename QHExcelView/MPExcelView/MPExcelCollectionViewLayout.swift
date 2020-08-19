//
//  MPExcelCollectionViewLayout.swift
//  QHExcelView
//
//  Created by Qihe_mac on 2020/7/22.
//  Copyright © 2020 QiHe. All rights reserved.
//

import UIKit

public class MPExcelCollectionViewLayout: UICollectionViewFlowLayout {
    
    
    // MARK: - initial methods
    init(configs: MPExcelConfig,column: Int,menus: [MPExcelCellModel],contents: [MPExcelCellModel]) {
        assert(column > 0, "column must be greater than 0")
        self.configs = configs
        self.column = column
        let row = contents.count % self.column == 0 ? contents.count / self.column : contents.count / self.column + 1
        self.row = configs.showMenu ?  row + 1 : row
        self.menus = menus
        self.contents = contents
        super.init()
        self.fillEmptyModel()

    }
    
    public override init() {
        super.init()
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - property
    
    /// 列数
    var column = 0 {
        didSet {
            self.widths = Array(repeating: 0.0, count: self.column)
        }
    }
    
    /// 列数
    var row = 0 {
        didSet {
            self.heights = Array(repeating: 0.0, count: self.row)
        }
    }
    
    /// 配置信息
    var configs: MPExcelConfig?
        
    /// 内容数据源
    private var contents: [MPExcelCellModel] = []
    
    /// 菜单数据源
    private var menus: [MPExcelCellModel] = []
    
    /// 所有数据源
    private var allContents: [MPExcelCellModel] = []
    
    /// 所有的布局信息
    private var totalAttributes: [UICollectionViewLayoutAttributes] = []
    
    
    private var lastAttribute: UICollectionViewLayoutAttributes?
    
    private var lastPointX: CGFloat = 0
    
    private var lastPointY: CGFloat = 0
    
    private var widths: [CGFloat] = []
    private var heights: [CGFloat] = []
    
    /// 填充contents 让 contents.count  =  row * column
    func fillEmptyModel() {
        guard let nonilConfig = self.configs else { return }
        self.allContents = nonilConfig.showMenu ? self.menus + self.contents : self.contents
        let allCount = self.allContents.count
        let total = self.row * self.column
        guard allCount != total else { return }
        let dis = allCount % total
        for _ in 0..<dis {
            self.allContents.append(MPExcelCellModel())
        }
        
    }
    
    // MARK: - 计算单元格宽度
     func autoCalCellWidth() {
        guard let nonilConfig = self.configs else { return }
        if nonilConfig.isAutoCalWidth {
            for columnIndex in 0..<self.column {
                var targetIndexs: [Int] = []
                for rowIndex in 0..<self.row {
                    targetIndexs.append(columnIndex + rowIndex * self.column)
                }
                var targetItems: [MPExcelCellModel] = []
                for index in targetIndexs {
                    targetItems.append(self.allContents[index])
                }
                debugPrint(targetItems)
//                let maxItem = targetItems.max { (item1, item2) -> Bool in
//                    let firstIndex = targetItems.firstIndex { $0 == item1 } ?? 0
//                    let secondIndex =  targetItems.firstIndex { $0 == item2 } ?? 0
//
//                    let firstFont = firstIndex == 0 ? nonilConfig.menuFont : !nonilConfig.lockColumns.contains(firstIndex) ? nonilConfig.contentFont : nonilConfig.fixedColumnFont ?? nonilConfig.contentFont
//                    let secondFont = secondIndex == 0 ? nonilConfig.menuFont : !nonilConfig.lockColumns.contains(secondIndex) ? nonilConfig.contentFont : nonilConfig.fixedColumnFont ?? nonilConfig.contentFont
//                    let result = self.calItemsSize(item1: item1, item1Font: firstFont, item2: item2, item2Font: secondFont)
//
//                    return result.0 < result.1
//                }
//                if let nonilMaxItem = maxItem {
//                    self.widths.append(nonilMaxItem.fitSize.width)
//                }
//                else {
//                    self.widths.append(nonilConfig.maxWidth)
//                }

            }
        }
        else {
            self.widths.append(nonilConfig.maxWidth)
        }
        debugPrint(self.widths)
    }
     // MARK: - 计算单元格高度
    private func autoCalCellHeight() {
        guard let nonilConfig = self.configs else { return }
        if nonilConfig.isAutoCalHeight {
            if nonilConfig.showMenu {
                for item in self.menus {
                    
                }
            }
            
            for (item,index) in self.contents.enumerated() {
                
            }
        }
        else {
            
        }
    }
    
    private func calItemsSize(item1: MPExcelCellModel,item1Font: UIFont,item2: MPExcelCellModel,item2Font: UIFont) -> (CGFloat,CGFloat) {
        guard let nonilConfig = self.configs else { return (0,0)}
        let preImage = (item1.image != nil || item1.imageUrl != nil) ? nonilConfig.imageSize : .zero
        let preTitleSize = item1.title != nil ? NSAttributedString(string: item1.title!, attributes: [NSAttributedString.Key.font : item1Font]).size() : .zero
        let nextImage = (item2.image != nil || item2.imageUrl != nil) ? nonilConfig.imageSize : .zero
        let nexTitleSize = item2.title != nil ? NSAttributedString(string: item2.title!, attributes: [NSAttributedString.Key.font : item2Font]).size() : .zero
        switch nonilConfig.imageAndTextPosition {
        case .top,.bottom:
            let contentWidth1 = max(preImage.width,preTitleSize.width)
            let resultWidth1 = contentWidth1 + nonilConfig.edgeInsets.left + nonilConfig.edgeInsets.right > nonilConfig.maxWidth ? nonilConfig.maxWidth : contentWidth1
            let contentHeight1 = preImage.height + preTitleSize.height + nonilConfig.imageAndTextSpacing
            let resultHeight1 = contentHeight1 + nonilConfig.edgeInsets.top + nonilConfig.edgeInsets.bottom > nonilConfig.maxHeight ? nonilConfig.maxHeight : contentHeight1
            item1.fitSize = CGSize(width: resultWidth1, height: resultHeight1)
            
            let contentWidth2 = max(nextImage.width,nexTitleSize.width)
            let resultWidth2 = contentWidth2 + nonilConfig.edgeInsets.left + nonilConfig.edgeInsets.right > nonilConfig.maxWidth ? nonilConfig.maxWidth : contentWidth2
            let contentHeight2 = nextImage.height + nexTitleSize.height + nonilConfig.imageAndTextSpacing
            let resultHeight2 = contentHeight2 + nonilConfig.edgeInsets.top + nonilConfig.edgeInsets.bottom > nonilConfig.maxHeight ? nonilConfig.maxHeight : contentHeight2
            item2.fitSize = CGSize(width: resultWidth2, height: resultHeight2)
            
        case .left,.right:
            
            let contentWidth1 = preImage.width + preTitleSize.width + nonilConfig.imageAndTextSpacing
            let resultWidth1 = contentWidth1 + nonilConfig.edgeInsets.left + nonilConfig.edgeInsets.right > nonilConfig.maxWidth ? nonilConfig.maxWidth : contentWidth1
            let contentHeight1 = preImage.height + preTitleSize.height + nonilConfig.imageAndTextSpacing
            let resultHeight1 = contentHeight1 + nonilConfig.edgeInsets.top + nonilConfig.edgeInsets.bottom > nonilConfig.maxHeight ? nonilConfig.maxHeight : contentHeight1
            item1.fitSize = CGSize(width: resultWidth1, height: resultHeight1)
            
            let contentWidth2 = max(nextImage.width,nexTitleSize.width)
            let resultWidth2 = contentWidth2 + nonilConfig.edgeInsets.left + nonilConfig.edgeInsets.right > nonilConfig.maxWidth ? nonilConfig.maxWidth : contentWidth2
            let contentHeight2 = nextImage.height + nexTitleSize.height + nonilConfig.imageAndTextSpacing
            let resultHeight2 = contentHeight2 + nonilConfig.edgeInsets.top + nonilConfig.edgeInsets.bottom > nonilConfig.maxHeight ? nonilConfig.maxHeight : contentHeight2
            item2.fitSize = CGSize(width: resultWidth2, height: resultHeight2)
        }
        return (item1.fitSize.width,item2.fitSize.width)
    }
    
    // MARK: - prepare
    
    public override func prepare() {
        super.prepare()
        
        self.lastPointX = 0
        self.lastPointY = 0
        self.widths = Array(repeating: 0.0, count: self.column)
        self.heights = Array(repeating: 0.0, count: self.row)
        self.totalAttributes.removeAll()
        
        
        
        self.setUpAttrs()
    }
    
    // MARK: - create IndexPaths
    private func setUpAttrs() {
        guard let collectionView = self.collectionView else { return }
        for section in 0..<collectionView.numberOfSections {
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                                
                guard let attr = self.layoutAttributesForItem(at: indexPath) else { self.totalAttributes.removeAll(); return }
                self.totalAttributes.append(attr)
            }
        }
        
        
        
    }
    
    /// 可滚动size
    public override var collectionViewContentSize: CGSize {
        
//        guard let nonilConfigs = self.configs,let collectionView = self.collectionView,let delegate = self.collectionView?.delegate as? UICollectionViewDelegateFlowLayout else { return .zero}
//        var width: CGFloat = 0
//        var height: CGFloat = 0
//
//        for index in 0..<self.column {
//            let indexPath = IndexPath(item: index, section: 0)
//            let size = delegate.collectionView?(collectionView, layout: self, sizeForItemAt: indexPath)
//            width += size?.width ?? nonilConfigs.maxWidth
//        }
//
//        for index in 0..<self.row {
//            let indexPath = IndexPath(item: 0, section: index)
//            let size = delegate.collectionView?(collectionView, layout: self, sizeForItemAt: indexPath)
//            height += size?.height ?? nonilConfigs.maxHeight
//        }
        
        guard let nonilLast = self.lastAttribute else {return .zero}
        let width = nonilLast.size.width + nonilLast.frame.origin.x
        let height = nonilLast.size.height + nonilLast.frame.origin.y
    
        return CGSize(width: width, height: height)
    }
    
    // MARK: - override methods
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let result = self.totalAttributes.filter { $0.frame.intersects(rect)}
        return result
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes  ?? UICollectionViewLayoutAttributes(forCellWith: indexPath)
        guard let nonilConfig = self.configs else { return attr }
        let row = (indexPath.row + 1) % self.column == 0 ? (indexPath.row + 1) / self.column : (indexPath.row + 1) / self.column + 1
        let column = row == 1 ? indexPath.row + 1 : ((indexPath.row + 1) % self.column) == 0 ? self.column : (indexPath.row + 1) % self.column
        
        self.widths[column - 1] = column == 1 ? 0 : self.widths[column - 2] + attr.size.width
        self.heights[row - 1] = row == 1 ? 0 : self.heights[row - 2] + attr.size.height
        self.layoutItemWithoutLock(attr: attr, indexPath: indexPath)

        switch nonilConfig.lockStyle {
        case .none:
            break
        case .firstCell:
            self.layoutItemLcckFirtCell(attr: attr, indexPath: indexPath)
        case .row:
            self.layoutItemWithLockRows(attr: attr, indexPath: indexPath)
        case .columns:
            self.layoutItemWihtLockColumns(attr: attr, indexPath: indexPath)
        case .both:
            self.layoutItemWithLockRowsAndColumns(attr: attr, indexPath: indexPath)
        }        
        return attr
    }
    
    /// 没有锁定
    private func layoutItemWithoutLock(attr: UICollectionViewLayoutAttributes,indexPath: IndexPath) {
        
        let row = (indexPath.row + 1) % self.column == 0 ? (indexPath.row + 1) / self.column : (indexPath.row + 1) / self.column + 1
        let column = row == 1 ? indexPath.row + 1 : ((indexPath.row + 1) % self.column) == 0 ? self.column : (indexPath.row + 1) % self.column

        if row == self.row && column == self.column {
            self.lastAttribute = attr
        }
        attr.frame.origin.x = self.widths[column - 1]
        attr.frame.origin.y = self.heights[row - 1]

    }
    
    /// 锁定第一个cell
    private func layoutItemLcckFirtCell(attr: UICollectionViewLayoutAttributes,indexPath: IndexPath) {
        guard let nonilCollectionView = self.collectionView else { return }
        let contentOffSet = nonilCollectionView.contentOffset
        let row = (indexPath.row + 1) % self.column == 0 ? (indexPath.row + 1) / self.column : (indexPath.row + 1) / self.column + 1
        let column = row == 1 ? indexPath.row + 1 : ((indexPath.row + 1) % self.column) == 0 ? self.column : (indexPath.row + 1) % self.column

        switch (row,column) {
        case (1,1):
            if contentOffSet.x > 0 || contentOffSet.y > 0 {
                attr.frame.origin.x = contentOffSet.x
                attr.frame.origin.y = contentOffSet.y
            }
            else {
                attr.frame.origin.x = 0
                attr.frame.origin.y = 0
            }
            attr.zIndex = 999
        default:
            break
        }
    }
    
    /// 锁定行
    private func layoutItemWithLockRows(attr: UICollectionViewLayoutAttributes,indexPath: IndexPath) {
        guard let nonilCollectionView = self.collectionView else { return }
        let contentOffSet = nonilCollectionView.contentOffset
        let row = (indexPath.row + 1) % self.column == 0 ? (indexPath.row + 1) / self.column : (indexPath.row + 1) / self.column + 1
        guard let nonilConfig = self.configs else { return }
        if nonilConfig.lockRows.contains(row) {
            attr.frame.origin.y += contentOffSet.y
            attr.zIndex = 999
        }
    }
    
    /// 锁定列
    private func layoutItemWihtLockColumns(attr: UICollectionViewLayoutAttributes,indexPath: IndexPath) {
        
        guard let nonilCollectionView = self.collectionView else { return }
        let contentOffSet = nonilCollectionView.contentOffset
        let row = (indexPath.row + 1) % self.column == 0 ? (indexPath.row + 1) / self.column : (indexPath.row + 1) / self.column + 1
        let column = row == 1 ? indexPath.row + 1 : ((indexPath.row + 1) % self.column) == 0 ? self.column : (indexPath.row + 1) % self.column
        guard let nonilConfig = self.configs else { return }
        if nonilConfig.lockColumns.contains(column) {
            attr.frame.origin.x += contentOffSet.x
            attr.zIndex = 999
        }
    }
    
    private func layoutItemWithLockRowsAndColumns(attr: UICollectionViewLayoutAttributes,indexPath: IndexPath) {
        
        let row = (indexPath.row + 1) % self.column == 0 ? (indexPath.row + 1) / self.column : (indexPath.row + 1) / self.column + 1
        let column = row == 1 ? indexPath.row + 1 : ((indexPath.row + 1) % self.column) == 0 ? self.column : (indexPath.row + 1) % self.column
        self.layoutItemWithLockRows(attr: attr, indexPath: indexPath)
        self.layoutItemWihtLockColumns(attr: attr, indexPath: indexPath)
        if row == 1 && column == 1 {
            attr.zIndex = 1000
        }
    }
}
