//
//  Utils.swift
//  day
//
//  Created by Tony Dinh on 2016-11-04.
//  Copyright © 2016 Tony Dinh. All rights reserved.
//

import Foundation

class Utils {
    // Date Utilities
    struct date {
        private let currentCal = NSCalendar.current

        func startOfToday() -> Date {
            return currentCal.startOfDay(for: Date())
        }

        func endOfToday() -> Date {
            var components = DateComponents()
            components.day = 1
            components.second = -1
            return currentCal.date(byAdding: components, to: startOfToday())!
        }

        func dateString(from date: Date, with format: String) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format
            return dateFormatter.string(from: date)
        }
    }
}
