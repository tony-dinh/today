//
//  CalendarSettingsController.swift
//  today
//
//  Created by Tony Dinh on 2016-11-10.
//  Copyright © 2016 Tony Dinh. All rights reserved.
//

import Foundation
import EventKit
import UIKit

class CalendarSettingsController:
    BaseTableViewController,
    UITableViewDelegate,
    UITableViewDataSource
{
    let eventManager = EventList.sharedInstance.eventManager
    var calendars = [String: [EKCalendar]]()
    var calendarSources: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Calendars"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            DefaultCell.self,
            forCellReuseIdentifier: DefaultCell.constants.reuseIdentifier
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard case eventManager.accessGranted = true else {
            return
        }
        let allCalendars = eventManager.getEventCalendars()
        calendarSources = calendarSources(from: allCalendars)

        if let calendarSources = calendarSources {
            for source in calendarSources {
                let calendar = calendarFor(source: source, from: allCalendars)
                calendars.updateValue(calendar, forKey: source)
            }
        }
    }

    // MARK: Calendar Methods
    private func calendarFor(source: String, from calendars: [EKCalendar]) -> [EKCalendar] {
        return calendars.filter({$0.source.title == source})
    }

    private func calendarSources(from calendars:[EKCalendar]) -> [String]? {
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

    // MARK: UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        guard calendarSources != nil else {
            return 1
        }
        return calendarSources!.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return calendarSources?[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let calendarSources = calendarSources {
            let source = calendarSources[section]
            if let calendar = calendars[source] {
                return calendar.count
            }
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let calendarSources = calendarSources {
            let source = calendarSources[indexPath.section]
            if let calendar = calendars[source] {
                return DefaultCell(accessoryType: .none, text: calendar[indexPath.row].title)
            }
        }
        return DefaultCell()
    }

}
