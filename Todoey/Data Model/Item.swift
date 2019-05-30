//
//  Item.swift
//  Todoey
//
//  Created by Poorna Chandra Vemula on 28/05/19.
//  Copyright © 2019 Poorna Chandra Vemula. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    
    @objc dynamic  var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    @objc dynamic var color : String = ""
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
