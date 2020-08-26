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
            self.pointXs = Array(repeating: 0.0, count: self.column)
        }
    }
    
    /// 列数
    var row = 0 {
        didSet {
            self.pointYs = Array(repeating: 0.0, count: self.row)
        }
    }
    
    /// 配置信息
    var configs: MPExcelConfig?
    
    /// 所有的布局信息
    private var totalAttributes: [UICollectionViewLayoutAttributes] = []
    
    
    private var lastAttribute: UICollectionViewLayoutAttributes?
    
    private var pointXs: [CGFloat] = []

    private var pointYs: [CGFloat] = []
    
    private var lastRow: Int = 1
    
    /// 填充contents 让 contents.count  =  row * column
//    func fillEmptyModel() {
//        guard let nonilConfig = self.configs else { return }
//        self.allContents = nonilConfig.showMenu ? self.menus + self.contents : self.contents
//        let allCount = self.allContents.count
//        let total = self.row * self.column
//        guard allCount != total else { return }
//        let dis = allCount % total
//        for _ in 0..<dis {
//            self.allContents.append(MPExcelCellModel())
//        }
//
//    }
    
    // MARK: - prepare
    
    public override func prepare() {
        super.prepare()
        
        self.pointXs = Array(repeating: 0.0, count: self.column)
        self.pointYs = Array(repeating: 0.0, count: self.row)
        self.lastRow = 1
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
        
        self.pointXs[column - 1] = column == 1 ? 0 : self.pointXs[column - 2] + (self.lastAttribute?.size.width ?? 0 )
        if row == 1 {
            self.pointYs[row - 1] = 0
        }
        else {
            if self.lastRow != row {
                self.pointYs[row - 1] = self.pointYs[row - 2] + (self.lastAttribute?.size.height ?? 0 )
            }
        }
        self.layoutItemWithoutLock(attr: attr, indexPath: indexPath)

        self.lastRow = row
        
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
        self.lastAttribute = attr
        return attr
    }
    
    /// 没有锁定
    private func layoutItemWithoutLock(attr: UICollectionViewLayoutAttributes,indexPath: IndexPath) {
        
        let row = (indexPath.row + 1) % self.column == 0 ? (indexPath.row + 1) / self.column : (indexPath.row + 1) / self.column + 1
        let column = row == 1 ? indexPath.row + 1 : ((indexPath.row + 1) % self.column) == 0 ? self.column : (indexPath.row + 1) % self.column

        attr.frame.origin.x = self.pointXs[column - 1]
        attr.frame.origin.y = self.pointYs[row - 1]

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
