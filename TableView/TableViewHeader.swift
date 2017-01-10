//
//  TableViewHeader.swift
//  TableView
//
//  Created by Kryg Tomasz on 25.12.2016.
//  Copyright © 2016 Kryg Tomek. All rights reserved.
//

import UIKit

class TableViewHeader: UIView {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var expandButton: UIButton!
    
    var onHeaderButtonClicked : (()->Void)!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setView(labelText: String, isExpanded: Bool) {
        
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        labelName.text = labelText
        labelName.textColor = UIColor.white
        
        expandButton.setImage(#imageLiteral(resourceName: "expandImg"), for: [])
        expandButton.tintColor = UIColor.white
        expandButton.addTarget(self, action: #selector(TableViewHeader.buttonClick), for: .touchUpInside)
        if isExpanded {
            expandButton.rotate(by: CGFloat(M_PI))
        }
        
    }
    
    func buttonClick() {
        
        onHeaderButtonClicked()
        UIView.animate(withDuration: 0.2, animations: {
            self.expandButton.rotate(by: CGFloat(M_PI))
        })
        
    }
    
    
    
    
    
}
