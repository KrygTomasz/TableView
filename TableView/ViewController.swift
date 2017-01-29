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
    
    var sections: [ABCSection] = []
    
    var longPressGesture: UILongPressGestureRecognizer!
    var sourceIndexPath: IndexPath? = nil
    var cellSnapshot: Snapshot!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAll()
        setView()
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(sender: )))
        tableView.addGestureRecognizer(longPressGesture)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func fetchAll() {
        
        let fetchedSections = EntityManager.fetch(from: "Section")
        for fetchedSection in fetchedSections {
            guard let sectionName: String = fetchedSection.value(forKey: "name") as? String else { return }
            
            sections.append(ABCSection(sectionName, numberOfRows: 3))
        }
        
        
    }
    
    func setView() {
        setTableView()
        setNavigationBar()
        setTabBar()
        setButtons()
    }
    
    func setTableView() {
        
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = Colors.background
        self.tableView.separatorColor = Colors.main
        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    func setNavigationBar() {
        
        navigationItem.rightBarButtonItem?.tintColor = Colors.main
        
    }
    
    func setTabBar() {
        
    }
    
    func setButtons() {

        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(barButtonClick))
        rightBarButton.tintColor = Colors.main
        self.navigationItem.rightBarButtonItem = rightBarButton
        
    }
    
    func barButtonClick() {
        
        showDialog()
        
    }
    
    fileprivate func showDialog() {
        
        let alert = UIAlertController(title: Localized.addHeaderTitle.localize, message: Localized.addHeaderDescription.localize, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        
        
        let cancelAction = UIAlertAction(title: Localized.cancel.localize, style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        })
        
        let saveAction = UIAlertAction(title: Localized.save.localize, style: .default, handler: {(action: UIAlertAction) -> Void in
            if let headerName: String = alert.textFields?.first?.text {
                self.addSection(ABCSection(headerName, numberOfRows: 3))
            }
        })
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    fileprivate func addSection(_ section: ABCSection) {
        sections.append(section)
        tableView.reloadData()
        Section.saveSection(name: section.name)
        let fetchedObjects = EntityManager.fetch(from: "Section")
        print(fetchedObjects.count)
    }
    
    func longPress(sender: UILongPressGestureRecognizer) {
        
        let longPressGesture: UILongPressGestureRecognizer = sender
        let gestureState: UIGestureRecognizerState = longPressGesture.state
        let currentLocation: CGPoint = longPressGesture.location(in: self.tableView)
        print(currentLocation)
        
        switch(gestureState) {
        case .began:
            popTappedCell(on: currentLocation)
            break
        case .changed:
            moveTappedCell(to: currentLocation)
            break
        default:
            placeTappedCell()
            break
        }
        
    }
    
    fileprivate func popTappedCell(on location: CGPoint) {
        
        if let newIndexPath: IndexPath = tableView.indexPathForRow(at: location) {
            sourceIndexPath = newIndexPath
            
            guard let tappedCell = tableView.cellForRow(at: sourceIndexPath!) else { return }
            cellSnapshot = tappedCell.getSnapshot()
            var cellCenter: CGPoint = tappedCell.center
            cellSnapshot?.center = cellCenter
            tableView.addSubview(cellSnapshot)
            UIView.animate(withDuration: 0.25, animations: {
                cellCenter.y = location.y
                self.cellSnapshot.center = cellCenter
                self.cellSnapshot.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.cellSnapshot.alpha = 0.8
                
                tappedCell.alpha = 0
            }, completion: { _ in
                tappedCell.isHidden = true
            })
        }
        
    }
    
    fileprivate func moveTappedCell(to newLocation: CGPoint) {
        
        moveSnapshotOnY(to: newLocation)
        
        let newIndexPath: IndexPath? = tableView.indexPathForRow(at: newLocation)
        if (newIndexPath != nil && newIndexPath != sourceIndexPath) {
            if let section: Int = newIndexPath?.section, let newRowIndex: Int = newIndexPath?.row {
                if let sourceRowIndex = sourceIndexPath?.row {
                    let clickedRow: ABCRow = sections[section].rows[sourceRowIndex]
                    sections[section].rows.remove(at: sourceRowIndex)
                    sections[section].rows.insert(clickedRow, at: newRowIndex)
                    guard let tempSourceIndexPath: IndexPath = sourceIndexPath else { return }
                    guard let tempCurrentIndexPath: IndexPath = newIndexPath else { return }
                    tableView.moveRow(at: tempSourceIndexPath, to: tempCurrentIndexPath)
                    sourceIndexPath = newIndexPath
                }
            }
        }
        
    }
    
    fileprivate func moveSnapshotOnY(to newLocation: CGPoint) {
        guard var currentCenter: CGPoint = cellSnapshot?.center else { return }
        currentCenter.y = newLocation.y
        cellSnapshot.center = currentCenter
    }
    
    fileprivate func placeTappedCell() {
        
        guard let destinationIndexPath = sourceIndexPath else { return }
        guard let currentCell = tableView.cellForRow(at: destinationIndexPath) else { return }
        currentCell.isHidden = false
        currentCell.alpha = 0.0
        
        UIView.animate(withDuration: 0.25, animations: {
            self.cellSnapshot?.center = currentCell.center
            self.cellSnapshot?.transform = CGAffineTransform.identity
            
        }, completion: { _ in
            UIView.animate(withDuration: 0.15, animations: {
                currentCell.alpha = 1.0
            }, completion: {_ in
                self.sourceIndexPath = nil
                self.cellSnapshot?.removeFromSuperview()
                self.cellSnapshot = nil
                self.tableView.reloadData()
            })
            
        })
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        // Overrides StatusBar color.
        return .lightContent
    }
    
    override var canBecomeFirstResponder: Bool {
        // Makes keyboard hide at the same time as alert window.
        return true
    }
    
    
    //MARK: - tableView delegates
    
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
        return 50.0
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let footer = Bundle.main.loadNibNamed("TableViewFooter", owner: self, options: nil)?.first as? TableViewFooter {
            
            footer.setView()
            
            footer.onFooterButtonClicked = {
                
                self.sections[section].addRow(ABCRow(title: "a"))
                self.tableView.reloadSections([section], with: .fade)
                
            }
            
            return footer
            
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if sections[section].isExpanded {
            return 60
        } else {
            return 0
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: Localized.delete.localize, handler: {
            action, index in
            self.sections[indexPath.section].rows.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .none)

        })
//        let edit = UITableViewRowAction(style: .normal, title: Localized.edit.localize, handler: {
//            action, index in
//            self.sections[indexPath.section].rows.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .none)
//        })
        delete.backgroundColor = UIColor.red
        return [delete]
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

