//
//  Item.swift
//  Todoey
//
//  Created by Николай Маторин on 24.01.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation

class Item {
    public private(set) var title: String?
    var done: Bool
    
    init(title: String) {
        self.title = title
        self.done = false
    }
}
