//
//  RealmDataService.swift
//  Todoey
//
//  Created by Николай Маторин on 25.01.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDataService {
    
    static let sharedInstance = RealmDataService()
    
    let realm = try! Realm()
    
    private init() {
        
    }
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch  {
            print("Error saving category \(error)")
        }
    }
    
    func save(item: Item, forCategory category: Category) {
        do {
            try realm.write {
                category.items.append(item)
            }
        } catch  {
            print("Error saving item \(error)")
        }
    }
}
