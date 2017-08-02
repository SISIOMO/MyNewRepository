//
//  Muscle.swift
//  WOApp
//
//  Created by rc on 26/07/2017.
//  Copyright © 2017 SISIOMO. All rights reserved.
//

import UIKit
import CoreData

class Muscle: NSManagedObject {
    
    func convertToCsvString() -> String {
        
        return (name ?? "(nil)") + "," + (muscleGroup?.name ?? "(nil)") + "\n"
    }
    
    func read() {
        print("* name = \(name ?? "nil")")
        print("  * muscle group = \(muscleGroup?.name ?? "nil")")
    }

}
