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
            let diameter = radius * 2
            frame.size = CGSize(width: diameter, height: diameter)
            setSizeConstraints(for: diameter)
        }
        get {
            return layer.cornerRadius
        }
    }
    private var sizeConstraints: [NSLayoutConstraint]?
    init(radius: CGFloat = 3.0, color: UIColor = UIColor.gray) {
        super.init(frame: .zero)
        self.radius = radius
        self.color = color
        translatesAutoresizingMaskIntoConstraints = false
    }

    private func setSizeConstraints(for diameter: CGFloat) {
        if let sizeConstraints = sizeConstraints {
            removeConstraints(sizeConstraints)
        }

        let heightConstraint = NSLayoutConstraint(
            item: self,
            attribute: .height,
            relatedBy: .equal, 
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: diameter
        )
        let widthConstraint = NSLayoutConstraint(
            item: self,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: diameter
        )

        sizeConstraints = [heightConstraint, widthConstraint]
        addConstraints(sizeConstraints!)
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
    private var calendarHighlight: Dot?

    convenience init(calendar: EKCalendar?) {
        self.init(style: .default, reuseIdentifier: constants.reuseIdentifier)

        guard let calendar = calendar else {
            return
        }
        selectionStyle = .none
        self.calendar = calendar
        self.calendarHighlight = Dot(radius: 4.0, color: UIColor(cgColor: calendar.cgColor))
        label = UILabel(frame: .zero)
        label?.text = calendar.title
        label?.textColor = UIColor.darkGray
        label?.translatesAutoresizingMaskIntoConstraints = false
        initLayout()
    }

    private func initLayout() {
        guard let label = label, let calendarHighlight = calendarHighlight else {
            return
        }
        addSubview(calendarHighlight)
        addSubview(label)
        let defaultLeadingMargin = CGFloat(12.0)
        let leadingMargin = calendarHighlight.radius + defaultLeadingMargin
        let views = ["calendarHighlight": calendarHighlight, "label": label]
        let constraintH = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-(\(leadingMargin))-[calendarHighlight]-(12)-[label]-|",
            options: [],
            metrics: nil,
            views: views
        )
        let constraintV = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[label]-|",
            options: [],
            metrics: nil,
            views: views
        )
        let calHighlightCenterConstraint = NSLayoutConstraint(
            item: calendarHighlight,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerY,
            multiplier: 1,
            constant: 0
        )
        addConstraint(calHighlightCenterConstraint)
        addConstraints(constraintH)
        addConstraints(constraintV)
    }
}
