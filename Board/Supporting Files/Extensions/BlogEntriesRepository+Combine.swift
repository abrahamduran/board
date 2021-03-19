//
//  BlogEntriesRepository+Combine.swift
//  Board
//
//  Created by Abraham Isaac Durán on 3/19/21.
//

import Foundation
import Combine

extension BlogEntriesRepository {
    func fetch() -> Deferred<Future<[BlogEntry], BlogEntriesError>> {
        Deferred {
            Future { promise in
                self.fetch(completion: promise)
            }
        }
    }
    func save(_ blogEntries: [BlogEntry]) -> Deferred<Future<Void, BlogEntriesError>> {
        Deferred {
            Future { promise in
                self.save(blogEntries, completion: promise)
            }
        }
    }
}

extension BlogEntriesRepositoryDeletion {
    func delete(_ blogEntries: [BlogEntry]) -> Deferred<Future<Void, BlogEntriesError>> {
        Deferred {
            Future { promise in
                delete(blogEntries, completion: promise)
            }
        }
    }
}
