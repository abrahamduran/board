//
//  OrdinalDateFormatter.swift
//  Board
//
//  Created by Abraham Isaac Durán on 3/19/21.
//

import Foundation

struct OrdinalDateFormatter {
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter
    }()

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.setLocalizedDateFormatFromTemplate("MMM")
        return formatter
    }()

    func string(from date: Date) -> String {
        let month = dateFormatter.string(from: Date())
        let day = dateFormatter.calendar.dateComponents([.day], from: date).day
        guard let d = day, let ordinal = numberFormatter.string(from: NSNumber(value: d)) else {
            return month
        }
        return "\(month) \(ordinal)"
    }
}
