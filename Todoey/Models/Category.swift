//
//  Category.swift
//  Todoey
//
//  Created by Николай Маторин on 25.01.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import RealmSwift
import ChameleonFramework

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var hexColor: String = UIColor.randomFlat.hexValue()
    let items = List<Item>()
}
