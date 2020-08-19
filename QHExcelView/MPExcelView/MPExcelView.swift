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
        let height = self.delegate?.excelView?(self, layout: self.excelLayout, rowHeightIndexPath: indexPath, column: column, row: row) ?? self.configs.maxHeight
        let width = self.delegate?.excelView?(self, layout: self.excelLayout, columnWidthIndexPath: indexPath, column: column, row: row) ?? self.configs.maxWidth
        
        return CGSize(width: width, height: height)
    }
}
