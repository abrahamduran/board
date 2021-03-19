//
//  BlogEntryPreview.swift
//  Board
//
//  Created by Abraham Isaac Durán on 3/19/21.
//

import Foundation

extension BlogEntry {
    static var preview: [BlogEntry] {
        return [
            BlogEntry(id: UUID(), user: User(name: "John White", email: "john@white.com", photoUrl: URL(string: "https://source.unsplash.com/random")!), posts: Post.preview),
            BlogEntry(id: UUID(), user: User(name: "Joe Doe", email: "joe@doe.com", photoUrl: URL(string: "https://source.unsplash.com/featured?jackie")!), posts: Post.preview),
            BlogEntry(id: UUID(), user: User(name: "Michael Woord", email: "michael@woord.com", photoUrl: URL(string: "https://source.unsplash.com/featured?michael")!), posts: Post.preview)
        ]
    }
}
