//
//  LocalDataSource.swift
//  Board
//
//  Created by Abraham Isaac Durán on 3/17/21.
//

import Foundation
import CouchbaseLiteSwift

final class LocalDataSource {
    static let shared = LocalDataSource()

    private var database: Database
    private let databaseName = "blog-entries-db"

    private init() {
        if let path = Bundle.main.path(forResource: databaseName, ofType: "cblite2"),
           !Database.exists(withName: databaseName) {
          do {
            try Database.copy(fromPath: path, toDatabase: databaseName, withConfig: nil)
          } catch {
            fatalError("Could not load pre-built database")
          }
        }

        do {
          database = try Database(name: databaseName)
        } catch {
          fatalError("Error opening database")
        }
    }

    func fetch(with queryItems: QueryItems) -> Swift.Result<[Result], Error> {
        let query = QueryBuilder
            .select(queryItems.select)
            .from(DataSource.database(database))
            .where(queryItems.where)

        do {
            let results = try query.execute().allResults()
            return .success(results)
        } catch {
            assertionFailure(error.localizedDescription)
            return .failure(.noData)
        }
    }

    func save(_ documents: [MutableDocument]) -> Swift.Result<Void, Error> {
        var anyError: Error? = nil
        for document in documents {
            do {
                try database.saveDocument(document, conflictHandler: { _, _ in true })
            } catch {
                anyError = .saveError
                assertionFailure(error.localizedDescription)
            }
        }
        if let error = anyError {
            return .failure(error)
        }
        return .success(())
    }

    func delete() -> Swift.Result<Void, Error> {
        do {
            try database.delete()
            database = try Database(name: databaseName)
        } catch {
            assertionFailure(error.localizedDescription)
            return .failure(.deleteError)
        }
        return .success(())
    }
}

extension LocalDataSource {
    enum Error: Swift.Error {
        case noData, saveError, deleteError
    }

    struct QueryItems {
        let select: [SelectResultProtocol]
        let `where`: ExpressionProtocol
    }
}
