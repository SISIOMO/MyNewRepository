//
//  WOViewController.swift
//  WOApp
//
//  Created by rc on 31/07/2017.
//  Copyright © 2017 SISIOMO. All rights reserved.
//

import UIKit
import CoreData

class WOViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var labelStartDate: UILabel!
    @IBOutlet weak var textNote: UITextView!
    @IBOutlet weak var buttonFinish: UIButton!
    
    weak var currentWorkout: Workout!
    weak var databaseManager: MyDatabaseManager!
    
    //////////////////////////////////////////////////////////////////////////////////
    // MARK: -UITextViewDelegate

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    //////////////////////////////////////////////////////////////////////////////////
    // MARK: -Override

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textNote.delegate = self
        
        if currentWorkout.dateStart == nil {
            currentWorkout.dateStart = Date() as NSDate
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy H:mm:ss"
        
        labelStartDate.text = dateFormatter.string(from: currentWorkout.dateStart! as Date)
    }
    
    //////////////////////////////////////////////////////////////////////////////////
    // MARK: -Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIButton, button == buttonFinish else {
            print("The Finish button was not pressed, cancelling")
            return
        }
        
        currentWorkout.dateEnd = Date() as NSDate
        currentWorkout.notes = textNote.text
        currentWorkout.duration = (currentWorkout.dateEnd?.timeIntervalSince(currentWorkout.dateStart! as Date))!
    }
    
    //////////////////////////////////////////////////////////////////////////////////
    // MARK: -Press buttons

    @IBAction func pressAddSet(_ sender: UIButton) {
        
        let mySet = databaseManager.createMySet()
        
        MySet.count += 1
        mySet.index = MySet.count
        mySet.reps = Int16(5 * mySet.index)
        mySet.weight = 10.0 * Double(mySet.index)
        mySet.exercise = databaseManager.getExercise(name: "Bench Press")
        
        currentWorkout.addToMySets(mySet)
    }
    
    @IBAction func pressNote(_ sender: UIButton) {
        
        textNote.isHidden = !textNote.isHidden
        
        if textNote.isHidden {
            textNote.resignFirstResponder()
        }
    }
}
