//
//  MuscleGroup.swift
//  WOApp
//
//  Created by rc on 01/08/2017.
//  Copyright © 2017 SISIOMO. All rights reserved.
//

import UIKit
import CoreData

class MuscleGroup: NSManagedObject {

    func convertToCsvString() -> String {
        
        return (name ?? "(nil") + "\n"
    }
    
    func read() {
        print("* name = \(name ?? "nil")")
    }

}
