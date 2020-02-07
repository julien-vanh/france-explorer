//
//  Reminders.swift
//  TripList
//
//  Created by Julien Vanheule on 07/02/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import Foundation
import EventKit
import CoreData

class Reminders {
    static func copyDreams(dreams: [Dream]) -> Void {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .reminder) { (success, error) in
            if error != nil {
                print(error!)
            } else if success {
                
                let calendar = EKCalendar(for: .reminder, eventStore: eventStore)
                calendar.title = "TripList" //TODO changer le nom du calendrier
                calendar.source = eventStore.sources.first(where: {$0.sourceType == .local})
                
                do {
                    try eventStore.saveCalendar(calendar, commit: true)
                } catch{
                      print("Error creating and saving new reminder : \(error)")
                }
                
                dreams.forEach({ (dream) in
                    let reminder = EKReminder(eventStore: eventStore)
                    reminder.title = dream.title ?? ""
                    reminder.isCompleted = dream.completed
                    reminder.calendar = calendar
                    do {
                        try eventStore.save(reminder, commit: true)
                    } catch{
                        print("Error creating and saving new reminder : \(error)")
                    }
                })
                
                print("Reminders saved")
            }
        }
    }
}
