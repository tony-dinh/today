//
//  ComplicationController.swift
//  day WatchKit Extension
//
//  Created by Tony Dinh on 2016-11-03.
//  Copyright © 2016 Tony Dinh. All rights reserved.
//

import ClockKit

class ComplicationController: NSObject, CLKComplicationDataSource {
    let dateUtility = Utils.date()
    let eventList = EventList()

    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(dateUtility.startOfToday())
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(dateUtility.endOfToday())
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        let entry = timelineEntry(for: Date(), with: complication.family)
        handler(entry)
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        guard let events = eventList.events else {
            return handler(nil)
        }
        var timelineEntries = [CLKComplicationTimelineEntry]()
        for event in events {
            let entryDate = event.endDate
            if entryDate < date {
                let entry = timelineEntry(for: entryDate, with: complication.family)
                timelineEntries.append(entry)
                if timelineEntries.count >= limit {
                    break
                }
            }
        }
        handler(timelineEntries)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        guard let events = eventList.events else {
            return handler(nil)
        }
        var timelineEntries = [CLKComplicationTimelineEntry]()
        for event in events {
            let entryDate = event.endDate
            if entryDate > date {
                let entry = timelineEntry(for: entryDate, with: complication.family)
                timelineEntries.append(entry)
                if timelineEntries.count >= limit {
                    break
                }
            }
        }
        handler(timelineEntries)
    }

    // MARK: - Placeholder Templates

    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        handler(templateFor(family: complication.family))
    }

    private func templateFor(family: CLKComplicationFamily, fillFraction: Float = 1.0) -> CLKComplicationTemplate {
        let tmpl: CLKComplicationTemplate?
        let img = UIImage(named: "Complication/Circular")
        let imageProvider = CLKImageProvider(onePieceImage: img!)

        switch family {
        case .circularSmall:
            tmpl = CLKComplicationTemplateCircularSmallRingImage()
            if let tmpl = tmpl as! CLKComplicationTemplateCircularSmallRingImage? {
                tmpl.imageProvider = imageProvider
                tmpl.fillFraction = fillFraction
            }
        case .modularSmall:
            tmpl = CLKComplicationTemplateModularSmallRingImage()
            if let tmpl = tmpl as! CLKComplicationTemplateModularSmallRingImage? {
                tmpl.imageProvider = imageProvider
                tmpl.fillFraction = fillFraction
            }
        default:
            tmpl = CLKComplicationTemplateUtilitarianSmallRingImage()
            if let tmpl = tmpl as! CLKComplicationTemplateUtilitarianSmallRingImage? {
                tmpl.imageProvider = imageProvider
                tmpl.fillFraction = fillFraction
            }
        }
        return tmpl!
    }

    private func templateForDate(for date: Date, with family: CLKComplicationFamily) -> CLKComplicationTemplate {
        guard let events = eventList.events, events.count > 0 else {
            return templateFor(family: family)
        }

        let completedEventsCount = eventList.eventsEndingBefore(date: date).count
        let fillFraction: Float = Float(completedEventsCount)/Float(events.count)
        return templateFor(family: family, fillFraction: fillFraction)
    }

    private func timelineEntry(for date: Date, with family: CLKComplicationFamily) -> CLKComplicationTimelineEntry {
        let template = templateForDate(for: date, with: family)
        return CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
    }
}
