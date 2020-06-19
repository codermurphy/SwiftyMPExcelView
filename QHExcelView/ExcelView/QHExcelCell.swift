//
//  QHExcelCell.swift
//  QHExcelView
//
//  Created by Qihe_mac on 2020/6/18.
//  Copyright © 2020 QiHe. All rights reserved.
//

import UIKit


let kQHExcelCellTextIdentifier = "kQHExcelCellTextIdentifier"

class QHExcelCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = .white
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - layout
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.removeFromSuperview()
        self.icon.removeFromSuperview()
    }
    
    
    // MARK: -  configContent
    func config(icon: UIImage?,title:String?,isMenu: Bool = false,isFirstColumn: Bool = false,config: QHExcelConfig) {
    
        self.icon.image = icon
        self.icon.isHidden = icon == nil
        self.titleLabel.text = title

    
        if isMenu {
            self.titleLabel.font = config.menuTitleFont
            self.titleLabel.textColor = config.menuTitleColor
        }
        else {
            if isFirstColumn {
                self.titleLabel.font = config.firstColumnFont
                self.titleLabel.textColor = config.firstColumnColor
            }
            else {
                self.titleLabel.font = config.contentFont
                self.titleLabel.textColor = config.contentColor
            }
        }
    
        self.setUpUI(margin: config.titleAndIconMargin)
    }
    
    // MARK: - UI
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()
    
    private let icon: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private func setUpUI(margin: CGFloat) {
        
        if self.icon.image != nil {
            
            self.icon.sizeToFit()
            self.titleLabel.sizeToFit()
            
            let totalWidth = self.icon.frame.width + self.titleLabel.frame.width + margin
            let offSetX = (self.frame.width - totalWidth) * 0.5

            
            self.contentView.addSubview(self.titleLabel)
            self.contentView.addSubview(self.icon)
            self.icon.frame.origin.x = offSetX
            self.icon.frame.origin.y = (self.bounds.height - self.icon.image!.size.height) * 0.5
            
            self.titleLabel.frame.origin.x = self.icon.frame.origin.x + self.icon.frame.width + margin
            self.titleLabel.center.y = self.icon.center.y
        }
        else {
            self.contentView.addSubview(self.titleLabel)
            self.titleLabel.frame = self.bounds
        }
    }
    
}
