//
//  ViewController.swift
//  TableView
//
//  Created by Kryg Tomasz on 24.12.2016.
//  Copyright © 2016 Kryg Tomek. All rights reserved.
//

import UIKit

class Section {
    
    var isExpanded: Bool = false
    var rows = [Row]()
    
    init(numberOfRows: Int) {
        for _ in 0..<numberOfRows {
            rows.append(Row())
        }
    }
    
}

class Row {
    
    let button1Text: String = "button1"
    let button2Text: String = "button2"
    let button3Text: String = "button3"
    
}


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var addHeaderButton: UIBarButtonItem!
    
    var currentExpandedSection: Int? = nil
    
    var sections = [
        Section(numberOfRows: 3),
        Section(numberOfRows: 5),
        Section(numberOfRows: 4),
        Section(numberOfRows: 2)
    ]
    
    override func viewDidLoad() {
        sections.append(Section(numberOfRows: 10))
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
        let alert = UIAlertController(title: "Add Header", message: "Type new header name", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {(action: UIAlertAction) -> Void in
        
            let headerName = alert.textFields?.first
            
            self.addSection(Section(numberOfRows: 3))
        
        
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
            
            header.setView(labelText: "Header " + String(section), isExpanded: sections[section].isExpanded)
            
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
    
    

}

