//
//  ApiSimulator.swift
//  FinalProject
//
//  Created by Daniel Vega on 6/19/18.
//  Copyright © 2018 Daniel Vega. All rights reserved.
//

import Foundation

class ApiSimulator {
    
    var restaurants:[Restaurant] = []
    var dishes:[Dish] = []
    
    
    func loadRestaurants(restaurantId:Int) -> Restaurant {
        self.loadDishes()
        let restaurant:Restaurant = Restaurant(id: 1, name: "La Parrilla Bonachona", dishes: dishes)
        return restaurant
    }
    
    func loadDishes() {
        let dish0:Dish = Dish.init(name: "Torta de Chocolate", model3dName: "Cake.dae", price: 125.00, model3dRotationX: 1, model3dRotationY: 0, model3dRotationZ: 0, model3dRotationRad: -1.6, model3dScaleX: 0.000013, model3dScaleY: 0.000013, model3dScaleZ: 0.000013)
        dishes.append(dish0)
        
        let dish1:Dish = Dish.init(name: "Chocolate Cake 1", model3dName: "Cake.dae", price: 126.00, model3dRotationX: 1, model3dRotationY: 0, model3dRotationZ: 0, model3dRotationRad: -1.6, model3dScaleX: 0.000013, model3dScaleY: 0.000013, model3dScaleZ: 0.000013)
        dishes.append(dish1)

        let dish2:Dish = Dish.init(name: "Chocolate Cake 2", model3dName: "Cake.dae", price: 127.00, model3dRotationX: 1, model3dRotationY: 0, model3dRotationZ: 0, model3dRotationRad: -1.6, model3dScaleX: 0.000013, model3dScaleY: 0.000013, model3dScaleZ: 0.000013)
        dishes.append(dish2)

        let dish3:Dish = Dish.init(name: "Chocolate Cake 3", model3dName: "Cake.dae", price: 128.00, model3dRotationX: 1, model3dRotationY: 0, model3dRotationZ: 0, model3dRotationRad: -1.6, model3dScaleX: 0.000013, model3dScaleY: 0.000013, model3dScaleZ: 0.000013)
        dishes.append(dish3)
        
        let dish4:Dish = Dish.init(name: "Banana", model3dName: "Banana.dae", price: 15.50, model3dRotationX: 1, model3dRotationY: 0, model3dRotationZ: 0, model3dRotationRad: 0, model3dScaleX: 0.015, model3dScaleY: 0.015, model3dScaleZ: 0.015)
        dishes.append(dish4)
        
    }
    
    func getDishDetail(dishId:Int) -> String {
        var dishDetail:String = ""
        
        switch dishId {
        case 0:
            dishDetail = "Sencillo bizcocho de chocolate bañado en una deliciosa cobertura de crema de chocolate... chocolate más chocolate, acierto seguro..."
            break
        case 1:
            dishDetail = "Detail 1"
            break
        case 2:
            dishDetail = "Detail 2"
            break
        case 3:
            dishDetail = "Detail 3"
            break
        default:
            //oopss!
            dishDetail = "Disculpas!, no pudimos encontrar una descripcion para este plato."
        }
        
        return dishDetail
    }
}
