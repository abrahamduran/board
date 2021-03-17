//
//  BlogEntry.swift
//  Board
//
//  Created by Abraham Isaac Durán on 3/16/21.
//

import Foundation

struct BlogEntry {
    let id: UUID
    let user: User
    let posts: [Post]
}
