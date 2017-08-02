//
//  MyViewController.swift
//  WOApp
//
//  Created by rc on 26/07/2017.
//  Copyright © 2017 SISIOMO. All rights reserved.
//

import UIKit

class MyViewController: UIViewController {
    
    //////////////////////////////////////////////////////////////////////////////////
    // MARK: -Outlets
    
    @IBOutlet weak var labelNbWorkouts: UILabel!
    @IBOutlet weak var labelNbWorkoutsYear: UILabel!
    @IBOutlet weak var labelNbWorkoutsMonth: UILabel!
    @IBOutlet weak var labelNbWorkoutsWeek: UILabel!
    @IBOutlet weak var buttonWorkout: UIButton!
    
    //////////////////////////////////////////////////////////////////////////////////
    // MARK: -Properties
    
    private var currentWorkout: Workout?
    private var settings = Settings()
    private var databaseManager = MyDatabaseManager()

    //////////////////////////////////////////////////////////////////////////////////
    // MARK: -Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateLabels()
        updateWorkoutButton()
    }
    
    //////////////////////////////////////////////////////////////////////////////////
    // MARK: -Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        super.prepare(for: segue, sender: sender)
        
        if let segueID = segue.identifier {
            switch segueID {
            case "workout":
                if let destination = segue.destination as? WOViewController {
                    if currentWorkout == nil {
                        currentWorkout = databaseManager.createWorkout()
                    }
                    
                    destination.currentWorkout = currentWorkout
                    destination.databaseManager = databaseManager
                }
            case "settings":
                if let destination = segue.destination as? UINavigationController {
                    if let settingController = destination.topViewController as? SettingsViewController {
                        settingController.settings = settings
                    }
                }
            default:
                // We crash the application if the segue is not identified
                fatalError("Unknown segue in MyViewController.prepare (\(segueID))")
            }
        }
        else {
            fatalError("Empty segue in MyViewController.prepare")
        }
    }

    @IBAction func unwindFinishWorkout(sender: UIStoryboardSegue) {
        databaseManager.saveDatabase()

        // Set the current workout to nil to be able to create a new one.
        currentWorkout = nil
    }

    @IBAction func unwindDoneSettings(sender: UIStoryboardSegue) {
        saveSettings()
    }
    
    //////////////////////////////////////////////////////////////////////////////////
    // MARK: -Private methods
    
    private func updateLabels() {

        labelNbWorkouts.text        = String(databaseManager.getNumberOfWorkouts())
        labelNbWorkoutsYear.text    = String(databaseManager.getNumberOfWorkoutsYear())
        labelNbWorkoutsMonth.text   = String(databaseManager.getNumberOfWorkoutsMonth())
        labelNbWorkoutsWeek.text    = String(databaseManager.getNumberOfWorkoutsWeek())
    }
    
    private func updateWorkoutButton() {
        buttonWorkout.setTitle((currentWorkout == nil ? "Start Workout" : "Current Workout"), for: .normal)
    }
    
    //////////////////////////////////////////////////////////////////////////////////
    // MARK: - Load/save settings
    
    private func loadSettings() {
        if let newSettings = NSKeyedUnarchiver.unarchiveObject(withFile: Settings.ArchiveURL.path) as? Settings {
            print("INFO : Settings successfully loaded.")
            settings = newSettings
        }
        else {
            print("INFO: Settings could not be loaded, so they were created.")
            saveSettings()
        }
    }
    
    private func saveSettings() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if self != nil {
                if NSKeyedArchiver.archiveRootObject(self!.settings, toFile: Settings.ArchiveURL.path) {
                    print("INFO : Settings successfully saved.")
                } else {
                    print("ERROR: Settings could not be saved!")
                }
            }
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////
    // MARK: -Press buttons

    @IBAction func pressLoad(_ sender: UIButton) {
        databaseManager.loadDatabase()
    }
    
    @IBAction func pressRead(_ sender: UIButton) {
        databaseManager.readDatabase()
    }
    
    @IBAction func pressSave(_ sender: UIButton) {
        databaseManager.saveDatabase()
    }
    
    @IBAction func pressReset(_ sender: UIButton) {
        databaseManager.resetExercises()
        databaseManager.resetMuscles()
        databaseManager.resetMuscleGroups()
    }
    
    @IBAction func pressResetWorkouts(_ sender: UIButton) {
        databaseManager.resetMySets()
        databaseManager.resetWorkouts()
    }
    
    @IBAction func pressExport(_ sender: UIButton) {
        databaseManager.exportMuscleGroupsToFile()
        databaseManager.exportMusclesToFile()
        databaseManager.exportExercisesToFile()
        databaseManager.exportMySetsToFile()
        databaseManager.exportWorkoutsToFile()
    }
    
}

