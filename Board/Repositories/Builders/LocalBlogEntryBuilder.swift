//
//  LocalBlogEntryBuilder.swift
//  Board
//
//  Created by Abraham Isaac Durán on 3/17/21.
//

import Foundation
import CouchbaseLiteSwift

final class LocalBlogEntryBuilder {
    func encode(_ blogEntries: [BlogEntry]) -> [MutableDocument] {
        blogEntries.map(MutableDocument.init)
    }

    func decode(_ data: [Result]) throws -> [BlogEntry] {
        data.compactMap(BlogEntry.init)
    }
}

private extension BlogEntry {
    init?(_ result: Result) {
        guard let idString = result.string(forKey: .id),
              let uuid = UUID(uuidString: idString),
              let name = result.string(forKey: .userName),
              let email = result.string(forKey: .userEmail),
              let photo = result.string(forKey: .userPhoto),
              let photoUrl = URL(string: photo),
              let postsArray = result.array(forKey: .posts)
              else { return nil }
        id = uuid
        user = User(name: name, email: email, photoUrl: photoUrl)
        posts = postsArray.compactMap { value -> DictionaryObject? in
            value as? DictionaryObject
        }
        .compactMap(Post.init)
    }
}

private extension Post {
    init?(_ result: DictionaryObject) {
        guard
              let id = result.int(forKey: .postId),
              let date = result.int(forKey: .postDate),
              let photos = result.array(forKey: .postPhotos)
              else { return nil }
        self.id = id
        self.date = Date(timeIntervalSince1970: Double(date))
        self.photosUrls = photos.toArray().compactMap(String.init(describing:)).compactMap(URL.init)
    }
}

private extension MutableDocument {
    typealias Key = LocalBlogEntriesRepository.BlogEntryKey
    typealias Constants = LocalBlogEntriesRepository.Constants

    convenience init(_ blogEntry: BlogEntry) {
        let posts = blogEntry.posts
            .map {
                MutableDictionaryObject(data: [
                    Key.postId.rawValue: $0.id,
                    Key.postDate.rawValue: $0.date.timeIntervalSince1970,
                    Key.postPhotos.rawValue: $0.photosUrls.map(\.absoluteString)
                ])
            }

        self.init()
        setString(blogEntry.id.uuidString, forKey: .id)
        setString(blogEntry.user.name, forKey: .userName)
        setString(blogEntry.user.email, forKey: .userEmail)
        setString(blogEntry.user.photoUrl.absoluteString, forKey: .userPhoto)
        setArray(MutableArrayObject(data: posts), forKey: .posts)
        setString(Constants.blogEntryType, forKey: "type")
    }

    func setArray(_ value: ArrayObject, forKey key: Key) {
        setArray(value, forKey: key.rawValue)
    }

    func setInt(_ value: Int, forKey key: Key) {
        setInt(value, forKey: key.rawValue)
    }

    func setString(_ value: String, forKey key: Key) {
        setString(value, forKey: key.rawValue)
    }
}

private extension Result {
    typealias Key = LocalBlogEntriesRepository.BlogEntryKey

    func array(forKey key: Key) -> ArrayObject? {
        array(forKey: key.rawValue)
    }

    func int(forKey key: Key) -> Int? {
        int(forKey: key.rawValue)
    }

    func string(forKey key: Key) -> String? {
        string(forKey: key.rawValue)
    }
}

private extension DictionaryObject {
    typealias Key = LocalBlogEntriesRepository.BlogEntryKey

    func array(forKey key: Key) -> ArrayObject? {
        array(forKey: key.rawValue)
    }

    func int(forKey key: Key) -> Int? {
        int(forKey: key.rawValue)
    }

    func string(forKey key: Key) -> String? {
        string(forKey: key.rawValue)
    }
}
