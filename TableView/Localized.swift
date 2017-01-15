//
//  Localized.swift
//  TableView
//
//  Created by Kryg Tomasz on 15.01.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import Foundation

enum Localized: String {
    
    case save = "SAVE"
    case addHeaderTitle = "ADD_HEADER_TITLE"
    case addHeaderDescription = "ADD_HEADER_DESCRIPTION"
    
    var localize: String {
        
        return NSLocalizedString(self.rawValue, comment: "")
        
    }
    
}
