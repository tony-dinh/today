//
//  DefaultCell.swift
//  today
//
//  Created by Tony Dinh on 2016-11-10.
//  Copyright © 2016 Tony Dinh. All rights reserved.
//

import Foundation
import UIKit

class DefaultCell: UITableViewCell {
    struct constants {
        static let reuseIdentifier = "DefaultCell"
    }

    var label: UILabel?
    convenience init(accessoryType: UITableViewCellAccessoryType = .none, text: String?) {
        self.init(style: .default, reuseIdentifier: constants.reuseIdentifier)
        self.accessoryType = accessoryType
        label = UILabel(frame: .zero)
        label?.text = text
        label?.textColor = UIColor.darkGray
        label?.translatesAutoresizingMaskIntoConstraints = false
        initLayout()
    }

    private func initLayout() {
        guard let label = label else {
            return
        }

        addSubview(label)
        let constraintH = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[label]-|", options: [], metrics: nil, views: ["label": label])
        let constraintV = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[label]-|", options: [], metrics: nil, views: ["label": label])

        addConstraints(constraintH)
        addConstraints(constraintV)
    }
}
