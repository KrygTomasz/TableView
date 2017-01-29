//
//  TableManager.swift
//  TableView
//
//  Created by Kryg Tomasz on 24.01.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class TableManager {
    
    func add(object: NSManagedObject, to entity: String) {
        
        guard let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let entityObject = NSEntityDescription.entity(forEntityName: entity, in: context)
        
    }
    
}
