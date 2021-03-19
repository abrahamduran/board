//
//  BlogEntriesRepositoryPreview.swift
//  Board
//
//  Created by Abraham Isaac Durán on 3/19/21.
//

import Foundation

struct BlogEntriesRepositoryPreview: BlogEntriesRepository {
    func fetch(completion: @escaping FetchCompletion) {
        completion(.success(BlogEntry.preview))
    }

    func save(_ blogEntries: [BlogEntry], completion: @escaping SaveCompletion) {
        completion(.success(()))
    }
}

extension BlogEntriesRepositoryPreview: BlogEntriesRepositoryDeletion {
    func delete(_ blogEntries: [BlogEntry], completion: @escaping DeleteCompletion) {
        completion(.success(()))
    }
}
