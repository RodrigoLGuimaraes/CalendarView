//
//  MonthView.swift
//  Calendar
//
//  Created by Nate Armstrong on 3/29/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//  Updated to Swift 4 by A&D Progress aka verebes (c) 2018
//

import UIKit
import SwiftMoment

class MonthView: UIView {
    
    let maxNumWeeks = 6
    
    var date: Moment! {
        didSet {
            startsOn = date.startOf(unit: .Months).weekday // Sun is 1
            let numDays = Double(date.endOf(unit: .Months).day + startsOn - 1)
            self.numDays = Int(ceil(numDays / 7.0) * 7)
            self.numDays = 42 // TODO: add option to always show 6 weeks
            setWeeks()
        }
    }
    
    fileprivate static func weekdayNameFrom(_ weekdayNumber: Int) -> String {
        var calendar = Locale.current.calendar
        if let lang = Locale.preferredLanguages.first {
            calendar = Locale(identifier: lang).calendar
        }
        let weekdaySymbols = calendar.weekdaySymbols
        let index = (weekdayNumber + calendar.firstWeekday - 1) % 7
        let uppercased = weekdaySymbols[index].uppercased()
        
        if uppercased.count <= 3 { return uppercased }
        
        let stringIndex = uppercased.index(uppercased.startIndex, offsetBy: 2)
        let firstThree = uppercased[...stringIndex]
        return String(firstThree)
    }
    
    var weeks: [WeekView] = []
    var weekLabels: [WeekLabel] = [
        WeekLabel(day: MonthView.weekdayNameFrom(6)),
        WeekLabel(day: MonthView.weekdayNameFrom(0)),
        WeekLabel(day: MonthView.weekdayNameFrom(1)),
        WeekLabel(day: MonthView.weekdayNameFrom(2)),
        WeekLabel(day: MonthView.weekdayNameFrom(3)),
        WeekLabel(day: MonthView.weekdayNameFrom(4)),
        WeekLabel(day: MonthView.weekdayNameFrom(5)),
    ]
    
    // these values are expensive to compute so cache them
    var numDays: Int = 30
    var startsOn: Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        weeks = []
        for _ in 1...maxNumWeeks {
            let week = WeekView(frame: CGRect.zero)
            addSubview(week)
            weeks.append(week)
        }
        for label in weekLabels {
            addSubview(label)
        }
    }
    
    func setdown() {
        for week in weeks {
            week.setdown()
            week.removeFromSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var x: CGFloat = 0
        let labelHeight: CGFloat = 18
        let inset: CGFloat = 10
        for label in weekLabels {
            label.frame = CGRect(x: x, y: inset, width: bounds.size.width / 7, height: labelHeight)
            x = label.frame.maxX
        }
        var y: CGFloat = labelHeight + inset
        for i in 1...weeks.count {
            let week = weeks[i - 1]
            week.frame = CGRect(x: 0, y: y, width: bounds.size.width, height: (bounds.size.height - (labelHeight + inset) - inset) / maxNumWeeks)
            y = week.frame.maxY
        }
    }
    
    func setWeeks() {
        if weeks.count > 0 {
            let numWeeks = Int(numDays / 7)
            let firstVisibleDate  = date.startOf(unit: .Months).endOf(unit: .Days).subtract(value: startsOn - 1, .Days).startOf(unit: .Days)
            for i in 1...weeks.count {
                let firstDateOfWeek = firstVisibleDate.add(value: 7*(i-1), .Days)
                let week = weeks[i - 1]
                week.month = date
                week.date = firstDateOfWeek
                week.isHidden = i > numWeeks
            }
        }
    }
    
}

class WeekLabel: UILabel {
    
    init(day: String) {
        super.init(frame: CGRect.zero)
        text = day
        textAlignment = .center
        textColor = CalendarView.weekLabelTextColor
        font = UIFont.boldSystemFont(ofSize: 10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
}
