//
//  QHExcelCollectionView.swift
//  QHExcelView
//
//  Created by Qihe_mac on 2020/6/22.
//  Copyright © 2020 QiHe. All rights reserved.
//

import UIKit

class QHExcelCollectionView: UICollectionView {


    // MARK: - initial methods
    init(config: QHExcelConfig) {
        self.config = config
        let layout = QHExcelCollectionViewLayout()
        layout.config = config
        super.init(frame: .zero, collectionViewLayout: layout)
        self.backgroundColor = .white
        self.register(QHExcelCell.self, forCellWithReuseIdentifier: kQHExcelCellTextIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var config: QHExcelConfig {
        didSet {
            guard let layout = self.collectionViewLayout as? QHExcelCollectionViewLayout else { return }
            layout.config = self.config
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        

    }
}

