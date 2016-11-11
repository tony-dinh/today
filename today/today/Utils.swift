//
//  Utils.swift
//  day
//
//  Created by Tony Dinh on 2016-11-04.
//  Copyright © 2016 Tony Dinh. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    // Mark: Color

    struct color {
        func UIColorFrom(hex: Int, alpha: Float = 1.0) -> UIColor {
            return UIColor.init(
                colorLiteralRed: Float((hex & 0xFF0000) >> 16)/255.0,
                green: Float((hex & 0x00FF00) >> 8)/255.0,
                blue: Float((hex & 0x0000FF) >> 0)/255.0,
                alpha: alpha
            )
        }
    }

    // MARK: Date

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
