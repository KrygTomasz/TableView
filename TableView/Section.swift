//
//  Section.swift
//  TableView
//
//  Created by Kryg Tomasz on 14.01.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import Foundation


class Section {
    
    var name: String = ""
    var isExpanded: Bool = false
    var rows = [Row]()
    
    init(_ name: String, numberOfRows: Int) {
        self.name = name
        for _ in 0..<numberOfRows {
            rows.append(Row())
        }
    }
    
    func addRow(_ row: Row) {
        self.rows.append(row)
    }
    
}
