//
//  BlogEntriesRepository.swift
//  Board
//
//  Created by Abraham Isaac Durán on 3/16/21.
//

import Foundation
enum BlogEntriesError: Error {
    case noEntriesFound, entriesNotSaved, entriesNotDeleted
}

protocol BlogEntriesRepository {
    typealias FetchCompletion = ((Swift.Result<[BlogEntry], BlogEntriesError>) -> Void)
    typealias SaveCompletion = ((Swift.Result<Void, BlogEntriesError>) -> Void)

    func fetch(completion: @escaping FetchCompletion)
    func save(_ blogEntries: [BlogEntry], completion: @escaping SaveCompletion)
}

final class RemoteBlogEntriesRepository: BlogEntriesRepository {
    let dataSource: RemoteDataSource
    let builder: RemoteBlogEntryBuilder

    init(dataSource: RemoteDataSource = RemoteDataSource(),
         builder: RemoteBlogEntryBuilder = RemoteBlogEntryBuilder()) {
        self.dataSource = dataSource
        self.builder = builder
    }
    
    func fetch(completion: @escaping FetchCompletion) {
        _ = dataSource.execute(BlogEntriesRouter.fetch) { [builder] result in
            switch result {
            case .success(let data):
                do {
                    let blogEntries = try builder.decode(data)
                    completion(.success(blogEntries))
                } catch let error {
                    assertionFailure(error.localizedDescription)
                    completion(.failure(.noEntriesFound))
                }
            case .failure(_):
                completion(.failure(.noEntriesFound))
            }
        }
    }

    func save(_ blogEntries: [BlogEntry], completion: @escaping SaveCompletion) {
        assertionFailure("Saving fucntionality is not currently supported by the remote data source.")
        completion(.failure(.entriesNotSaved))
}
}

final class LocalBlogEntriesRepository: BlogEntriesRepository {
    func fetch(completion: @escaping FetchCompletion) {
        completion(.success([]))
    }
}
