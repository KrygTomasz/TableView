//
//  TableViewHeader.swift
//  TableView
//
//  Created by Kryg Tomasz on 25.12.2016.
//  Copyright © 2016 Kryg Tomek. All rights reserved.
//

import UIKit

class TableViewHeader: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var expandButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setView(labelText: String) {
        self.backgroundColor = UIColor.green
        labelName.text = labelText
        expandButton.setImage(#imageLiteral(resourceName: "expandImg"), for: [])
    }
    
}
