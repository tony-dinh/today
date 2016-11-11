//
//  SettingsController.swift
//  today
//
//  Created by Tony Dinh on 2016-11-10.
//  Copyright © 2016 Tony Dinh. All rights reserved.
//

import Foundation
import UIKit

class SettingsController:
    BaseTableViewController,
    UITableViewDelegate,
    UITableViewDataSource
{
    let settings: [String] = ["Calendars"]
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            DefaultCell.self,
            forCellReuseIdentifier: DefaultCell.constants.reuseIdentifier
        )
    }

    // MARK: UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return DefaultCell(accessoryType: .disclosureIndicator, text: settings[indexPath.row])
    }

    // MARK: UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch settings[indexPath.row] {
        case "Calendars":
            let calendarSettingsController = CalendarSettingsController()
            navigationController?.pushViewController(calendarSettingsController, animated: true)
            break;
        default:
            break;
        }
    }
}
