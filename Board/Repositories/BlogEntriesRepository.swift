//
//  BlogEntriesRepository.swift
//  Board
//
//  Created by Abraham Isaac Durán on 3/16/21.
//

import Foundation

protocol BlogEntriesRepository {
    typealias FetchCompletion = ((Result<[BlogEntry], Error>) -> Void)

    func fetch(completion: @escaping FetchCompletion)
}

final class RemoteBlogEntriesRepository: BlogEntriesRepository {
    func fetch(completion: @escaping FetchCompletion) {
        completion(.success([]))
    }
}

final class LocalBlogEntriesRepository: BlogEntriesRepository {
    func fetch(completion: @escaping FetchCompletion) {
        completion(.success([]))
    }
}
