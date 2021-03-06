//
//  RemoteBlogEntryBuilder.swift
//  Board
//
//  Created by Abraham Isaac Durán on 3/16/21.
//

import Foundation

final class RemoteBlogEntryBuilder {
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom({ decoder -> Date in
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)
                .replacingOccurrences(of: "GMT", with: "")
            return Date.Formatters.server.date(from: string) ?? Date()
        })
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    func decode(_ data: Data) throws -> [BlogEntry] {
        let response = try decoder.decode(Response.self, from: data).data
        return response.map(BlogEntry.init)
    }
}

private extension RemoteBlogEntryBuilder {
    struct Response: Decodable {
        let data: [BlogEntry]
    }
}

private extension RemoteBlogEntryBuilder.Response {
    struct BlogEntry: Decodable {
        let uid: UUID
        let name: String
        let email: String
        let profilePic: URL

        let posts: [Post]
    }

    struct Post: Decodable {
        let id: Int
        let date: Date
        let pics: [URL]
    }
}

private extension BlogEntry {
    init(_ response: RemoteBlogEntryBuilder.Response.BlogEntry) {
        id = response.uid
        user = User(name: response.name, email: response.email, photoUrl: response.profilePic)
        posts = response.posts.map(Post.init)
    }
}

private extension Post {
    init(_ response: RemoteBlogEntryBuilder.Response.Post) {
        id = response.id
        date = response.date
        photosUrls = response.pics
    }
}
