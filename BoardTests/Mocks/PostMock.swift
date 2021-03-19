//
//  PostMock.swift
//  BoardTests
//
//  Created by Abraham Isaac Durán on 3/19/21.
//

import Foundation
@testable import Board

extension Post {
    static func mock() -> [Post] {
        let urls = [
            "https://source.unsplash.com/featured/500x500/?coffee",
            "https://source.unsplash.com/featured/500x500/?water",
            "https://source.unsplash.com/featured/500x500/?table",
            "https://source.unsplash.com/featured/500x500/?person",
            "https://source.unsplash.com/featured/500x500/?forest"
        ].compactMap(URL.init(string:))
        return [
            Post(id: 1, date: Date(timeIntervalSince1970: 1611979200), photosUrls: [URL(string: "https://source.unsplash.com/featured/500x500/?coffee")!]),
            Post(id: 2, date: Date(timeIntervalSince1970: 1611806400), photosUrls: [URL(string: "https://source.unsplash.com/featured/500x500/?coffee")!, URL(string:"https://source.unsplash.com/featured/500x500/?water")!]),
            Post(id: 3, date: Date(timeIntervalSince1970: 1608350400), photosUrls: [URL(string: "https://source.unsplash.com/featured/500x500/?coffee")!, URL(string:"https://source.unsplash.com/featured/500x500/?water")!, URL(string:"https://source.unsplash.com/featured/500x500/?table")!]),
            Post(id: 4, date: Date(timeIntervalSince1970: 1608264000), photosUrls: urls)
        ]
    }
}
