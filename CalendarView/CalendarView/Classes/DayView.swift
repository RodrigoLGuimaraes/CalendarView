//
//  DayView.swift
//  Calendar
//
//  Created by Nate Armstrong on 3/29/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//  Updated to Swift 4 by A&D Progress aka verebes (c) 2018
//

import UIKit
import SwiftMoment

let CalendarSelectedDayNotification = "CalendarSelectedDayNotification"

class DayView: UIView {

  var date: Moment! {
    didSet {
        dateLabel.text = date.format(dateFormat: "d")
      setNeedsLayout()
    }
  }
  lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = CalendarView.dayFont
    self.addSubview(label)
    return label
  }()
  var isToday: Bool = false
  var isOtherMonth: Bool = false
  var selected: Bool = false {
    didSet {
      if selected {
        NotificationCenter.default
            .post(name: NSNotification.Name(rawValue: CalendarSelectedDayNotification), object: date.toNSDate())
      }
      updateView()
    }
  }

  init() {
    super.init(frame: CGRect.zero)
    let tap = UITapGestureRecognizer(target: self, action: #selector(selectIt))
    addGestureRecognizer(tap)
    NotificationCenter.default.addObserver(self,
      selector: #selector(onSelected(notification:)),
      name: NSNotification.Name(rawValue: CalendarSelectedDayNotification),
      object: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    dateLabel.frame = bounds.insetBy(dx: 10, dy: 10) //(bounds, 10, 10)
    updateView()
  }

  @objc func onSelected(notification: NSNotification) {
    if let date = date, let nsDate = notification.object as? Date {
        let mo = moment(date: nsDate)
      if mo.month != date.month || mo.day != date.day {
        selected = false
      }
    }
  }

  func updateView() {
    DispatchQueue.main.async {
        if self.selected {
            self.dateLabel.textColor = CalendarView.daySelectedTextColor
            self.dateLabel.backgroundColor = CalendarView.daySelectedBackgroundColor
        } else if self.isToday {
            self.dateLabel.textColor = CalendarView.todayTextColor
            self.dateLabel.backgroundColor = CalendarView.todayBackgroundColor
        } else if self.isOtherMonth {
            self.dateLabel.textColor = CalendarView.otherMonthTextColor
            self.dateLabel.backgroundColor = CalendarView.otherMonthBackgroundColor
        } else {
          self.dateLabel.textColor = CalendarView.dayTextColor
          self.dateLabel.backgroundColor = CalendarView.dayBackgroundColor
        }
    }
  }

  @objc func selectIt() {
    selected = true
  }

}

public extension Moment {

  func toNSDate() -> Date? {
    let epoch = moment(date: Date(timeIntervalSince1970: 0))
    let timeInterval = self.intervalSince(moment: epoch)
    let date = Date(timeIntervalSince1970: timeInterval.seconds)
    return date
  }

  func isToday() -> Bool {
    let cal = Calendar.current
    return cal.isDateInToday(self.toNSDate()!)
  }

  func isSameMonth(other: Moment) -> Bool {
    return self.month == other.month && self.year == other.year
  }

}
