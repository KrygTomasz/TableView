//
//  ViewController.swift
//  TableView
//
//  Created by Kryg Tomasz on 24.12.2016.
//  Copyright © 2016 Kryg Tomek. All rights reserved.
//

import UIKit

struct cellData {
    
    let button1Text: String
    let button2Text: String
    let button3Text: String
    
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var arrayOfCells = [cellData]()
    var numberOfSections = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrayOfCells = [
            cellData(button1Text: "no 11", button2Text: "no 12", button3Text: "no 13"),
            cellData(button1Text: "no 21", button2Text: "no 22", button3Text: "no 23")
        ]
        
        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as? TableViewCell {
            cell.button1.setTitle(arrayOfCells[indexPath.row].button1Text, for: [])
            cell.button2.setTitle(arrayOfCells[indexPath.row].button2Text, for: [])
            cell.button3.setTitle(arrayOfCells[indexPath.row].button3Text, for: [])
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }


}

