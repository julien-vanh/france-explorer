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


public enum RemindersError: Error, LocalizedError {
    case accessDenied
    
    public var errorDescription: String? {
        switch self {
        case .accessDenied:
            return NSLocalizedString("L'application n'est pas autorisée à accéder aux Rappels", comment: "")
        }
    }
}

class Reminders {
    static func copyDreams(dreams: [Dream], completion: @escaping (Bool, Error?) -> ()) {
        
        let ud = UserDefaults.standard
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .reminder) { (success, err) in
            if let error = err {
                completion(false, error)
            } else if success {
                var calendar: EKCalendar
                if let identifier = ud.string(forKey: UserDefaultsKeys.reminderId.rawValue),
                   let existingCalendar = eventStore.calendar(withIdentifier: identifier) {
                    calendar = existingCalendar
                } else {
                    calendar = EKCalendar(for: .reminder, eventStore: eventStore)
                    calendar.title = "France Guide" //TODO changer le nom du calendrier
                    calendar.source = eventStore.sources.first(where: {$0.sourceType == .local}) ?? eventStore.sources.first
                }
                
                
                
                do {
                    try eventStore.saveCalendar(calendar, commit: true)
                    ud.set(calendar.calendarIdentifier, forKey: UserDefaultsKeys.reminderId.rawValue)
                    ud.synchronize()
                } catch {
                    completion(false, error)
                    return
                }
                
                
                let predicate = eventStore.predicateForReminders(in: [calendar])
                eventStore.fetchReminders(matching: predicate) { (reminders) in
                    if let existingReminders = reminders {
                        existingReminders.forEach { (reminder) in
                            do {
                                try eventStore.remove(reminder, commit: false)
                            } catch {
                                completion(false, error)
                            }
                        }
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { //Pour attendre la suppression
                    dreams.forEach({ (dream) in
                        
                        let reminder = EKReminder(eventStore: eventStore)
                        reminder.title = dream.title ?? ""
                        reminder.isCompleted = dream.completed
                        reminder.calendar = calendar
                        do {
                            try eventStore.save(reminder, commit: true)
                        } catch {
                            completion(false, error)
                        }
                    })
                    
                    //completion(true, nil)
                    print("Reminders saved")
                }
            } else {
                completion(false, RemindersError.accessDenied)
            }
        }
    }
}
