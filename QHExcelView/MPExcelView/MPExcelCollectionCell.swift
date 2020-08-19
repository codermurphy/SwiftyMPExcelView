//
//  MPExcelCollectionCell.swift
//  QHExcelView
//
//  Created by Murphy_Zeng on 2020/8/18.
//  Copyright © 2020 QiHe. All rights reserved.
//

import UIKit

class MPExcelCollectionCell: UICollectionViewCell {
    
    //MARK: initial methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .white
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: UI
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .brown
        label.font = .systemFont(ofSize: 14)
        self.contentView.addSubview(label)
        return label
    }()
    
    //MARK: layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.titleLabel.frame = self.contentView.bounds
    }
    
}
