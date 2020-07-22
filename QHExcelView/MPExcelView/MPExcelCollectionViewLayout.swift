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
        self.menus = menus
        self.contents = contents
        self.allContents = menus + contents
        self.column = column
        let row = contents.count % self.column == 0 ? contents.count / self.column : contents.count / self.column + 1
        self.row = configs.showMenu ?  row + 1 : row
        super.init()
                
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - property
    
    /// 列数
    private var column = 0
    
    /// 列数
    private var row = 0
    
    /// 配置信息
    private var configs: MPExcelConfig?
    
    /// 内容数据源
    private var contents: [MPExcelCellModel]
    
    /// 菜单数据源
    private var menus: [MPExcelCellModel]
    
    /// 所有数据源
    private var allContents: [MPExcelCellModel]
    
    /// 所有的布局信息
    private var totalAttributes: [UICollectionViewLayoutAttributes] = []
    
    /// 菜单栏的布局信息
    private var menuAttributes: [UICollectionViewLayoutAttributes] = []
    
    /// 锁定列的布局信息
    private var fixedColumnAttributes: [UICollectionViewLayoutAttributes] = []
    
    private var widths: [CGFloat] = []
    private var heights: [CGFloat] = []
    
    
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
                let tmp = targetItems
                targetItems.sort { (item1, item2) -> Bool in
                    let firstIndex = tmp.firstIndex { $0 == item1 } ?? 0
                    let secondIndex =  tmp.firstIndex { $0 == item2 } ?? 0
                
                    let firstFont = firstIndex == 0 ? nonilConfig.menuFont : !nonilConfig.lockColumns.contains(firstIndex) ? nonilConfig.contentFont : nonilConfig.fixedColumnFont ?? nonilConfig.contentFont
                    let secondFont = secondIndex == 0 ? nonilConfig.menuFont : !nonilConfig.lockColumns.contains(secondIndex) ? nonilConfig.contentFont : nonilConfig.fixedColumnFont ?? nonilConfig.contentFont
                    let result = self.calItemsSize(item1: item1, item1Font: firstFont, item2: item2, item2Font: secondFont)

                    return result.0 < result.1
                }
                if let lastItem = targetItems.last {
                    
                }

            }
        }
        else {
            
        }
        
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
            
        default:
            break
        }
        return (item1.fitSize.width,item2.fitSize.width)
    }
    
    // MARK: - prepare
    
    public override func prepare() {
        super.prepare()
        
        self.totalAttributes.removeAll()
        self.menuAttributes.removeAll()
        self.fixedColumnAttributes.removeAll()
    }
    
    // MARK: - override methods
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return super.layoutAttributesForElements(in: rect)
    }
}
