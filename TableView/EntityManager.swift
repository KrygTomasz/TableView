//
//  EntityManager.swift
//  TableView
//
//  Created by Kryg Tomasz on 23.01.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import UIKit
import CoreData

class EntityManager {
    
    static func fetch(from entity: String) -> [NSManagedObject] {
        
        guard let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        do {
            let results = try context.fetch(fetchRequest)
            guard let fetchedObjects = results as? [NSManagedObject] else {
                print("Fetch failed.")
                return []
            }
            return fetchedObjects
        } catch let error as NSError {
            print("Couldn't fetch objects due to \(error).")
            return []
        }

    }
    
}
