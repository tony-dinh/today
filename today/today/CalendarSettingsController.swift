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
        tableView.allowsSelection = false
        tableView.tintColor = Utils.color().UIColorFrom(hex: 0xCC6D65)
        tableView.register(
            CalendarCell.self,
            forCellReuseIdentifier: CalendarCell.constants.reuseIdentifier
        )

        navigationItem.rightBarButtonItem = editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard case eventManager.accessGranted = true else {
            return
        }

        calendarList.fetchAll()
        tableView.reloadData()
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
        let calendar = calendars[indexPath.row]
        let cell = CalendarCell(calendar: calendar)
        cell.calendarSelected = !eventManager.excluded(calendarIdentifer: calendar.calendarIdentifier)
        return cell
    }

    // MARK: UITableViewDelegate
    private func initiateEditting() {
        tableView.allowsSelection = true
    }

    private func completeEditing() {
        tableView.allowsSelection = false
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CalendarCell
        guard let calendar = cell.calendar else {
            return
        }

        cell.calendarSelected = !cell.calendarSelected
        if !cell.calendarSelected {
            tableView.deselectRow(at: indexPath, animated: true)
            eventManager.excludeCalendar(with: calendar.calendarIdentifier)
        } else {
            eventManager.includeCalendar(with: calendar.calendarIdentifier)
        }
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        editing ? initiateEditting() : completeEditing()
    }
}
