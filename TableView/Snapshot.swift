//
//  Snapshot.swift
//  TableView
//
//  Created by Kryg Tomasz on 15.01.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import UIKit

class Snapshot: UIImageView {
    
    override init(image: UIImage?) {
        super.init(image: image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
