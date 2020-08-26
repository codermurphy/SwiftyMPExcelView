//
//  MPExcelConfig.swift
//  QHExcelView
//
//  Created by Qihe_mac on 2020/7/22.
//  Copyright © 2020 QiHe. All rights reserved.
//

import UIKit

public class MPExcelConfig {
    
    /// 图片与文本的位置
    public enum MPExcelImageAndTextPostion {
        case left  // 图片在左侧
        case right // 图片在右侧
        case top //  图片在顶部
        case bottom // 图片在底部
    }
    
    public enum  MPExcelLockStyle {
        /// 不锁定
        case none
        /// 锁定行 以 1 开始
        case row([Int])
        /// 锁定第一个单元格
        case firstCell
        /// 锁定列 以 1 开始
        case columns([Int])
        /// 锁定行和列
        case both([Int],[Int])
    }
    
    public enum MPExcelGridLineStyle {
        
        /// 不显示网格
        case none
        
        /// 显示内部网格
        case inner
        
        /// 显示外部网格
        case outter
        
        /// 显示内外网格
        case both
    }
    
    /// 是否显示菜单栏
    public var showMenu: Bool = true
    
    /// 锁定类型
    public var lockStyle: MPExcelLockStyle = .none
    public var lockColumns: [Int] {
        switch self.lockStyle {
        case let .columns(result):
            return result
        case let .both(_,result):
            return result
        default:
            return []
        }
    }
    
    public var lockRows: [Int] {
        switch self.lockStyle {
        case let .row(result):
            return result
        case let .both(result,_):
            return result
        default:
            return []
        }
    }
    
    /// 菜单字体
    public var menuFont: UIFont = .systemFont(ofSize: 12)
    
    /// 菜单标题颜色
    public var menuColor: UIColor = .lightGray
    
    /// 菜单栏背景色
    public var menuBackgroudColor: UIColor = .white
    
    /// 是否换行
    public var menuIsWrap: Bool = false
            
    /// 固定列字体
    public var fixedColumnFont: UIFont?
    
    /// 固定列标题颜色
    public var fixedColumnColor: UIColor?
    
    /// 固定列背景色
    public var fixedBacgkgroundColor: UIColor?
    
    /// 内容字体
    public var contentFont: UIFont = .systemFont(ofSize: 12)
    
    /// 内容题颜色
    public var contentColor: UIColor = .lightGray
    
    /// 内容背景色
    public var contentBackgroudColor: UIColor = .white
    
    /// 是否换行(包括固定列)
    public var contentsWrap: Bool = false
    
    /// 单元格最大宽度
    public var maxWidth: CGFloat = UIScreen.main.bounds.width / 3
    
    /// 是否自动计算单元格的宽度
    public var isAutoCalWidth: Bool = false
    
    /// 单元格最大高度
    public var maxHeight: CGFloat = 44
    
    /// 是否自动计算每行的高度
    public var isAutoCalHeight: Bool = false
    
    /// 菜单-内容边距
    public var edgeInsets: UIEdgeInsets = .zero
    
    /// 图片大小
    public var imageSize: CGSize = CGSize(width: 24, height: 24)
    
    /// 图片和文本的排列方式
    public var imageAndTextPosition: MPExcelImageAndTextPostion = .left
    
    /// 图片和文本的距离
    public var imageAndTextSpacing: CGFloat = 5
}
