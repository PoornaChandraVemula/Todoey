//
//  Category.swift
//  Todoey
//
//  Created by Poorna Chandra Vemula on 28/05/19.
//  Copyright © 2019 Poorna Chandra Vemula. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
   
    @objc dynamic var name : String = ""
    let items = List<Item>()
    
}
