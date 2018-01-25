//
//  Item.swift
//  Todoey
//
//  Created by Николай Маторин on 25.01.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
