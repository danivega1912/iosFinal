//
//  DishViewController.swift
//  FinalProject
//
//  Created by Daniel Vega on 6/14/18.
//  Copyright © 2018 Daniel Vega. All rights reserved.
//

import UIKit
import ARKit


class DishViewController: UIViewController, ARSCNViewDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var qrLabel: UILabel!
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var dishPriceLabel: UILabel!
    @IBOutlet weak var swipeGestureImage: UIImageView!
    @IBOutlet weak var exitImage: UIImageView!
    @IBOutlet weak var labelBackgroundView: UIView!
    @IBOutlet weak var callWaitressImage: UIImageView!
    @IBOutlet weak var viewOrderImage: UIImageView!
    @IBOutlet weak var planeStatusView: UIView!
    @IBOutlet weak var planeStatusLabel: UILabel!
    
    var restId:Int              = 0
    let configuration           = ARWorldTrackingConfiguration()
    var dishOn:Bool             = false
    let api:ApiSimulator        = ApiSimulator()
    var dishes:[Dish]           = []
    var dishPosition:SCNVector3 = SCNVector3Make(0, 0, 0)
    var dishId:Int              = 0
    var selectedDishes:[Int]    = []
    
    enum ARDishSessionState: String, CustomStringConvertible {
        case initialized = "initialized", ready = "ready", temporarilyUnavailable = "temporarily unavailable", failed = "failed"
        
        var description: String {
            switch self {
            case .initialized:
                return "👀 Buscando planos para mostrar el plato..."
            case .ready:
                return "🍜 Tap en cualquier plano para mostrar!"
            case .temporarilyUnavailable:
                return "😱 Ajustanto niveles!"
            case .failed:
                return "⛔️ Error detectando planos. Reinicie la App."
            }
        }
    }
    
    var currentDishStatus = ARDishSessionState.initialized {
        didSet {
            DispatchQueue.main.async { self.planeStatusLabel.text = self.currentDishStatus.description }
            if currentDishStatus == .failed {
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set view details
        labelBackgroundView.layer.cornerRadius = 10
        labelBackgroundView.layer.backgroundColor = UIColor.lightGray.cgColor
        labelBackgroundView.alpha = 0.8
        
        dishNameLabel.text = " "
        dishPriceLabel.text = " "
        planeStatusView.layer.cornerRadius = 10
        currentDishStatus = .initialized
        
        // Get Restaurant Information
        let restaurant = api.loadRestaurants(restaurantId: restId)
        dishes = restaurant.dishes
        qrLabel.text = restaurant.name
        
        // Debug
        self.sceneView.delegate = self
        //self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        // Run AR Scene
        configuration.planeDetection = .horizontal
        self.sceneView.session.run(configuration)
        
        // Add swipe gesture recognizer (left & right)
        let left = UISwipeGestureRecognizer(target : self, action : #selector(self.leftSwipe))
        left.direction = .left
        self.view.addGestureRecognizer(left)
        let right = UISwipeGestureRecognizer(target : self, action : #selector(self.rightSwipe))
        right.direction = .right
        self.view.addGestureRecognizer(right)
        
        // Add double tap on scene to include dish on list
        let viewDishGesture = UITapGestureRecognizer(target: self, action: #selector(viewDish(tapGestureRecognizer:)))
        sceneView.isUserInteractionEnabled = true
        viewDishGesture.numberOfTapsRequired = 2
        sceneView.addGestureRecognizer(viewDishGesture)
        
        // Add exit image tap recognizer
        let exitTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(exitDishView(tapGestureRecognizer:)))
        exitImage.isUserInteractionEnabled = true
        exitImage.addGestureRecognizer(exitTapGestureRecognizer)
        
        // Add Call Waitress Tap recognizer
        let waitressTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(callWaitress(tapGestureRecognizer:)))
        callWaitressImage.isUserInteractionEnabled = true
        callWaitressImage.addGestureRecognizer(waitressTapGestureRecognizer)
        
        // Add View Order Image tap recognizer
        let viewOrderTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewOrder(tapGestureRecognizer:)))
        viewOrderImage.isUserInteractionEnabled = true
        viewOrderImage.addGestureRecognizer(viewOrderTapGestureRecognizer)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailSegue") {
            let vc = segue.destination as! dishDetailViewController
            vc.dishId = dishId
        }
    }
    
    @objc
    func viewDish(tapGestureRecognizer: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "detailSegue", sender: nil)
    }
    
    @objc
    func callWaitress(tapGestureRecognizer: UITapGestureRecognizer) {
        // Declare Alert message
        print("call Waitress")
    }
    
    @objc
    func viewOrder(tapGestureRecognizer: UITapGestureRecognizer) {
        // Declare Alert message
        print("view order")
        
    }
    
    @objc
    func exitDishView(tapGestureRecognizer: UITapGestureRecognizer) {
        // Declare Alert message
        let dialogMessage = UIAlertController(title: "Confirmar", message: "Seguro desea salir?", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            
            // Don't do this
            self.dismiss(animated: true, completion: nil)
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel) { (action) -> Void in
            // Do noop
        }
        
        // Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to userself.prepare
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    /* -- All relative to AR -- */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // If anchor is type Horizontal Plane => change current dish status
        if anchor is ARPlaneAnchor {
            currentDishStatus = .ready
        }
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
        print("session interrupted")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        print("vuelvo")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //only for the fish dish
        if !dishOn && currentDishStatus == .ready  {
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
            // Hide Plane Status Indicator
            hidePlaneStatusUIView()
            // Show Swipe Gesture Image
            showSwipeGestureImage()
        }
    }
    
    func addDishToTable() {
        let dish:Dish = dishes[dishId]
        guard let model3D = SCNScene(named: "./" + dishes[dishId].model3dName) else { print("cant find dish"); return }
        model3D.rootNode.enumerateChildNodes {(node, _) in
            // Show Dish - Name & Price
            dishNameLabel.text = dish.name
            dishPriceLabel.text = "$ " + dish.price.description
            if (node.name == "mainNode") {
                // Prepare Node
                node.position = SCNVector3Make(0, 0, 0)
                node.rotation = SCNVector4Make(dish.model3dRotationX, dish.model3dRotationY, dish.model3dRotationZ, dish.model3dRotationRad)
                // Set Position
                node.position = dishPosition
                // Set Scale
                node.scale = SCNVector3Make(dish.model3dScaleX, dish.model3dScaleY, dish.model3dScaleZ)
                // Set Start Opacity
                node.opacity = 0
                // Put Dish on Scene
                sceneView.scene.rootNode.addChildNode(node)
                // Fade In
                node.runAction(SCNAction.fadeIn(duration: 1))
            }
        }
    }
    
    @objc
    func leftSwipe(){
        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.name == "mainNode" {
                node.runAction(SCNAction.fadeOut(duration: 1), completionHandler: { node.removeFromParentNode() })
            }
        }
        dishId = dishId < dishes.count-1 ? dishId + 1 : dishId
        addDishToTable()
    }
    
    @objc
    func rightSwipe(){
        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.name == "mainNode" {
                node.runAction(SCNAction.fadeOut(duration: 1), completionHandler: { node.removeFromParentNode() })
            }
        }
        dishId = dishId > 0 ? dishId - 1 : 0
        addDishToTable()
    }
    
    func showSwipeGestureImage() {
        UIView.animate(withDuration: 1, delay: 0, options: .showHideTransitionViews, animations: { () -> Void in
            self.swipeGestureImage.alpha = 1
        }, completion: {
            (Bool) -> Void in
            self.moveSwipeGestureImage(value: 1)
        })
    }
    
    func moveSwipeGestureImage(value:Int) {
        switch value {
        case (1), (3):
            UIView.animate(withDuration: 0.5, delay: 0, options: .showHideTransitionViews, animations: { () -> Void in
                self.swipeGestureImage.frame.origin.x -= 30
            }, completion: { (Bool) -> Void in self.moveSwipeGestureImage(value: value+1) })
            break
        case 2:
            UIView.animate(withDuration: 1, delay: 0, options: .showHideTransitionViews, animations: { () -> Void in
                self.swipeGestureImage.frame.origin.x += 60
            }, completion: { (Bool) -> Void in self.moveSwipeGestureImage(value: value+1) })
            break
        default:
            UIView.animate(withDuration: 1, delay: 0, options: .showHideTransitionViews, animations: { () -> Void in
                self.swipeGestureImage.alpha = 0
            }, completion: {
                (Bool) -> Void in })
        }
    }
    
    func hidePlaneStatusUIView() {
        UIView.animate(withDuration: 1, delay: 0, options: .showHideTransitionViews, animations: { () -> Void in
            self.planeStatusView.alpha = 0
        }, completion: {
            (Bool) -> Void in
            
        })
    }
}
