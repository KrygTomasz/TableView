//
//  TableViewFooter.swift
//  TableView
//
//  Created by Kryg Tomasz on 14.01.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import UIKit

class TableViewFooter: UIView {
    
    @IBOutlet weak var addButton: UIButton!
    
    var onFooterButtonClicked: (()->())!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setView() {

        self.backgroundColor = UIColor.transparent(alpha: 0.5)
        addButton.titleLabel?.text = "Add Row"
        addButton.addTarget(self, action: #selector(addButtonClick), for: .touchUpInside)
        
    }
    
    func addButtonClick() {
        
        onFooterButtonClicked()
        
    }
    
}
