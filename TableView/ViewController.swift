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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
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
            cell.button1.setTitle(Row().button1Text, for: [])
            cell.button2.setTitle(Row().button2Text, for: [])
            cell.button3.setTitle(Row().button3Text, for: [])
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let footer = Bundle.main.loadNibNamed("TableViewFooter", owner: self, options: nil)?.first as? TableViewFooter {
            
            footer.setView()
            
            footer.onFooterButtonClicked = {
                
                self.sections[section].addRow(Row())
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            sections[indexPath.section].rows.remove(at: indexPath.row)
                        tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
        //tableView.beginUpdates()
        //tableView.reloadRows(at: [indexPath], with: .automatic)
        //tableView.endUpdates()
    }
    
    

}

