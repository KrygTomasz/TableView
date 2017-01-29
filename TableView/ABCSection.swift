//
//  ABCSection.swift
//  TableView
//
//  Created by Kryg Tomasz on 14.01.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import Foundation


class ABCSection {
    
    var name: String = ""
    var isExpanded: Bool = false
    var rows = [ABCRow]()
    
    init(_ name: String, numberOfRows: Int) {
        self.name = name
        for i in 0..<numberOfRows {
            rows.append(ABCRow(title: "\(i)"))
        }
    }
    
    func addRow(_ row: ABCRow) {
        self.rows.append(row)
    }
    
}
