//
//  Extensions.swift
//  TableView
//
//  Created by Kryg Tomasz on 30.12.2016.
//  Copyright © 2016 Kryg Tomek. All rights reserved.
//

import UIKit

extension UIButton {
    
    func rotate(by angle: CGFloat) {
        if let transformation = self.imageView?.transform.rotated(by: angle) {
            self.imageView?.transform = transformation
        }
    }
    
}


extension UIColor {
    
    static func transparent(alpha: CGFloat)->UIColor {
        return UIColor.init(red: 0, green: 0, blue: 0, alpha: alpha)
    }
    
}
