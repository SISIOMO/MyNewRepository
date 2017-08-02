//
//  Settings.swift
//  WOApp
//
//  Created by rc on 31/07/2017.
//  Copyright © 2017 SISIOMO. All rights reserved.
//

import UIKit


/////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Type definition

enum WeightUnit: Int {
    case kg = 0
    case lb = 1
}

/////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Keys to properties to be serialised

struct SettingsPropertyKey {
    static let myWeight     = "myWeight"
    static let weightUnit = "weightUnit"
}


/////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Class to be serialised

class Settings: NSObject, NSCoding {

    /////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Properties
    
    var myWeight: Double = 0.0
    var weightUnit: WeightUnit = WeightUnit.kg
    
    /////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Description
    
    override var description: String {
        return "(" + String(describing: myWeight) + "," + String(describing: weightUnit) + ")"
    }

    //////////////////////////////////////////////////////////////////////////////////
    // MARK: Class constants
    
    // Path file name of the saved settings.
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("WOApp")
    
    
    //////////////////////////////////////////////////////////////////////////////////
    // MARK: Designated initializers
    
    override init() {
        super.init()
    }
    
    init(weight: Double, weightUnit: WeightUnit) {
        self.myWeight   = weight
        self.weightUnit = weightUnit
    }

    /////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: NSCoding
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let newWeight = aDecoder.decodeDouble(forKey: SettingsPropertyKey.myWeight)
        let newWeightUnit = aDecoder.decodeInteger(forKey: SettingsPropertyKey.weightUnit)
        
        self.init(weight: newWeight, weightUnit: WeightUnit(rawValue: newWeightUnit) ?? WeightUnit.kg)
        
        print("INFO : Settings successfully decoded \(description)")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(myWeight,             forKey: SettingsPropertyKey.myWeight)
        aCoder.encode(weightUnit.rawValue,  forKey: SettingsPropertyKey.weightUnit)
        
        print("INFO : Settings encoded \(description)")
    }

}
