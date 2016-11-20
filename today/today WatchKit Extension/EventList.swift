//
//  EventList.swift
//  day
//
//  Created by Tony Dinh on 2016-11-04.
//  Copyright © 2016 Tony Dinh. All rights reserved.
//

import Foundation
import EventKit

final class EventList {
    let eventManager = EventManager.sharedInstance
    var events: [EKEvent]? {
        return eventManager.events
    }

    init() {
        if eventManager.accessGranted {
            eventManager.getTodaysEvents()
        } else {
            eventManager.requestAccess() { granted, error in
                if granted {
                    self.eventManager.getTodaysEvents()
                }
            }
        }
    }

    func reloadEvents(completion: ((Bool) -> Void)? = nil) {
        guard eventManager.accessGranted == true else {
            completion?(false)
            return
        }
        eventManager.getTodaysEvents()
        completion?(true)
    }

    func eventsEndingBefore(date: Date) -> [EKEvent] {
        guard let events = events else {
            return [EKEvent]()
        }
        return events.filter({$0.endDate <= date})
    }

    func eventsEndingAfter(date: Date) -> [EKEvent] {
        guard let events = events else {
            return [EKEvent]()
        }
        return events.filter({$0.endDate > date})
    }
}
