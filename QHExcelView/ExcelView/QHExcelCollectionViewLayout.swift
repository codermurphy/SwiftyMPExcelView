//
//  QHExcelCollectionViewLayout.swift
//  QHExcelView
//
//  Created by Qihe_mac on 2020/6/18.
//  Copyright © 2020 QiHe. All rights reserved.
//

import UIKit

protocol QHExcelCollectionViewLayoutDelegate: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
}

class QHExcelCollectionViewLayout: UICollectionViewLayout {
    

    // MARK: - initial methods
    
    init(config: QHExcelConfig) {
        self.config = config
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - property
    
    /// 配置信息
    private let config: QHExcelConfig
    
    /// 列数
    private var rowConunt: Int {
        return self.config.row
    }
    
    /// 行数
    private var columnCount: Int {
        return self.config.column
    }
    
    /// 最后的横坐标
    private var lastOffsetX: CGFloat = 0
    
    /// 最后的纵坐标
    private var lastOffsetY: CGFloat = 0
    
    private var xAaixLastOffsetX: CGFloat = 0
    
    private var yAasixLastOffsetY: CGFloat = 0
    
    /// 最后一个的属性
    private var lastAttr: UICollectionViewLayoutAttributes?
    
    private var attributes: [UICollectionViewLayoutAttributes] = []
    private lazy var xAaixAtts: [UICollectionViewLayoutAttributes] = []
    private lazy var yAaixAtts: [UICollectionViewLayoutAttributes] = []
    // MARK: - create IndexPaths
    private func setUpAttrs() {
        guard let collectionView = self.collectionView else { return }
        for section in 0..<collectionView.numberOfSections {
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                guard let attr = self.layoutAttributesForItem(at: indexPath) else { self.attributes.removeAll(); return }
                self.attributes.append(attr)
            }
        }
        
    }
    
    // MARK: - prepare
    
    override func prepare() {
        super.prepare()
        
        self.attributes.removeAll()
        self.xAaixAtts.removeAll()
        self.yAaixAtts.removeAll()
        
        self.lastOffsetX = 0
        self.lastOffsetY = 0
        self.xAaixLastOffsetX = 0
        self.yAasixLastOffsetY = 0
        self.lastAttr = nil
        self.setUpAttrs()
    }
    
    /// 可滚动size
    override var collectionViewContentSize: CGSize {
        guard let collectionView = self.collectionView else { return .zero}
        
        /// 获取行数
        let section = collectionView.numberOfSections
        
        guard section > 0 else { return .zero }
        /// 获取第一行的列数
        let items = collectionView.numberOfItems(inSection: 0)
        
        guard items > 0 else { return .zero }
        
        guard self.attributes.isEmpty != true else { return .zero }

        var totalHeight: CGFloat = 0
        var totalWidth: CGFloat = 0
        
        if let lastAttr = self.attributes.last {
            totalHeight += lastAttr.frame.origin.y + lastAttr.frame.height
            totalWidth += lastAttr.frame.origin.x + lastAttr.frame.width
        }


        return CGSize(width: totalWidth, height: totalHeight)

    }
    
    // MARK: - override methods
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        var size: CGSize = .zero
        
        if let delegate = self.collectionView?.delegate as? QHExcelCollectionViewLayoutDelegate {
            size = delegate.collectionView(self.collectionView!, layout: self, sizeForItemAt: indexPath)
        }
        
        
        let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)

        if !self.config.showMenu {
            self.layoutItemWithoutLock(attr: attr, indexPath: indexPath, size: size)
        }
        else {
            
            if self.config.lockFirstCell {
                self.layoutItemLcckFirtCell(attr: attr, indexPath: indexPath, size: size)
            }
            else {
                let lockInfo = (self.config.lockMenu,self.config.lockColumn)
                
                switch lockInfo {
                case (true,true):
                    self.layoutItemWithLockMenuAndFirstColumn(attr: attr, indexPath: indexPath, size: size)
                case (true,false):
                    self.layoutItemWithLockMenu(attr: attr, indexPath: indexPath, size: size)
                case (false,true):
                    if self.config.lockColumnItems.isEmpty {
                        self.layoutItemWithoutLock(attr: attr, indexPath: indexPath, size: size)
                    }
                    else {
                        self.layoutItemWihtLockFirstColumn(attr: attr, indexPath: indexPath, size: size)

                    }
                case (false,false):
                    self.layoutItemWithoutLock(attr: attr, indexPath: indexPath, size: size)
                }
            }
            

        }
        return attr
    }
    
    /// 没有锁定
    private func layoutItemWithoutLock(attr: UICollectionViewLayoutAttributes,indexPath: IndexPath,size: CGSize) {
        if let nonilLastAttr = self.lastAttr {
            if nonilLastAttr.indexPath.section == indexPath.section {
                attr.frame = CGRect(x: nonilLastAttr.frame.origin.x + nonilLastAttr.frame.width, y: nonilLastAttr.frame.origin.y, width: size.width, height: size.height)
            }
            else {
                attr.frame = CGRect(x: 0, y: nonilLastAttr.frame.origin.y + nonilLastAttr.frame.height, width: size.width, height: size.height)
            }
        }
        else {
            attr.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        }

        self.lastAttr = attr
    }
    
    /// 没有锁定
    private func layoutItemLcckFirtCell(attr: UICollectionViewLayoutAttributes,indexPath: IndexPath,size: CGSize) {
        
        if indexPath.section == 0 && indexPath.item == 0 {
            attr.frame = CGRect(x: self.collectionView!.contentOffset.x, y: self.collectionView!.contentOffset.y, width: size.width, height: size.height)
            attr.zIndex = 999
            self.xAaixLastOffsetX = size.width
        }
        else {
            if let nonilLastAttr = self.lastAttr {
                if nonilLastAttr.indexPath.section == indexPath.section {
                    attr.frame = CGRect(x: nonilLastAttr.frame.origin.x + nonilLastAttr.frame.width, y: nonilLastAttr.frame.origin.y, width: size.width, height: size.height)
                }
                else {
                    attr.frame = CGRect(x: 0, y: nonilLastAttr.frame.origin.y + nonilLastAttr.frame.height, width: size.width, height: size.height)
                }
            }
            else {
                attr.frame = CGRect(x: self.xAaixLastOffsetX, y: 0, width: size.width, height: size.height)
            }

            self.lastAttr = attr
        }
        

    }
    
    /// 锁定列
    private func layoutItemWihtLockFirstColumn(attr: UICollectionViewLayoutAttributes,indexPath: IndexPath,size: CGSize) {
        
        let sortItem = self.config.lockColumnItems.sorted { $0 < $1}
        
        let firstHeight = self.config.contentsHeights[0]
        
        ///为锁定列布局
        if sortItem.contains(indexPath.item) {

            if indexPath.item == 0 {
                attr.frame = CGRect(x: self.collectionView!.contentOffset.x, y: self.yAasixLastOffsetY, width: size.width, height: size.height)

            }
            else {
                guard let firstAttr = self.yAaixAtts.last(where: {$0.indexPath.section == indexPath.section}) else { return }
                attr.frame = CGRect(x: self.xAaixLastOffsetX, y: firstAttr.frame.origin.y, width: size.width, height: size.height)
            }
            attr.zIndex = 999
            self.xAaixLastOffsetX = attr.frame.origin.x + size.width
            self.yAasixLastOffsetY = indexPath.section == 0 ? firstHeight : attr.frame.origin.y + size.height

            self.yAaixAtts.append(attr)
            
        }
        else {
            
            if let lastAttr = self.lastAttr {
                if lastAttr.indexPath.section ==  indexPath.section {
                    attr.frame = CGRect(x: lastAttr.frame.width + lastAttr.frame.origin.x, y: lastAttr.frame.origin.y, width: size.width, height: size.height)
                }
                else {
                    let sectionAttrs = self.yAaixAtts.filter({ $0.indexPath.section == indexPath.section })
                    let widths = sectionAttrs.map { $0.frame.width}
                    let totalWidth = widths.reduce(0) { $0 + $1 }
                    attr.frame = CGRect(x: totalWidth, y: lastAttr.frame.origin.y + lastAttr.frame.height, width: size.width, height: size.height)
                }

            }
            else {
                let sectionAttrs = self.yAaixAtts.filter({ $0.indexPath.section == indexPath.section })
                let widths = sectionAttrs.map { $0.frame.width}
                let totalWidth = widths.reduce(0) { $0 + $1 }
                attr.frame = CGRect(x: totalWidth, y: 0, width: size.width, height: size.height)
            }
            
            self.lastAttr = attr
        }
        
    }
    
    /// 锁定菜单栏
    private func layoutItemWithLockMenu(attr: UICollectionViewLayoutAttributes,indexPath: IndexPath,size: CGSize) {
        
        /// 为菜单布局
        if indexPath.section == 0 {
            attr.frame = CGRect(x: self.xAaixLastOffsetX, y: self.collectionView!.contentOffset.y, width: size.width, height: size.height)
            attr.zIndex = 999
            self.xAaixLastOffsetX = attr.frame.origin.x + attr.frame.size.width
            self.yAasixLastOffsetY = size.height
            self.xAaixAtts.append(attr)

        }
        else {
            if let nonilLastAttr = self.lastAttr {
                if nonilLastAttr.indexPath.section == indexPath.section {
                    attr.frame = CGRect(x: nonilLastAttr.frame.origin.x + nonilLastAttr.frame.width, y: nonilLastAttr.frame.origin.y, width: size.width, height: size.height)
                }
                else {
                    attr.frame = CGRect(x: 0, y: nonilLastAttr.frame.origin.y + nonilLastAttr.frame.height, width: size.width, height: size.height)
                }
            }
            else {
                attr.frame = CGRect(x: 0, y: self.yAasixLastOffsetY, width: size.width, height: size.height)
            }

            self.lastAttr = attr
        }
        
    }
    
    /// 锁定菜单栏和第一列
    private func layoutItemWithLockMenuAndFirstColumn(attr: UICollectionViewLayoutAttributes,indexPath: IndexPath,size: CGSize) {
        ///为第一列布局
        if indexPath.item == 0 {
            
            if indexPath.section == 0 {
                attr.frame = CGRect(x: self.collectionView!.contentOffset.x, y: self.collectionView!.contentOffset.y, width: size.width, height: size.height)
            }
            else {
              attr.frame = CGRect(x: self.collectionView!.contentOffset.x, y: self.yAasixLastOffsetY, width: size.width, height: size.height)
            }

            attr.zIndex = 999
            self.yAasixLastOffsetY = attr.frame.origin.y + size.height
            self.xAaixLastOffsetX = size.width
            self.yAaixAtts.append(attr)
        }
        else {
            
            if indexPath.section == 0 {
                guard let firstAttr = self.yAaixAtts.first(where: {$0.indexPath.section == indexPath.section}) else { return }
                if indexPath.item == 1 {
                    attr.frame = CGRect(x: firstAttr.frame.width + self.collectionView!.contentOffset.x, y: self.collectionView!.contentOffset.y, width: size.width, height: size.height)
                }
                else {
                    attr.frame = CGRect(x: self.xAaixLastOffsetX, y: self.collectionView!.contentOffset.y, width: size.width, height: size.height)

                }
                attr.zIndex = 999
                self.xAaixLastOffsetX = attr.frame.origin.x + attr.frame.size.width
                self.xAaixAtts.append(attr)
            }
            else {
                if let lastAttr = self.lastAttr {
                    if lastAttr.indexPath.section ==  indexPath.section {
                        attr.frame = CGRect(x: lastAttr.frame.width + lastAttr.frame.origin.x, y: lastAttr.frame.origin.y, width: size.width, height: size.height)
                    }
                    else {
                        guard let firstAttr = self.yAaixAtts.first(where: {$0.indexPath.section == indexPath.section}) else { return }
                        attr.frame = CGRect(x: firstAttr.frame.width, y: lastAttr.frame.origin.y + lastAttr.frame.height, width: size.width, height: size.height)
                    }

                }
                else {
                    guard let firstAttr = self.yAaixAtts.first(where: {$0.indexPath.section == indexPath.section}) else { return }
                    attr.frame = CGRect(x: firstAttr.frame.width, y: firstAttr.frame.height, width: size.width, height: size.height)
                }
                
                self.lastAttr = attr
            }
            

        }
    }

}
