//
//  Restaurant.swift
//  FinalProject
//
//  Created by Daniel Vega on 6/19/18.
//  Copyright © 2018 Daniel Vega. All rights reserved.
//

import Foundation

class Restaurant {
    var id:Int
    var name:String
    var dishes:[Dish] = []
    
    
    init(id:Int, name:String, dishes:[Dish]) {
        self.id = id
        self.name = name
        self.dishes = dishes
    }
    
}
