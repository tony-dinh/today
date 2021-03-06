//
//  InterfaceController.swift
//  day WatchKit Extension
//
//  Created by Tony Dinh on 2016-11-03.
//  Copyright © 2016 Tony Dinh. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
    @IBOutlet var table: WKInterfaceTable!
    let complicationServer = CLKComplicationServer.sharedInstance()
    let dateUtils = Utils.date()
    let eventList = EventList()

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        super.willActivate()
        eventList.reloadEvents()
        loadTable()
        if let activeComplications = complicationServer.activeComplications {
            for complication in activeComplications {
                complicationServer.reloadTimeline(for: complication)
            }
        }
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }

    // MARK - Table

    func loadTable() {
        guard EventManager.sharedInstance.accessGranted == true else {
            table.setNumberOfRows(1, withRowType: "EventRow")
            if let row = table.rowController(at: 0) as? EventRow {
                row.eventLabel.setText("Requires Calendar Access")
                row.startDateLabel.setText("NOTICE")
                row.endDateLabel.setText("Continue on Phone")
            }
            return
        }

        guard let events = eventList.events, events.count > 0 else {
            table.setNumberOfRows(1, withRowType: "EventRow")
            if let row = table.rowController(at: 0) as? EventRow {
                row.eventLabel.setText("Nothing Scheduled")
                row.startDateLabel.setText("ALL DAY")
                row.endDateLabel.setText(nil)
            }
            return
        }

        table.setNumberOfRows(events.count, withRowType: "EventRow")
        for (index, event) in events.enumerated() {
            if let row = table.rowController(at: index) as? EventRow {
                let eventStartTime = event.isAllDay
                    ? "ALL DAY"
                    : dateUtils.dateString(from: event.startDate, with: "h:mm a")
                let eventEndTime = event.endDate <= Date()
                    ? "Completed"
                    : "Ends at " + dateUtils.dateString(from: event.endDate, with: "h:mm a")

                row.eventLabel.setText(event.title)
                row.startDateLabel.setText(eventStartTime)
                row.endDateLabel.setText(eventEndTime)
            }
        }
    }
}
