//
//  HealthKitManager.swift
//  HealthTunes
//
//  Created by Anthony Picone on 8/19/17.
//  Copyright © 2017 Anthony Picone. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitManager: NSObject {
    
    let healthKitStore: HKHealthStore = HKHealthStore()
    
    

    func authorizeHealthKit(completion: ((_ success: Bool, _ error: NSError?) -> Void)!) {
        
        //******* It successfully goes into this ****
        
        // State the health data type(s) we want to read from HealthKit.
        let healthDataToRead = Set(arrayLiteral: HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!)
        
        
        // Just in case OneHourWalker makes its way to an iPad...
        if !HKHealthStore.isHealthDataAvailable() {
            print("Can't access HealthKit.")
        }
        
        // Request authorization to read and/or write the specific data.
        healthKitStore.requestAuthorization(toShare: nil, read: healthDataToRead) { (success, error) -> Void in
            if( completion != nil  && error != nil) {
                completion(success, error! as NSError)
            }
        }

    }
    
    
    func getHR(sampleType: HKSampleType , completion: ((HKSample?, NSError?) -> Void)!) {
        
        // Predicate for the height query
        let distantPastHR = NSDate.distantPast as NSDate
        let currentDate = NSDate()
        let lastHRPredicate = HKQuery.predicateForSamples(withStart: distantPastHR as Date, end: currentDate as Date, options: [])
        
        // Get the single most recent height
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        // Query HealthKit for the last Height entry.
        let HRQuery = HKSampleQuery(sampleType: sampleType, predicate: lastHRPredicate, limit: 1, sortDescriptors: [sortDescriptor]) { (sampleQuery, results, error ) -> Void in
            
            if let queryError = error {
                completion(nil, queryError as NSError)
                return
            }
            
            // Set the first HKQuantitySample in results as the most recent height.
            let lastHeartRate = results!.first
            
            if completion != nil {
                completion(lastHeartRate, nil)
            }
        }
        
        // Time to execute the query.
        self.healthKitStore.execute(HRQuery)
    }
    
}
