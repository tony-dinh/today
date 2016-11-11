//
//  BaseTableViewController.swift
//  today
//
//  Created by Tony Dinh on 2016-11-10.
//  Copyright © 2016 Tony Dinh. All rights reserved.
//

import Foundation
import UIKit

class BaseTableViewController: UIViewController {
    final var tableView = UITableView(frame: .zero, style: .grouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }

    private func setLayout() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        let views = ["tableView": tableView]
        let constraintH = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-(0)-[tableView]-(0)-|", options: [], metrics: nil, views: views)
        let constraintV = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[tableView]-|", options: [], metrics: nil, views: views)

        view.addConstraints(constraintH)
        view.addConstraints(constraintV)
    }
}
