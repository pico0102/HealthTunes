//
//  HRViewController.swift
//  HealthTunes
//
//  Created by Anthony Picone on 8/19/17.
//  Copyright © 2017 Anthony Picone. All rights reserved.
//

import UIKit
import HealthKit

class HRViewController: UIViewController {
    
    let healthManager:HealthKitManager = HealthKitManager()
    var hr: HKQuantitySample?
    
    @IBOutlet weak var authorizeButton: UIButton!
    @IBOutlet weak var bpmLabel: UILabel!

    @IBAction func authorizeTapped(_ sender: Any) {
        getHealthKitPermission()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(<#T##animated: Bool##Bool#>)

    }
    
    func setHeight() {
        // Create the HKSample for Height.
        let hrSample = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)
        
        // Call HealthKitManager's getSample() method to get the user's height.
        self.healthManager.getHR(sampleType: hrSample!, completion: { (userHr, error) -> Void in
            
            if( error != nil ) {
                print("Error: \(String(describing: error?.localizedDescription))")
                return
            }
            
            var hrString = ""
            
            
            //let heartRateUnit: HKUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
            //let heartRateQuantity: HKQuantity = HKQuantity(unit: heartRateUnit, doubleValue: hrSample)
            
            
            self.hr = userHr as? HKQuantitySample
            hrString = (userHr?.description)!
            print("HR: " + hrString)
            //hrString = self.hr
            
            
            // Set the label to reflect the user's height.
            DispatchQueue.main.async(execute: { () -> Void in
                self.bpmLabel.text = hrString
            })
        })
        
    }
    

    func getHealthKitPermission() {
       
        
        // Seek authorization in HealthKitManager.swift.
        healthManager.authorizeHealthKit { (authorized,  error) -> Void in
            if authorized {
                 self.authorizeButton.isHidden = true
                // Get and set the user's height.
                self.setHeight()
            } else {
                if error != nil {
                    print(error!)
                }
                print("Permission denied.")
            }
        }
    }
}
