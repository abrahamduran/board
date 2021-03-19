//
//  DateFormatter+Extension.swift
//  Board
//
//  Created by Abraham Isaac Durán on 3/19/21.
//

import Foundation

extension Date {
    enum Formatters {
        static let server: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM dd yyyy HH:mm:ss Z"
            return formatter
        }()
    }
}
