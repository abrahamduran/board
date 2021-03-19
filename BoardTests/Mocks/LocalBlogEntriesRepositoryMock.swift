//
//  LocalBlogEntriesRepositoryMock.swift
//  BoardTests
//
//  Created by Abraham Isaac Durán on 3/19/21.
//

import Foundation
@testable import Board

final class LocalBlogEntriesRepositoryMock: BlogEntriesRepository, BlogEntriesRepositoryDeletion {
    var fetchCompletion: FetchCompletion?
    var saveCompletion: SaveCompletion?
    var deleteCompletion: SaveCompletion?

    var savedEntries: [BlogEntry]?
    var deletedEntries: [BlogEntry]?

    func fetch(completion: @escaping FetchCompletion) {
        fetchCompletion = completion
    }

    func save(_ blogEntries: [BlogEntry], completion: @escaping SaveCompletion) {
        savedEntries = blogEntries
        saveCompletion = completion
    }

    func delete(_ blogEntries: [BlogEntry], completion: @escaping DeleteCompletion) {
        deletedEntries = blogEntries
        deleteCompletion = completion
    }

    func fetchSuccess(_ entries: [BlogEntry]) {
        fetchCompletion?(.success(entries))
    }

    func saveSuccess() {
        saveCompletion?(.success(()))
    }

    func deleteSuccess() {
        deleteCompletion?(.success(()))
    }
}

