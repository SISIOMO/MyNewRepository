//
//  Workout.swift
//  WOApp
//
//  Created by rc on 31/07/2017.
//  Copyright © 2017 SISIOMO. All rights reserved.
//

import UIKit
import CoreData

class Workout: NSManagedObject {

    var isCurrentWorkout: Bool { return (dateEnd != nil) }
    
    func convertToCsvString() -> String {
        
        var myString = (dateStart?.description ?? "(nil)")
        
        myString = myString + "," + (dateEnd?.description ?? "(nil)")
        myString = myString + "," + String(duration)
        myString = myString + "," + (notes == nil ? "(nil)" : "\"" + notes! + "\"") + ","
        
        if let mySets = mySets as? Set<MySet> {
            var isFirst = true
            for mySet in mySets {
                myString = myString + (isFirst ? "\"" : ",") + String(mySet.index)
                isFirst = false
            }
            myString = myString + "\"\n"
        }
        else {
            myString = myString + "(nil)\n"
        }
   
        return myString
    }

    func read() {
        
        print("* dateStart = \(dateStart?.description ?? "nil")")
        print("  * dateEnd = \(dateEnd?.description ?? "nil")")
        print("  * duration = \(duration)")
        print("  * notes = \(notes ?? "nil")")
        if let mySets = mySets as? Set<MySet> {
            for mySet in mySets {
                print("  * \(mySet.index)")
            }
        }
    }
    
}
