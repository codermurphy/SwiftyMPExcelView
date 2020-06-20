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
        self.titleLabel.frame = .zero
        self.icon.removeFromSuperview()
        self.icon.frame = .zero
    }
    
    
    // MARK: -  configContent
    func config(icon: UIImage?,title:String?,isMenu: Bool = false,isFirstColumn: Bool = false,config: QHExcelConfig) {
    
        self.icon.image = icon
        self.icon.isHidden = icon == nil
        self.titleLabel.text = title

    
        if isMenu {
            self.titleLabel.font = config.menuTitleFont
            self.titleLabel.textColor = config.menuTitleColor
            self.contentView.backgroundColor = config.menuBackgroundColor
        }
        else {
            if isFirstColumn {
                self.titleLabel.font = config.firstColumnFont
                self.titleLabel.textColor = config.firstColumnColor
                self.contentView.backgroundColor = config.firstColumnBackgroundColor
            }
            else {
                self.titleLabel.font = config.contentFont
                self.titleLabel.textColor = config.contentColor
                self.contentView.backgroundColor = config.contentBackgroundColor
            }
        }
    
        self.setUpUI(config: config)
    }
    
    // MARK: - UI
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingMiddle
        label.numberOfLines = 0
        return label
    }()
    
    private let icon: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private func setUpUI(config: QHExcelConfig) {
        
        if self.icon.isHidden == false {
            
            self.icon.sizeToFit()
            
//            let totalWidth = self.icon.frame.width + self.titleLabel.frame.width + config.titleAndIconMargin
//            let offSetX = (self.frame.width - totalWidth -  config.contentEdgeInsets.left - config.contentEdgeInsets.right) * 0.5

            
            self.contentView.addSubview(self.titleLabel)
            self.contentView.addSubview(self.icon)
            self.icon.frame.origin.x = config.contentEdgeInsets.left
            self.icon.frame.origin.y = (self.bounds.height - self.icon.image!.size.height) * 0.5
            
            self.titleLabel.frame.origin.x = self.icon.frame.origin.x + self.icon.frame.width + config.titleAndIconMargin
            self.titleLabel.frame.size.width = self.bounds.width - self.titleLabel.frame.origin.x - config.contentEdgeInsets.right
            self.titleLabel.frame.size.height = self.titleLabel.sizeThatFits(CGSize(width: self.titleLabel.frame.size.width, height: CGFloat.greatestFiniteMagnitude)).height
            self.titleLabel.center.y = self.icon.center.y
        }
        else {
            self.contentView.addSubview(self.titleLabel)
            self.titleLabel.frame.origin.x = config.contentEdgeInsets.left
            self.titleLabel.frame.size.width = self.bounds.width - config.contentEdgeInsets.left - config.contentEdgeInsets.right
            self.titleLabel.frame.size.height = self.bounds.height
        }
    }
    
}
