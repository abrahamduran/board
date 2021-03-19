//
//  BlogEntriesRepository.swift
//  Board
//
//  Created by Abraham Isaac Durán on 3/16/21.
//

import Foundation
import CouchbaseLiteSwift

enum BlogEntriesError: Error {
    case noEntriesFound, entriesNotSaved, entriesNotDeleted
}

protocol BlogEntriesRepository {
    typealias FetchCompletion = ((Swift.Result<[BlogEntry], BlogEntriesError>) -> Void)
    typealias SaveCompletion = ((Swift.Result<Void, BlogEntriesError>) -> Void)

    func fetch(completion: @escaping FetchCompletion)
    func save(_ blogEntries: [BlogEntry], completion: @escaping SaveCompletion)
}

protocol BlogEntriesRepositoryDeletion {
    typealias DeleteCompletion = ((Swift.Result<Void, BlogEntriesError>) -> Void)

    func delete(_ blogEntries: [BlogEntry], completion: @escaping DeleteCompletion)
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

final class LocalBlogEntriesRepository: BlogEntriesRepository, BlogEntriesRepositoryDeletion {
    let dataSource: LocalDataSource
    let builder: LocalBlogEntryBuilder

    init(dataSource: LocalDataSource = LocalDataSource.shared,
         builder: LocalBlogEntryBuilder = LocalBlogEntryBuilder()) {
        self.dataSource = dataSource
        self.builder = builder
    }

    func fetch(completion: @escaping FetchCompletion) {
        let select = BlogEntryKey.allCases
            .map(\.rawValue)
            .map(SelectResult.property)
        let query = LocalDataSource.QueryItems(
            select: select,
            where: Expression.property("type").equalTo(Expression.string(Constants.blogEntryType)))

        let result = dataSource.fetch(with: query)

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

    func save(_ blogEntries: [BlogEntry], completion: @escaping SaveCompletion) {
        let documents = builder.encode(blogEntries)
        let result = dataSource.save(documents)
        switch result {
        case .success():
            completion(.success(()))
        case .failure(_):
            completion(.failure(.entriesNotSaved))
        }
    }

    func delete(_ blogEntries: [BlogEntry], completion: @escaping DeleteCompletion) {
        guard !blogEntries.isEmpty else {
            completion(.success(())); return
        }
        
        let result = dataSource.delete()
        switch result {
        case .success():
            completion(.success(()))
        case .failure(_):
            completion(.failure(.entriesNotDeleted))
        }
    }

}

extension LocalBlogEntriesRepository {
    enum Constants {
        static let blogEntryType = "blog-entry"
    }

    enum BlogEntryKey: String, CaseIterable {
        case id, userName, userEmail, userPhoto, posts, postId, postDate, postPhotos
    }
}
