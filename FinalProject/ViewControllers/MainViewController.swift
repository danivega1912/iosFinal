//
//  MainViewController.swift
//  FinalProject
//
//  Created by Daniel Vega on 6/14/18.
//  Copyright © 2018 Daniel Vega. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader

class MainViewController: UIViewController, QRCodeReaderViewControllerDelegate {

    
    var qrText:String = ""
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        return QRCodeReaderViewController(builder: builder)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func scanQrCode(_ sender: Any) {
        readerVC.delegate = self
        
        // Or by using the closure pattern
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            //self.showDishView()
        }
        
        // Presents the readerVC as modal form sheet
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (self.qrText != "") {
            self.showDishView()
        }
    }
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        self.qrText = result.value
        dismiss(animated: true, completion: nil)
    }
    
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        // not interesting
        
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
        exit(0)
    }
    
    func showDishView() {
        let dishVC:DishViewController = self.storyboard!.instantiateViewController(withIdentifier: "DishStoryboard") as! DishViewController
        
        // Hardcoded for test.
        dishVC.restId = 1
        
        self.qrText = ""
        
        // Show
        self.show(dishVC, sender: self)
        
    }

}
