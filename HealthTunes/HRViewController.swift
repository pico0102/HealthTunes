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
    
    //create HM instance
    
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
    
    
    func setHR() {
        
        // Create the HKSample for HR.
        let hrSample = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)
        
        // Call HealthKitManager's getSample() method to get the user's hr.
        self.healthManager.getHR(sampleType: hrSample!, completion: { (userHr, error) -> Void in
            
            //***** It seems like it never actually goes into this method ******
            
            
            if( error != nil ) {
                print("Error: \(String(describing: error?.localizedDescription))")
                return
            }
            
            var hrString = ""
            
            print("HR: ")
            print(hrSample!)
            
            
            //let heartRateUnit: HKUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
            //let heartRateQuantity: HKQuantity = HKQuantity(unit: heartRateUnit, doubleValue: hrSample)
            
            
            self.hr = userHr as? HKQuantitySample
            hrString = (userHr?.description)!
            
            self.bpmLabel.text = hrString
            //hrString = self.hr
            
            
            // Set the label to reflect the user's height.
            DispatchQueue.main.async(execute: { () -> Void in
                //self.bpmLabel.text = "TEST"
            })
        })
        
    }
    

    func getHealthKitPermission() {
        
        // Seek authorization in HealthKitManager.swift.
        
        //**** It authorizes, but doesnt go into the setHR method ***
        
        healthManager.authorizeHealthKit { (authorized,  error) -> Void in
            
            print("test")
            
            if authorized {
                
                // Get and set the user's height.
                self.setHR()
            } else {
                if error != nil {
                    print(error!)
                }
                print("Permission denied.")
            }
        }
    }
}
