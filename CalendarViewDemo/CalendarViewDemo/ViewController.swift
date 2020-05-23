//
//  ViewController.swift
//  CalendarViewDemo
//
//  Created by Nate Armstrong on 5/7/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

import UIKit
import CalendarView
import SwiftMoment

class ViewController: UIViewController {
    
    @IBOutlet weak var calendar: CalendarView!
    
    var date: Moment! {
        didSet {
            DispatchQueue.main.async {
                self.title = self.date.format(dateFormat: "MMMM")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        date = moment()
        calendar.selectedDayOnPaged = nil
        calendar.selectionEnabled = false
        calendar.isDateSelected = { date in
            return true
            
        }
        calendar.delegate = self
    }
    
}

extension ViewController: CalendarViewDelegate {
    
    func calendarDidSelectDate(date: Moment) {
        self.date = date
    }
    
    func calendarDidPageToDate(date: Moment) {
        self.date = date
    }
    
}
