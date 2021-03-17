//
//  DispatchQueue+Extension.swift
//  Board
//
//  Created by Abraham Isaac Durán on 3/17/21.
//

import Foundation

extension DispatchQueue {
    static let networking = DispatchQueue(label: "\(Bundle.main.bundleIdentifier ?? "boardapp").networking", qos: .utility, attributes: .concurrent)
}
