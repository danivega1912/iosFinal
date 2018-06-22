//
//  DishViewController.swift
//  FinalProject
//
//  Created by Daniel Vega on 6/14/18.
//  Copyright © 2018 Daniel Vega. All rights reserved.
//

import UIKit
import ARKit


class DishViewController: UIViewController, ARSCNViewDelegate {

    var restId:Int = 0
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    var dishOn:Bool = false
    let api:ApiSimulator = ApiSimulator()
    var dishes:[Dish] = []
    var dishPosition:SCNVector3 = SCNVector3Make(0, 0, 0)
    var dishId:Int = 0
    
    @IBOutlet weak var qrLabel: UILabel!
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var dishPriceLabel: UILabel!
    @IBOutlet weak var swipeGestureImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get Restaurant Information
        let restaurant = api.loadRestaurants(restaurantId: restId)
        dishes = restaurant.dishes
        qrLabel.text = restaurant.name
        super.viewDidLoad()
        
        // Debug
        //self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        self.sceneView.session.run(configuration)
        
        // Add swipe gesture recognizer (left & right)
        let left = UISwipeGestureRecognizer(target : self, action : #selector(self.leftSwipe))
        left.direction = .left
        self.view.addGestureRecognizer(left)
        let right = UISwipeGestureRecognizer(target : self, action : #selector(self.rightSwipe))
        right.direction = .right
        self.view.addGestureRecognizer(right)
        
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* -- All relative to AR -- */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Create a session configuration
        //let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        //sceneView.session.run(configuration)
        
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //only for the fish dish
        if !dishOn {
            guard let touch = touches.first else { return }
            let result = sceneView.hitTest(touch.location(in: sceneView), types: [ARHitTestResult.ResultType.estimatedHorizontalPlane])
            guard let hitResult = result.last else { return }
            let hitTransform = SCNMatrix4(hitResult.worldTransform)
            let hitVector = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
            // Save final position
            dishPosition = hitVector
            self.addDishToTable()
            // Dish is already placed in scene
            dishOn = true
            // Show Swipe Gesture Image
            showSwipeGestureImage()
        }
    }
    
    func addDishToTable() {
        let dish:Dish = dishes[dishId]
        guard let model3D = SCNScene(named: "./" + dishes[dishId].model3dName) else { print("cant find dish"); return }
    
        model3D.rootNode.enumerateChildNodes {(node, _) in
            // Show Dish Name & Price
            dishNameLabel.text = dish.name
            dishPriceLabel.text = dish.price.description
            
            if (node.name == "mainNode") {
                // Prepare Node
                node.position = SCNVector3Make(0, 0, 0)
                node.rotation = SCNVector4Make(dish.model3dRotationX, dish.model3dRotationY, dish.model3dRotationZ, dish.model3dRotationRad)
                // Set Position
                node.position = dishPosition
                // Set Scale
                node.scale = SCNVector3Make(dish.model3dScaleX, dish.model3dScaleY, dish.model3dScaleZ)
                // Put Dish on Scene
                sceneView.scene.rootNode.addChildNode(node)
            }
        }
    }
    
    @objc
    func leftSwipe(){
        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.name == "mainNode" {
                node.removeFromParentNode()
            }
        }
        dishId = dishId < dishes.count-1 ? dishId + 1 : dishId
        addDishToTable()
    }
    
    @objc
    func rightSwipe(){
        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.name == "mainNode" {
                node.removeFromParentNode()
            }
        }
        dishId = dishId > 0 ? dishId - 1 : 0
        addDishToTable()
    }
    
    func showSwipeGestureImage() {
        UIView.animate(withDuration: 2, delay: 0, options: .showHideTransitionViews, animations: { () -> Void in
            self.swipeGestureImage.alpha = 1
        }, completion: {
            (Bool) -> Void in
            self.moveSwipeGestureImage(value: 1)
        })
    }
    
    func moveSwipeGestureImage(value:Int) {
        
        switch value {
        case (1), (3):
            UIView.animate(withDuration: 1, delay: 0, options: .showHideTransitionViews, animations: { () -> Void in
                self.swipeGestureImage.frame.origin.x -= 100
            }, completion: { (Bool) -> Void in self.moveSwipeGestureImage(value: value+1) })
            break
        case 2:
            UIView.animate(withDuration: 2, delay: 0, options: .showHideTransitionViews, animations: { () -> Void in
                self.swipeGestureImage.frame.origin.x += 200
            }, completion: { (Bool) -> Void in self.moveSwipeGestureImage(value: value+1) })
            break
        default:
            UIView.animate(withDuration: 2, delay: 0, options: .showHideTransitionViews, animations: { () -> Void in
                self.swipeGestureImage.alpha = 0
            }, completion: {
                (Bool) -> Void in })
        }
    }

}
