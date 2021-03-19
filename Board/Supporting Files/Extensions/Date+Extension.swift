//
//  DateFormatter+Extension.swift
//  Board
//
//  Created by Abraham Isaac Durán on 3/19/21.
//

import Foundation

extension Date {
    enum Formatters {
        static let shortDate: DateFormatter = {
            let formatter = DateFormatter()
            formatter.locale = Locale.current
            formatter.setLocalizedDateFormatFromTemplate("MMMd")
            return formatter
        }()
    }

    var shortDateString: String {
        Formatters.shortDate.string(from: self)
    }
}