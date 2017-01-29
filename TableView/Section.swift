//
//  Section.swift
//  TableView
//
//  Created by Kryg Tomasz on 28.01.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import Foundation
import UIKit
import CoreData


public class Section: NSManagedObject {
    
    @NSManaged public var name: String?
    @NSManaged public var isExpanded: Bool
    @NSManaged public var rows: NSSet?
    
    static func saveSection(name: String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let entity: NSEntityDescription =  NSEntityDescription.entity(forEntityName: "Section", in:managedContext) else { return }
        
        let section = NSManagedObject(entity: entity, insertInto: managedContext)
        
        section.setValue(name, forKey: "name")
        
        do {
            try managedContext.save()
            print("Section added. Name: \(name).")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
}
