//
//  OrdinalDateFormatter+EnvironmentKey.swift
//  Board
//
//  Created by Abraham Isaac Durán on 3/19/21.
//

import Foundation
import SwiftUI

// MARK: - EnvironmentKey

private struct OrdinalDateFormatterKey: EnvironmentKey {
    static let defaultValue: OrdinalDateFormatter = OrdinalDateFormatter()
}

extension EnvironmentValues {
    var ordinalDateFormatter: OrdinalDateFormatter {
        get { self[OrdinalDateFormatterKey.self] }
        set { self[OrdinalDateFormatterKey.self] = newValue }
    }
}
