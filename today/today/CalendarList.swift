//
//  CalendarList.swift
//  today
//
//  Created by Tony Dinh on 2016-11-11.
//  Copyright © 2016 Tony Dinh. All rights reserved.
//

import Foundation
import EventKit

final class CalendarList {
    let eventManager = EventManager.sharedInstance
    var calendarSources: [String]? = nil
    var calendarsBySource: [String: [EKCalendar]]? = nil
    var calendars: [EKCalendar]? {
        get {
            return eventManager.calendars
        }
    }

    init() {
        if eventManager.accessGranted {
            fetchAll()
        } else {
            eventManager.requestAccess() { granted, error in
                if granted {
                    self.fetchAll()
                }
            }
        }
    }

    private func fetchCalendars(for sources: [String], from calendars: [EKCalendar]) -> [String: [EKCalendar]] {
            var result = [String: [EKCalendar]]()
            for source in sources {
                let calendars = calendarsFor(source: source, from: calendars)
                result.updateValue(calendars, forKey: source)
            }
        return result
    }

    private func fetchSources(from calendars:[EKCalendar]) -> [String]? {
        var sourceSet = Set<String>()
        for calendar in calendars {
            let source = calendar.source.title
            let containsSource = sourceSet.contains(source)
            if !containsSource {
                sourceSet.insert(source)
            }
        }
        if sourceSet.count > 0 {
            var sources: [String]? = [String]()
            sources?.append(contentsOf: sourceSet)
            return sources?.sorted(by: displayOrder)
        }
        return nil
    }

    private func displayOrder(first a: String, second b: String) -> Bool {
        switch a {
        case "CalDAV":
            return true
        case "Other":
            return false
        default:
            return a < b
        }
    }

    func fetchAll() {
        eventManager.getEventCalendars()

        guard let calendars = calendars else {
            return
        }

        calendarSources = fetchSources(from: calendars)
        if let calendarSources = calendarSources {
            calendarsBySource = fetchCalendars(for: calendarSources, from: calendars)
        }
    }

    func calendarsFor(source: String, from calendars: [EKCalendar]) -> [EKCalendar] {
        return calendars.filter({$0.source.title == source}).sorted(by: {$0.title < $1.title})
    }
}
