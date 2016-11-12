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
    let eventManager = EventManager.sharedInstance
    let calendarList = CalendarList()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Calendars"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            CalendarCell.self,
            forCellReuseIdentifier: CalendarCell.constants.reuseIdentifier
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard case eventManager.accessGranted = true else {
            return
        }

        calendarList.fetchAll()
    }

    // MARK: UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let calendarSources = calendarList.calendarSources else {
            return 0
        }
        return calendarSources.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return calendarList.calendarSources?[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let calendarSources = calendarList.calendarSources,
            let calendarsBySource = calendarList.calendarsBySource else {
            return 0
        }

        let source = calendarSources[section]
        guard let calendars = calendarsBySource[source] else {
            return 0
        }

        return calendars.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let calendarSources = calendarList.calendarSources,
            let calendarsBySource = calendarList.calendarsBySource else {
            return CalendarCell()
        }

        let source = calendarSources[indexPath.section]
        guard let calendars = calendarsBySource[source] else {
            return CalendarCell()
        }
        return CalendarCell(calendar: calendars[indexPath.row])
    }

    // MARK: UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
