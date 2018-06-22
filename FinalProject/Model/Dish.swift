//
//  Dish.swift
//  FinalProject
//
//  Created by Daniel Vega on 6/19/18.
//  Copyright © 2018 Daniel Vega. All rights reserved.
//

import Foundation

class Dish {
    
    let name:String
    let model3dName:String
    let price:Float
    let model3dRotationX:Float
    let model3dRotationY:Float
    let model3dRotationZ:Float
    let model3dRotationRad:Float
    let model3dScaleX:Float
    let model3dScaleY:Float
    let model3dScaleZ:Float
    
    init(name:String, model3dName:String, price:Float, model3dRotationX:Float, model3dRotationY:Float, model3dRotationZ:Float, model3dRotationRad:Float, model3dScaleX:Float, model3dScaleY:Float, model3dScaleZ:Float) {
        self.name = name
        self.model3dName = model3dName
        self.price = price
        self.model3dRotationX = model3dRotationX
        self.model3dRotationY = model3dRotationY
        self.model3dRotationZ = model3dRotationZ
        self.model3dRotationRad = model3dRotationRad
        self.model3dScaleX = model3dScaleX
        self.model3dScaleY = model3dScaleY
        self.model3dScaleZ = model3dScaleZ
    }
    
}
