//
//  CalendarCell.swift
//  today
//
//  Created by Tony Dinh on 2016-11-11.
//  Copyright © 2016 Tony Dinh. All rights reserved.
//

import Foundation
import UIKit
import EventKit

fileprivate class Dot: UIView {
    var color: UIColor {
        set(color) {
            backgroundColor = color
        }
        get {
            return backgroundColor!
        }
    }
    var radius: CGFloat {
        set(radius) {
            layer.cornerRadius = radius
        }
        get {
            return layer.cornerRadius
        }
    }

    init(radius: CGFloat = 3.0, color: UIColor = UIColor.gray) {
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: radius*2, height: radius*2))
        self.radius = radius
        self.color = color
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CalendarCell: UITableViewCell {
    struct constants {
        static let reuseIdentifier = "CalendarCell"
    }

    var label: UILabel?
    var calendar: EKCalendar?
    private var dot: Dot?

    convenience init(calendar: EKCalendar?) {
        self.init(style: .default, reuseIdentifier: constants.reuseIdentifier)

        guard let calendar = calendar else {
            return
        }

        self.calendar = calendar
        self.dot = Dot(radius: 4.0, color: UIColor(cgColor: calendar.cgColor))
        label = UILabel(frame: .zero)
        label?.text = calendar.title
        label?.textColor = UIColor.darkGray
        label?.translatesAutoresizingMaskIntoConstraints = false
        initLayout()
        
    }

    private func initLayout() {
        guard let label = label, let dot = dot else {
            return
        }
        addSubview(dot)
        addSubview(label)
        dot.center = CGPoint(x: 16.0, y: center.y)
        let views = ["dot": dot, "label": label]
        let constraintH = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[dot]-(12)-[label]-|", options: [], metrics: nil, views: views)
        let constraintV = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[label]-|", options: [], metrics: nil, views: views)

        addConstraints(constraintH)
        addConstraints(constraintV)
    }
}
