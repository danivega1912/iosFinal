//
//  dishDetailViewController.swift
//  FinalProject
//
//  Created by Daniel Vega on 6/26/18.
//  Copyright © 2018 Daniel Vega. All rights reserved.
//

import UIKit

class dishDetailViewController: UIViewController {

    
    @IBOutlet weak var dishDetailLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addDishButton: UIButton!
    @IBOutlet weak var dishDetailView: UIView!
    
    var dishId:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        dishDetailView.layer.cornerRadius = 10
        dishDetailView.layer.masksToBounds = true
        
        cancelButton.backgroundColor        = .clear
        cancelButton.layer.cornerRadius     = 5
        cancelButton.layer.borderWidth      = 1
        cancelButton.layer.borderColor      = UIColor.gray.cgColor
        
        addDishButton.backgroundColor       = .clear
        addDishButton.layer.cornerRadius    = 5
        addDishButton.layer.borderWidth     = 1
        addDishButton.layer.borderColor     = UIColor.gray.cgColor
        
        // Add swipe gesture recognizer (right)
        let right = UISwipeGestureRecognizer(target : self, action : #selector(self.cancelAction(_:)))
        right.direction = .right
        self.view.addGestureRecognizer(right)
        
        // Get Dish Detail from API
        dishDetailLabel.text = ApiSimulator().getDishDetail(dishId: dishId)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addDishToOrder(_ sender: UIButton) {
        print("add dish to order")
    }
    

    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
