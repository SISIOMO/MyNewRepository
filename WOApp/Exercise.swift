//
//  Exercise.swift
//  WOApp
//
//  Created by rc on 26/07/2017.
//  Copyright © 2017 SISIOMO. All rights reserved.
//

import UIKit
import CoreData

class Exercise: NSManagedObject {

    func convertToCsvString() -> String {
        
        var myString = (name ?? "(nil)")
        
        myString = myString + "," + String(isOneSide)
        myString = myString + "," + String(isBodyWeight)
        myString = myString + "," + (primaryMuscle?.name ?? "(nil)") + ","
        
        if let secondaryMuscles = secondaryMuscles as? Set<Muscle> {
            var isFirst = true
            for muscle in secondaryMuscles {
                myString = myString + (isFirst ? "\"" : ",") + (muscle.name ?? "(nil)")
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
        
        print("* name = \(name ?? "nil")")
        print("  * isOneSide = \(isOneSide)")
        print("  * isBodyWeight = \(isBodyWeight)")
        print("  * P \(primaryMuscle?.name ?? "nil")")
        
        if let secondaryMuscles = secondaryMuscles as? Set<Muscle> {
            for muscle in secondaryMuscles {
                print("  * S \(muscle.name ?? "nil")")
            }
        }
    }
    
}
