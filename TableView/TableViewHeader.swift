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
    @IBOutlet weak var editableLabelName: UITextField!
    @IBOutlet weak var expandButton: UIButton!
    
    var onHeaderButtonClicked : (()->Void)!
    
    var headerExpanded: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setView(labelText: String, isExpanded: Bool) {

        self.backgroundColor = UIColor.transparent(alpha: 0.5)
        
        setLabels(with: labelText)
        
        headerExpanded = isExpanded
        
        setButtons()
        
    }
    
    func setLabels(with text: String) {
        
        labelName.text = text
        labelName.textColor = Colors.main
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelTap))
        labelName.addGestureRecognizer(tapGesture)
        //expandButton.addGestureRecognizer(tapGesture)
        
        editableLabelName.text = text
        editableLabelName.isHidden = true
        
    }
    
    func labelTap() {
        
        labelName.isHidden = true
        editableLabelName.isHidden = false
        
    }
    
    func setButtons() {
        
        expandButton.setImage(#imageLiteral(resourceName: "expand"), for: [])
        expandButton.tintColor = Colors.main
        expandButton.addTarget(self, action: #selector(expandButtonClick), for: .touchUpInside)
        if headerExpanded {
            expandButton.rotate(by: CGFloat(M_PI))
        }
        
    }
    
    func expandButtonClick() {
        
        onHeaderButtonClicked()
        UIView.animate(withDuration: 0.2, animations: {
            self.expandButton.rotate(by: CGFloat(M_PI))
        })
        
    }
    
    
    
    
    
}
