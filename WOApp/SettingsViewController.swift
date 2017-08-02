//
//  SettingsViewController.swift
//  WOApp
//
//  Created by rc on 31/07/2017.
//  Copyright © 2017 SISIOMO. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    //////////////////////////////////////////////////////////////////////////////////
    // MARK: Outlets
    
    @IBOutlet weak var buttonDone: UIBarButtonItem!
    @IBOutlet weak var controlWeightUnit: UISegmentedControl!
    @IBOutlet weak var textWeight: UITextField!

    //////////////////////////////////////////////////////////////////////////////////
    // MARK: Properties

    var settings: Settings?

    //////////////////////////////////////////////////////////////////////////////////
    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard settings != nil else {
            fatalError("Settings are nil!")
        }
        
        textWeight.text = String(settings!.myWeight)
        controlWeightUnit.selectedSegmentIndex = settings!.weightUnit.rawValue
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard settings != nil else {
            fatalError("Settings are nil!")
        }

        guard let button = sender as? UIBarButtonItem, button == buttonDone else {
            print("The Done button was not pressed, cancelling")
            return
        }
        
        settings!.myWeight = Double(textWeight.text ?? "0.0") ?? 0.0
        settings!.weightUnit = WeightUnit(rawValue: controlWeightUnit.selectedSegmentIndex) ?? .kg
    }
    
}
