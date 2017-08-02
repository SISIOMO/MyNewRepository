//
//  MySet.swift
//  WOApp
//
//  Created by rc on 31/07/2017.
//  Copyright © 2017 SISIOMO. All rights reserved.
//

import UIKit
import CoreData

class MySet: NSManagedObject {
    
    static var count: Int64 = 0
    
    func convertToCsvString() -> String {
        
        var myString = String(index)
        
        myString = myString + "," + String(reps)
        myString = myString + "," + String(weight)
        myString = myString + "," + (exercise?.name ?? "(nil)")
        
        if workout?.dateStart != nil {
            myString = myString + "," + (workout?.dateStart)!.description + "\n"
        }
        else {
            myString = myString + ",(nil)\n"
        }
        
        return myString
    }
    
    func read() {
        print("* index = \(index)")
        print("  * reps = \(reps)")
        print("  * weight = \(weight)")
        print("  * exercise = \(exercise?.name ?? "nil")")
    }

}
