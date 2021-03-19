//
//  PostRow+EnvironmentValues.swift
//  Board
//
//  Created by Abraham Isaac Durán on 3/19/21.
//

import Foundation
import SwiftUI

struct PostRowAction {
    typealias Action = (URL) -> Void

    let onImageTapped: Action
}

private struct PostRowActionKey: EnvironmentKey {
    static let defaultValue: PostRowAction? = nil
}

extension EnvironmentValues {
    var postRowAction: PostRowAction? {
        get { self[PostRowActionKey.self] }
        set { self[PostRowActionKey.self] = newValue }
    }
}
