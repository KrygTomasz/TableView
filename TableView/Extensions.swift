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


extension UIView {
    
    func getSnapshot()->UIView {
        // Make an image from the input view.
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        guard let currentContext: CGContext = UIGraphicsGetCurrentContext() else {
            return UIView()
        }
        self.layer.render(in: currentContext)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let snapshot = UIImageView(image: image)
        snapshot.layer.masksToBounds = false
        snapshot.layer.cornerRadius = 0.0
        snapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        snapshot.layer.shadowRadius = 5.0
        snapshot.layer.shadowOpacity = 0.4
        
        return snapshot
    }
    
}
