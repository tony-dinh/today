//
//  Event.swift
//  day
//
//  Created by Tony Dinh on 2016-11-04.
//  Copyright © 2016 Tony Dinh. All rights reserved.
//

import Foundation
import EventKit

class Event {
    var calendar: EKCalendar
    var title: String
    var startDate: Date
    var endDate: Date
    var isAllDay: Bool
    var completed: Bool {
        get {
            return endDate <= Date()
        }
    }

    init(eventInfo: EKEvent) {
        startDate = eventInfo.startDate
        endDate = eventInfo.endDate
        isAllDay = eventInfo.isAllDay
        calendar = eventInfo.calendar
        title = eventInfo.title
    }
}

final class EventList {
    static let sharedInstance = EventList()
    let eventManager: EventManager
    var events: [Event]?

    private init() {
        eventManager = EventManager()
        if eventManager.accessGranted {
            events = eventManager.getTodaysEvents()
        } else {
            eventManager.requestAccess() { granted, error in
                if granted {
                    self.events = self.eventManager.getTodaysEvents()
                }
            }
        }
    }

    func fetchEvents() {
        events = eventManager.getTodaysEvents()
    }

    func eventsEndingBefore(date: Date) -> [Event] {
        if let events = events {
            return events.filter({$0.endDate <= date})
        }
        return [Event]()
    }

    func eventsEndingAfter(date: Date) -> [Event] {
        if let events = events {
            return events.filter({$0.endDate > date})
        }
        return [Event]()
    }
}
