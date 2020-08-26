//
//  MPExcelView.swift
//  QHExcelView
//
//  Created by Murphy_Zeng on 2020/8/18.
//  Copyright © 2020 QiHe. All rights reserved.
//

import UIKit

@objc public protocol MPExcelViewDataSource: NSObjectProtocol {
    
    @objc optional func numberOfSections(in excelView: MPExcelView) -> Int
    func numberOfColumn(_ excelView: MPExcelView) -> Int
    func numberOfRow(_ excelView: MPExcelView) -> Int
    
    func excelView(_ excelView: MPExcelView,collectionView: UICollectionView,indexPath: IndexPath,column: Int,row: Int) -> UICollectionViewCell
    
}

@objc public protocol MPExcelViewDelegate: NSObjectProtocol {
    
    @objc optional func excelView(_ excelView: MPExcelView, layout collectionViewLayout: MPExcelCollectionViewLayout, columnWidthIndexPath: IndexPath, column: Int,row: Int) -> CGFloat
    
    @objc optional func excelView(_ excelView: MPExcelView, layout collectionViewLayout: MPExcelCollectionViewLayout, rowHeightIndexPath: IndexPath, column: Int,row: Int) -> CGFloat
}

public class MPExcelView: UIView {
    
    //MARK: initial methods
    public init(configs: MPExcelConfig) {
        self.configs = configs
        super.init(frame: .zero)
        self.setUpUI()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: property
    
    private var configs: MPExcelConfig
    
    private var column: Int = 0
    
    private var row: Int = 0
    
    public var widths: [CGFloat] = []
    
    public var height: [CGFloat] = []
     
    public weak var dataSource: MPExcelViewDataSource? {
        didSet {
            self.column = self.dataSource?.numberOfColumn(self) ?? 0
            self.row = self.dataSource?.numberOfRow(self) ?? 0
            self.excelLayout.column = self.column
            self.excelLayout.row = self.row
        }
    }
    
    public weak var delegate: MPExcelViewDelegate?
    
    //MARK: UI
    private lazy var contentView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.excelLayout)
        collectionView.backgroundColor = .white
        collectionView.isDirectionalLockEnabled = true
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
        }
        return collectionView
    }()
    
    fileprivate let excelLayout: MPExcelCollectionViewLayout = {
        let layout = MPExcelCollectionViewLayout()
        return layout
    }()
    
    //MARK: register cell
    
    public func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        self.contentView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    
    // MARK: - 计算单元格宽度
    func autoCalCellWidth(contents: [MPExcelCellModel],totoalColumn: Int,totalRow: Int,contentWidth: CGFloat) {
        
        for (index,model) in contents.enumerated() {
            let row = (index + 1) % totoalColumn == 0 ? (index + 1) / totoalColumn : (index + 1) / totoalColumn + 1
//            let column = row == 1 ? index + 1 : ((index + 1) % totoalColumn) == 0 ? totoalColumn : (index + 1) % totoalColumn
            var font = self.configs.contentFont
            
            if self.configs.showMenu {
                if row == 1 {
                    font = self.configs.menuFont
                }
            }
            self.calItemsSize(item: model, itemFont: font)
        }
        
        var tmpWidths: [CGFloat] = []
        for index in 0..<totoalColumn {
            var tmp: [MPExcelCellModel] = []
            for (innerIndex,model) in contents.enumerated() {
                if innerIndex % totoalColumn == index {
                    tmp.append(model)
                }
            }
            let max = tmp.max {  $0.fitSize.width < $1.fitSize.width}?.fitSize.width ?? self.configs.maxWidth
            tmpWidths.append(max)
        }
        let totalWidth = tmpWidths.reduce(0, +)
        if totalWidth < contentWidth {
            var itemSpacing: CGFloat = 0
            
            if totoalColumn > 0 {
                itemSpacing = (contentWidth - totalWidth) / CGFloat(totoalColumn + 1)
            }
            
            for (index,width) in tmpWidths.enumerated() {
                
                if index == 0 || index == tmpWidths.count - 1 {
                    self.widths.append(width + itemSpacing + itemSpacing * 0.5)
                }
                else {
                    self.widths.append(width + itemSpacing)
                }
            }
        }
        else {
            self.widths = tmpWidths
        }
        
        for index in 0..<totalRow {
            var tmp: [MPExcelCellModel] = []
            for (innerIndex,model) in contents.enumerated() {
                if innerIndex / totoalColumn == index {
                    tmp.append(model)
                }
            }
            let max = tmp.max {  $0.fitSize.height < $1.fitSize.height}?.fitSize.height ?? self.configs.maxHeight
            self.height.append(max)
        }
        
    }
        
    private func calItemsSize(item: MPExcelCellModel,itemFont: UIFont) {
        let preImage = (item.image != nil || item.imageUrl != nil) ? self.configs.imageSize : .zero
        let preTitleSize = item.title != nil ? NSAttributedString(string: item.title!, attributes: [NSAttributedString.Key.font : itemFont]).size() : .zero
        switch self.configs.imageAndTextPosition {
        case .top,.bottom:
            let contentWidth1 = max(preImage.width,preTitleSize.width)
            let resultWidth1 = contentWidth1 + self.configs.edgeInsets.left + self.configs.edgeInsets.right > self.configs.maxWidth ? self.configs.maxWidth : contentWidth1
            let contentHeight1 = preImage.height + preTitleSize.height + self.configs.imageAndTextSpacing
            let resultHeight1 = contentHeight1 + self.configs.edgeInsets.top + self.configs.edgeInsets.bottom > self.configs.maxHeight ? self.configs.maxHeight : contentHeight1
            item.fitSize = CGSize(width: resultWidth1, height: resultHeight1)
            
            
        case .left,.right:
            
            let contentWidth1 = preImage.width + preTitleSize.width + self.configs.imageAndTextSpacing
            let resultWidth1 = contentWidth1 + self.configs.edgeInsets.left + self.configs.edgeInsets.right > self.configs.maxWidth ? self.configs.maxWidth : contentWidth1
            let contentHeight1 = max(preImage.height, preTitleSize.height)
            let resultHeight1 = contentHeight1 + self.configs.edgeInsets.top + self.configs.edgeInsets.bottom > self.configs.maxHeight ? self.configs.maxHeight : contentHeight1
            item.fitSize = CGSize(width: resultWidth1, height: resultHeight1)
            
        }
    }
    
    
    //MARK: setup UI
    
    private func setUpUI() {
        
        self.excelLayout.configs = self.configs
        
        self.addSubview(self.contentView)
        self.contentView.register(MPExcelCollectionCell.self, forCellWithReuseIdentifier: "MPExcelCollectionCellIdentifer")
        self.contentView.dataSource = self
        self.contentView.delegate = self
    }
    
    //MARK: layout
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.bounds
    }
}


extension MPExcelView: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataSource?.numberOfSections?(in: self) ?? 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.column * self.row
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let nonilDataSource = self.dataSource else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MPExcelCollectionCellIdentifer", for: indexPath)
            return cell
        }
        let row = (indexPath.row + 1) % self.column == 0 ? (indexPath.row + 1) / self.column : (indexPath.row + 1) / self.column + 1
        let column = row == 1 ? indexPath.row + 1 : ((indexPath.row + 1) % self.column) == 0 ? self.column : (indexPath.row + 1) % self.column
        let cell = nonilDataSource.excelView(self, collectionView: collectionView, indexPath: indexPath, column: column, row: row)
        return cell
    }
    
    
}

extension MPExcelView: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let row = (indexPath.row + 1) % self.column == 0 ? (indexPath.row + 1) / self.column : (indexPath.row + 1) / self.column + 1
        let column = row == 1 ? indexPath.row + 1 : ((indexPath.row + 1) % self.column) == 0 ? self.column : (indexPath.row + 1) % self.column
        
        
        var height: CGFloat = 0
        var width: CGFloat = 0
        
        if let nonilHeight = self.delegate?.excelView?(self, layout: self.excelLayout, rowHeightIndexPath: indexPath, column: column, row: row) {
            
            height = nonilHeight
        }
        else {
            if self.configs.isAutoCalHeight {
                height = self.height[row - 1]
            }
            else {
                height = self.configs.maxHeight
            }
        }
        
        if let nonilWidth = self.delegate?.excelView?(self, layout: self.excelLayout, columnWidthIndexPath: indexPath, column: column, row: row){
            
            width = nonilWidth
        }
        else {
            if self.configs.isAutoCalWidth {
                width = self.widths[column - 1]
            }
            else {
                width = self.configs.maxWidth
            }
        }
        return CGSize(width: width, height: height)
    }
}
