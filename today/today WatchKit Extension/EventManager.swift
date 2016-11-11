//
//  EventManager.swift
//  day
//
//  Created by Tony Dinh on 2016-11-04.
//  Copyright © 2016 Tony Dinh. All rights reserved.
//

import Foundation
import EventKit

class EventManager: NSObject {
    let eventStore: EKEventStore
    var accessGranted: Bool = false

    override init() {
        eventStore = EKEventStore()
        super.init()

        if EKEventStore.authorizationStatus(for: .event) == .authorized {
            accessGranted = true
        }
    }

    func requestAccess(completion: @escaping ((Bool, Error?) -> Void) = {granted, error in}) {
        eventStore.requestAccess(to: .event, completion: { granted, error in
            self.accessGranted = granted
            if let error = error {
                print(error.localizedDescription)
                completion(granted, error)
                return
            }
            completion(granted, error)
        })
    }

    func getEventCalendars() -> [EKCalendar] {
        return eventStore.calendars(for: .event)
    }

    private func ascendingOrder(first a: Event, second b: Event) -> Bool {
        let aStartDate = a.startDate
        let bStartDate = b.startDate
        let aEndDate = a.endDate
        let bEndDate = b.endDate

        if aStartDate < bStartDate {
            return true
        } else if aStartDate > bStartDate {
            return false
        } else {
            if aEndDate <= bEndDate {
                return true
            } else {
                return false
            }
        }
    }

    private func priorityOrder(first a: Event, second b: Event) -> Bool {
        let aCompleted = a.completed
        let bCompleted = b.completed

        if !aCompleted && !bCompleted || aCompleted && bCompleted {
            return ascendingOrder(first: a, second: b)
        } else {
            if !aCompleted && bCompleted {
                return true
            } else {
                return false
            }
        }
    }

    func getTodaysEvents() -> [Event] {
        var result = [Event]()
        let dateUtils = Utils.date()
        let todaysEventsPredicate = eventStore.predicateForEvents(
            withStart: dateUtils.startOfToday(),
            end: dateUtils.endOfToday(),
            calendars: getEventCalendars())

        let events = eventStore.events(matching: todaysEventsPredicate)
        for event in events {
            result.append(Event(eventInfo: event))
        }

        return result.sorted(by: priorityOrder)
    }
}
