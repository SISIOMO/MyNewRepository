//
//  MyDatabaseManager.swift
//  WOApp
//
//  Created by rc on 01/08/2017.
//  Copyright © 2017 SISIOMO. All rights reserved.
//

import UIKit
import CoreData

class MyDatabaseManager {
    
    //////////////////////////////////////////////////////////////////////////////////
    // MARK: -Constants
    
    private let muscleGroups = [
        "Shoulders",
        "Chest",
        "Arms",
        "Back",
        "Abdominals",
        "Legs"
    ]
    
    private let muscles = [
        ("Shoulders",       "Shoulders"),
        
        ("Chest",           "Chest"),
        
        ("Biceps",          "Arms"),
        ("Triceps",         "Arms"),
        ("Forearms",        "Arms"),
        
        ("Neck",            "Back"),
        ("Trapezius",       "Back"),
        ("Lats",            "Back"),
        ("Middle back",     "Back"),
        ("Lower back",      "Back"),
        ("Core",            "Back"),
        
        ("Abdominals",      "Abdominals"),
        
        ("Glutes",          "Legs"),
        ("Hip abductors",   "Legs"),
        ("Quadriceps",      "Legs"),
        ("Hamstrings",      "Legs"),
        ("Calves",          "Legs")
    ]
    
    private let exercises: [(String, Bool, Bool, String, [String])] = [
        // name         isOneSide   isBodyWeight    primary muscle  secondary muscles
        ("Push Ups",    false,      true,           "Chest",        ["Triceps"]),
        ("Crunches",    false,      true,           "Abdominals",   []),
        ("Bench Press", false,      false,          "Chest",        ["Triceps","Shoulders"]),
        ("Air Bike",    false,      true,           "Abdominals",   [])
    ]
    
    //////////////////////////////////////////////////////////////////////////////////
    // MARK: -Initializer

    init() {
        
    }
    
    //////////////////////////////////////////////////////////////////////////////////
    // MARK: Get number of workouts

    func getNumberOfWorkouts() -> Int {
        let context = AppDelegate.viewContext
        
        let request: NSFetchRequest<Workout> = Workout.fetchRequest()
            
        if let workouts = try? context.fetch(request) {
            return workouts.count
        }
        
        return -1
    }

    func getNumberOfWorkoutsYear() -> Int {

        let today = Date()

        // Get today's year.
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        var todayComponent = calendar.dateComponents([.year], from: today)
        guard todayComponent.year != nil else {
            fatalError("Can't get today's components!")
        }

        // Set this year's beginning date.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-mm-dd"
        dateFormatter.calendar = NSCalendar.current
        
        let yearStartDate = dateFormatter.date(from: "\(todayComponent.year!)-01-01")
        
        guard yearStartDate != nil else {
            fatalError("Cannot format this year's start date!")
        }
        
        return getNumberOfWorkouts(fromDate: calendar.startOfDay(for: yearStartDate!))
    }

    func getNumberOfWorkoutsMonth() -> Int {
        
        let today = Date()

        // Get today's year and month.
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        var todayComponent = calendar.dateComponents([.year, .month], from: today)
        guard todayComponent.year != nil && todayComponent.month != nil else {
            fatalError("Can't get today's components!")
        }
        
        // Set this month's beginning date.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-mm-dd"
        dateFormatter.calendar = NSCalendar.current
        
        let monthStartDate = dateFormatter.date(from: "\(todayComponent.year!)-\(todayComponent.month!)-01")
        
        guard monthStartDate != nil else {
            fatalError("Cannot format this month's start date!")
        }
        
        return getNumberOfWorkouts(fromDate: calendar.startOfDay(for: monthStartDate!))
    }

    func getNumberOfWorkoutsWeek() -> Int {
        
        let today = Date()
        
        // Get today's year, month and day.
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        var todayComponent = calendar.dateComponents([.year, .month, .day, .weekday], from: today)
        guard todayComponent.year != nil else {
            fatalError("Can't get today's components!")
        }
        
        // Set this week's beginning date.
        let nbDaysDifference = abs(todayComponent.weekday! - calendar.firstWeekday)
        let weekStartDate = today.addingTimeInterval(-3600.0 * 24.0 * Double(nbDaysDifference))
        
        return getNumberOfWorkouts(fromDate: calendar.startOfDay(for: weekStartDate))
    }
    
    func getNumberOfWorkouts(fromDate: Date) -> Int {
        let context = AppDelegate.viewContext
        
        let request: NSFetchRequest<Workout> = Workout.fetchRequest()
        
        request.predicate = NSPredicate(format: "dateStart >= %@", argumentArray: [fromDate])
        
        if let workouts = try? context.fetch(request) {
            return workouts.count
        }
        
        return -1
    }

    func getNumberOfWorkouts(fromDate: Date, toDate: Date) -> Int {
        
        let context = AppDelegate.viewContext
        
        let request: NSFetchRequest<Workout> = Workout.fetchRequest()
        
        request.predicate = NSPredicate(format: "(%@ <= dateStart) AND (dateStart < %@)", argumentArray: [fromDate, toDate])
        
        if let workouts = try? context.fetch(request) {
            return workouts.count
        }
        
        return -1
    }
    
    func createWorkout() -> Workout {
        let context = AppDelegate.viewContext

        return Workout(context: context)
    }
    
    func createMySet() -> MySet {
        let context = AppDelegate.viewContext
        
        return MySet(context: context)
    }
    
    //////////////////////////////////////////////////////////////////////////////////
    // MARK: Save/load the database.

    func getMuscleGroup(name: String) -> MuscleGroup? {

        let context = AppDelegate.viewContext
        
        let request: NSFetchRequest<MuscleGroup> = MuscleGroup.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", name)
        
        if let muscleGroups = try? context.fetch(request) {
            if muscleGroups.count == 1 {
                return muscleGroups[0]
            }
        }

        return nil
    }

    func createMuscleGroup(name: String) -> MuscleGroup {

        if let muscleGroup = getMuscleGroup(name: name) {
            return muscleGroup
        }
        
        let context = AppDelegate.viewContext

        let muscleGroup = MuscleGroup(context: context)
        muscleGroup.name = name
        
        return muscleGroup
    }

    func getMuscle(name: String) -> Muscle? {

        let context = AppDelegate.viewContext
        
        let request: NSFetchRequest<Muscle> = Muscle.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", name)
        
        if let muscles = try? context.fetch(request) {
            if muscles.count == 1 {
                return muscles[0]
            }
        }
        
        return nil
    }
    
    func createMuscle(name: String, muscleGroupName: String) -> Muscle {
        
        let muscleGroup = getMuscleGroup(name: muscleGroupName)
        
        if let muscle = getMuscle(name: name) {
            muscle.muscleGroup = muscleGroup
            
            return muscle
        }
        
        let context = AppDelegate.viewContext
        
        let muscle = Muscle(context: context)
        muscle.name = name
        muscle.muscleGroup = muscleGroup
        
        return muscle
    }
    
    func getExercise(name: String) -> Exercise? {

        let context = AppDelegate.viewContext
        
        let request: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", name)
        
        if let exercises = try? context.fetch(request) {
            if exercises.count == 1 {
                return exercises[0]
            }
        }
        
        return nil
    }
    
    func createExercise(name: String, isOneSide: Bool, isBodyWeight: Bool, primaryMuscleName: String, secondaryMuscleNames: [String]?) -> Exercise {
        
        var exercise = getExercise(name: name)
        
        if exercise == nil {
            let context = AppDelegate.viewContext
            exercise = Exercise(context: context)
            exercise?.name = name
        }
        
        exercise!.isOneSide = isOneSide
        exercise!.isBodyWeight = isBodyWeight
        exercise!.primaryMuscle = getMuscle(name: primaryMuscleName)
            
        if secondaryMuscleNames != nil {
            for muscleName in secondaryMuscleNames! {
                if let muscle = getMuscle(name: muscleName) {
                    muscle.addToSecondaryExercises(exercise!)
                }
            }
        }

        return exercise!
    }

    func loadDatabase() {

        // Muscle groups.
        for muscleGroupName in muscleGroups {
            _ = createMuscleGroup(name: muscleGroupName)
        }
        
        // Muscles.
        for (muscleName, muscleGroupName) in muscles {
            _ = createMuscle(name: muscleName, muscleGroupName: muscleGroupName)
        }
        
        // Exercises.
        for (name, isOneSide, isBodyWeight, primaryMusclesName, secondaryMuscleNames) in exercises {
            _ = createExercise(name: name, isOneSide: isOneSide, isBodyWeight: isBodyWeight, primaryMuscleName: primaryMusclesName, secondaryMuscleNames: secondaryMuscleNames)
        }
    }
    
    func readDatabase() {
        
        let context = AppDelegate.viewContext
        
        // Fetch muscle groups.
        let request1: NSFetchRequest<MuscleGroup> = MuscleGroup.fetchRequest()
        request1.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        if let muscleGroups = try? context.fetch(request1) {
            print("\n\(muscleGroups.count) muscle group(s) fetched:")
            for muscleGroup in muscleGroups {
                muscleGroup.read()
            }
        }
        else { print("Cannot fetch Muscle Groups!") }
        
        // Fetch muscles.
        let request2: NSFetchRequest<Muscle> = Muscle.fetchRequest()
        request2.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        if let muscles = try? context.fetch(request2) {
            print("\n\(muscles.count) muscle(s) fetched:")
            for muscle in muscles {
                muscle.read()
            }
        }
        else { print("Cannot fetch Muscles!") }
        
        // Fetch exercises.
        let request3: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        request3.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        if let exercises = try? context.fetch(request3) {
            print("\n\(exercises.count) exercise(s) fetched:")
            for exercise in exercises {
                exercise.read()
            }
        }
        else { print("Cannot fetch Exercises!") }
        
        // Fetch mySets
        let request4: NSFetchRequest<MySet> = MySet.fetchRequest()
        request4.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
        
        if let mySets = try? context.fetch(request4) {
            print("\n\(mySets.count) set(s) fetched:")
            for mySet in mySets {
                mySet.read()
            }
        }
        else { print("Cannot fetch MySets!") }
        
        // Fetch workouts.
        let request5: NSFetchRequest<Workout> = Workout.fetchRequest()
        request5.sortDescriptors = [NSSortDescriptor(key: "dateStart", ascending: true)]
        
        if let workouts = try? context.fetch(request5) {
            print("\n\(workouts.count) workout(s) fetched:")
            for workout in workouts {
                workout.read()
            }
        }
        else { print("Cannot fetch Workouts!") }
    }

    //////////////////////////////////////////////////////////////////////////////////
    // MARK: Export the database.

    func convertMuscleGroupsToCsvString() -> String {
        
        var myString = "name\n"

        let context = AppDelegate.viewContext

        let request: NSFetchRequest<MuscleGroup> = MuscleGroup.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        if let muscleGroups = try? context.fetch(request) {
            for muscleGroup in muscleGroups {
                myString = myString + muscleGroup.convertToCsvString()
            }
        }
        else {
            print("Cannot fetch Muscle Groups!")
        }

        return myString
    }

    func exportMuscleGroupsToFile() {
        exportStringToFile(contentToWrite: convertMuscleGroupsToCsvString(), path: "/Users/rc/Downloads/WOApp-muscleGroups.csv")
    }

    func convertMusclesToCsvString() -> String {
        
        var myString = "name,muscleGroup\n"
        
        let context = AppDelegate.viewContext

        let request: NSFetchRequest<Muscle> = Muscle.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "muscleGroup.name", ascending: true), NSSortDescriptor(key: "name", ascending: true)]
        
        if let muscles = try? context.fetch(request) {
            for muscle in muscles {
                myString = myString + muscle.convertToCsvString()
            }
        }
        else {
            print("Cannot fetch Muscles!")
        }

        return myString
    }

    func exportMusclesToFile() {
        exportStringToFile(contentToWrite: convertMusclesToCsvString(), path: "/Users/rc/Downloads/WOApp-muscles.csv")
    }

    func convertExercisesToCsvString() -> String {
        
        var myString = "name,isOneSide,isBodyWeight,primaryMuscle,secondaryMuscles\n"

        let context = AppDelegate.viewContext

        let request: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        if let exercises = try? context.fetch(request) {
            for exercise in exercises {
                myString = myString + exercise.convertToCsvString()
            }
        }
        else {
            print("Cannot fetch Exercises!")
        }

        return myString
    }

    func exportExercisesToFile() {
        exportStringToFile(contentToWrite: convertExercisesToCsvString(), path: "/Users/rc/Downloads/WOApp-exercises.csv")
    }

    func convertMySetsToCsvString() -> String {
        
        var myString = "index,reps,weight,exercise,workout\n"
        
        let context = AppDelegate.viewContext
        
        let request: NSFetchRequest<MySet> = MySet.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
        
        if let mySets = try? context.fetch(request) {
            for mySet in mySets {
                myString = myString + mySet.convertToCsvString()
            }
        }
        else {
            print("Cannot fetch MySets!")
        }
        
        return myString
    }
    
    func exportMySetsToFile() {
        exportStringToFile(contentToWrite: convertMySetsToCsvString(), path: "/Users/rc/Downloads/WOApp-mySets.csv")
    }

    func convertWorkoutsToCsvString() -> String {
        
        var myString = "dateStart,dateEnd,duration,notes,mySets\n"
        
        let context = AppDelegate.viewContext
        
        let request: NSFetchRequest<Workout> = Workout.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dateStart", ascending: true)]
        
        if let workouts = try? context.fetch(request) {
            for workout in workouts {
                myString = myString + workout.convertToCsvString()
            }
        }
        else {
            print("Cannot fetch Muscles!")
        }
        
        return myString
    }
    
    func exportWorkoutsToFile() {
        exportStringToFile(contentToWrite: convertWorkoutsToCsvString(), path: "/Users/rc/Downloads/WOApp-workouts.csv")
    }
    
    func exportStringToFile(contentToWrite: String, path: String) {
        do {
            try contentToWrite.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
        }
        catch {
            print("Cannot write to file \(path)! \(errno)")
        }
    }

    //////////////////////////////////////////////////////////////////////////////////
    // MARK: Reset the database.

    func resetMuscleGroups() {
        
        let context = AppDelegate.viewContext
        
        let request: NSFetchRequest<MuscleGroup> = MuscleGroup.fetchRequest()
        
        if let muscleGroups = try? context.fetch(request) {
            for muscleGroup in muscleGroups {
                context.delete(muscleGroup)
            }
        }
        else {
            print("resetMuscleGroups: cannot fetch request!")
        }
    }
    
    func resetMuscles() {
        
        let context = AppDelegate.viewContext

        let request: NSFetchRequest<Muscle> = Muscle.fetchRequest()
        
        if let muscles = try? context.fetch(request) {
            for muscle in muscles {
                context.delete(muscle)
            }
        }
        else {
            print("resetMuscles: cannot fetch request!")
        }
    }
    
    func resetExercises() {

        let context = AppDelegate.viewContext
        
        let request: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        
        if let exercises = try? context.fetch(request) {
            for exercise in exercises {
                context.delete(exercise)
            }
        }
        else {
            print("resetExercises: cannot fetch request!")
        }
    }
    
    func resetMySets() {

        let context = AppDelegate.viewContext
        
        let request: NSFetchRequest<MySet> = MySet.fetchRequest()
        
        if let mySets = try? context.fetch(request) {
            for mySet in mySets {
                context.delete(mySet)
            }
        }
        else {
            print("resetMySets: cannot fetch request!")
        }
    }
    
    func resetWorkouts() {
        
        let context = AppDelegate.viewContext
        
        let request: NSFetchRequest<Workout> = Workout.fetchRequest()
        
        if let workouts = try? context.fetch(request) {
            for workout in workouts {
                context.delete(workout)
            }
        }
        else {
            print("resetWorkouts: cannot fetch request!")
        }
    }
    
    func saveDatabase() {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
}
