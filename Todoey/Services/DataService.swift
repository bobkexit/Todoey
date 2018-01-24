//
//  DataService.swift
//  Todoey
//
//  Created by Николай Маторин on 24.01.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit
import CoreData

class DataService {
    static let sharedInstance = DataService()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private init () {
        
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadItems(forCategory category: Category, andFilteredBy title: String?, completion: @escaping ([Item]) -> Void) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        var subpredicates = [NSPredicate(format: "parentCategory.name MATCHES %@", category.name!)]
        
        if let title = title {
            
            subpredicates.append(NSPredicate(format: "title CONTAINS[cd] %@", title))
            
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
        }
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: subpredicates)
        
        do {
            let result = try context.fetch(request)
            completion(result)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    func loadCategories(completion: @escaping ([Category]) -> Void) {
      
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            let result = try context.fetch(request)
            completion(result)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
}
