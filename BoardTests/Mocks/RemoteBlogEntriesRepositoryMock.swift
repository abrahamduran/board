//
//  RemoteBlogEntriesRepositoryMock.swift
//  BoardTests
//
//  Created by Abraham Isaac Durán on 3/19/21.
//

import Foundation
@testable import Board

final class RemoteBlogEntriesRepositoryMock: BlogEntriesRepository {
    var fetchCompletion: FetchCompletion?
    var saveCompletion: SaveCompletion?

    func fetch(completion: @escaping FetchCompletion) {
        fetchCompletion = completion
    }

    func save(_ blogEntries: [BlogEntry], completion: @escaping SaveCompletion) {
        saveCompletion = completion
    }

    func fetchSuccess(_ entries: [BlogEntry]) {
        fetchCompletion?(.success(entries))
    }

    func saveFailure() {
        saveCompletion?(.failure(.entriesNotSaved))
    }
}
