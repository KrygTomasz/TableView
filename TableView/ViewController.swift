//
//  ViewController.swift
//  TableView
//
//  Created by Kryg Tomasz on 24.12.2016.
//  Copyright © 2016 Kryg Tomek. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var addHeaderButton: UIBarButtonItem!
    
    var currentExpandedSection: Int? = nil
    
    var sections = [
        Section("Header 0", numberOfRows: 3),
        Section("Header 1", numberOfRows: 5),
        Section("Header 2", numberOfRows: 4),
        Section("Header 3", numberOfRows: 2)
    ]
    
    var longPressGesture: UILongPressGestureRecognizer!
    var sourceIndexPath: IndexPath? = nil
    var snapshot: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(sender: )))
        tableView.addGestureRecognizer(longPressGesture)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func setView() {
        setTableView()
        setNavigationBar()
        setTabBar()
        setButton()
    }
    
    func setTableView() {
        
        self.tableView.backgroundColor = UIColor.darkGray
        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    func setNavigationBar() {
        
    }
    
    func setTabBar() {
        
    }
    
    func setButton() {
        addHeaderButton.title = "Add header"
        addHeaderButton.target = self
        addHeaderButton.action = #selector(headerButtonClick)
    }
    
    func headerButtonClick() {
        
        showDialog()
        
    }
    
    fileprivate func showDialog() {
        
        let alert = UIAlertController(title: "Add Header", message: "Type new header name", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {(action: UIAlertAction) -> Void in
            
            if let headerName: String = alert.textFields?.first?.text {
                self.addSection(Section(headerName, numberOfRows: 3))
            }
            
            
        })
        
        alert.addAction(saveAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func addSection(_ section: Section) {
        sections.append(section)
        tableView.reloadData()
    }
    
    func longPress(sender: UILongPressGestureRecognizer) {
        
        let longPressGesture: UILongPressGestureRecognizer = sender
        let gestureState: UIGestureRecognizerState = longPressGesture.state
        let currentLocation: CGPoint = longPressGesture.location(in: self.tableView)
        let currentIndexPath: IndexPath? = tableView.indexPathForRow(at: currentLocation)
        print("Long Press \(currentIndexPath?.row)")
        print(currentLocation)
        
        switch(gestureState) {
        case .began:
            if (currentIndexPath != nil) {
                sourceIndexPath = currentIndexPath
                guard let tappedCell = tableView.cellForRow(at: sourceIndexPath!) else {break}
                snapshot = customSnapshot(for: tappedCell)
                var cellCenter: CGPoint = tappedCell.center
                snapshot?.center = cellCenter
                snapshot?.alpha = 0
                tableView.addSubview(snapshot)
                UIView.animate(withDuration: 0.25, animations: {
                    cellCenter.y = currentLocation.y
                    self.snapshot.center = cellCenter
                    //transform?
                    self.snapshot.alpha = 0.5
                    
                    tappedCell.alpha = 0
                }, completion: {
                    finished in
                    tappedCell.isHidden = true
                })
            }
            break
        case .changed:
            var currentCenter: CGPoint = snapshot.center
            currentCenter.y = currentLocation.y
            snapshot.center = currentCenter
            
            if (currentIndexPath != nil && currentIndexPath != sourceIndexPath) {
                if let section: Int = currentIndexPath?.section, let currentRowIndex: Int = currentIndexPath?.row {
                    if let sourceRowIndex = sourceIndexPath?.row {
                        let clickedRow: Row = sections[section].rows[sourceRowIndex]
                        sections[section].rows.remove(at: sourceRowIndex)
                        sections[section].rows.insert(clickedRow, at: currentRowIndex)
                        sourceIndexPath = currentIndexPath
                        tableView.reloadRows(at: [currentIndexPath!], with: .automatic)
                    }
                }
            }
            break
        default:
            guard let sourceIndexPathTmp = sourceIndexPath else {
                return
            }
            guard let cell = tableView.cellForRow(at: sourceIndexPathTmp) else {
                return
            }
            cell.isHidden = false
            cell.alpha = 0.0
            
            UIView.animate(withDuration: 0.25, animations: {
                self.snapshot?.center = cell.center
                //self.snapshot?.transform = CGAffineTransformIdentity
                self.snapshot?.alpha = 0.0
                
                cell.alpha = 1.0
            }, completion: { _ in
                self.sourceIndexPath = nil
                self.snapshot?.removeFromSuperview()
                self.snapshot = nil
            })
            tableView.reloadData()
            break
        }
        
    }
    
    func customSnapshot(for view: UIView)->UIView {
            // Make an image from the input view.
            UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
            view.layer.render(in: UIGraphicsGetCurrentContext()!)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        // Overrides StatusBar color
        return .lightContent
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if sections[section].isExpanded {
            return sections[section].rows.count
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as? TableViewCell {
            cell.setView()
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let header = Bundle.main.loadNibNamed("TableViewHeader", owner: self, options: nil)?.first as? TableViewHeader {
            
            header.setView(labelText: sections[section].name, isExpanded: sections[section].isExpanded)
            
            header.onHeaderButtonClicked = {
                let previousExpandedSection = self.currentExpandedSection
                let sectionObject = self.sections[section]
                if sectionObject.isExpanded {
                    sectionObject.isExpanded = false
                    self.currentExpandedSection = nil
                    self.tableView.beginUpdates()
                    self.tableView.reloadSections([section], with: .automatic)
                    self.tableView.endUpdates()
                } else {
                    sectionObject.isExpanded = true
                    self.currentExpandedSection = section
                    if previousExpandedSection != nil {
                        self.sections[previousExpandedSection!].isExpanded = false
                        self.tableView.reloadSections([section, previousExpandedSection!], with: .automatic)
                    } else {
                        self.tableView.reloadSections([section], with: .automatic)
                    }
                }
            }
            return header
            
        } else {
            return UIView()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        if let footer = Bundle.main.loadNibNamed("TableViewFooter", owner: self, options: nil)?.first as? TableViewFooter {
//            
//            footer.setView()
//            
//            footer.onFooterButtonClicked = {
//                
//                self.sections[section].addRow(Row())
//                self.tableView.reloadSections([section], with: .fade)
//                
//            }
//            
//            return footer
//            
//        } else {
//            return UIView()
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if sections[section].isExpanded {
//            return 60
//        } else {
//            return 0
//        }
//    }
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete", handler: {
            action, index in
            self.sections[indexPath.section].rows.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        })
        let edit = UITableViewRowAction(style: .normal, title: "Edit", handler: {
            action, index in
            self.sections[indexPath.section].rows.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        })
        delete.backgroundColor = UIColor.red
        edit.backgroundColor = UIColor.blue
        return [delete, edit]
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedRow = sections[sourceIndexPath.section].rows[sourceIndexPath.row]
        sections[sourceIndexPath.section].rows.remove(at: sourceIndexPath.row)
        sections[sourceIndexPath.section].rows.insert(movedRow, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            tableView.beginUpdates()
            sections[indexPath.section].rows.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.endUpdates()
            //tableView.reloadData()
        } else if (editingStyle == .insert){
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        //tableView.beginUpdates()
        //tableView.reloadRows(at: [indexPath], with: .automatic)
        //tableView.endUpdates()
    }
    
    

}

