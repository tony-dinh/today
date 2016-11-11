//
//  ViewController.swift
//  day
//
//  Created by Tony Dinh on 2016-11-03.
//  Copyright © 2016 Tony Dinh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let eventManager = EventManager()
    override func viewDidLoad() {
        super.viewDidLoad()

        if eventManager.accessGranted != true {
            eventManager.requestAccess()
        }

//        let calendars = eventManager.getEventCalendars()
//        let events = eventManager.getTodaysEvents(forCalendars: calendars)
//
//        NSLog("Calendars: ")
//        for calendar in eventManager.getEventCalendars() {
//            NSLog(calendar.title + ":")
//            NSLog("     type: \(calendar.type)")
//        }
//
//        for event in events {
//            NSLog(event.title)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

