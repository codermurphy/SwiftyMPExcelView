//
//  Array+QHExcel.swift
//  QHExcelView
//
//  Created by Murphy_Zeng on 2020/6/22.
//  Copyright © 2020 QiHe. All rights reserved.
//

import Foundation


extension Array {
    
    
    func mp_group(by count: Int) -> [[Element]] {
        let result: [[Element]] = self.reduce(into: []) { (group, element) in
            if group.isEmpty {
                return group.append([element])
            }
            if group.last!.count < count  {
                group.append(group.removeLast() + [element])
            } else {
                group.append([element])
            }
        }
        return result
    }
}
