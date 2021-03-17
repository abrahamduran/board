//
//  RemoteDataSource.swift
//  Board
//
//  Created by Abraham Isaac Durán on 3/17/21.
//

import Foundation
import Alamofire

final class RemoteDataSource {
    private let session: Session

    init(session: Session = Session(eventMonitors: [RemoteDataLogger()])) {
        self.session = session
    }

    func execute(_ request: URLRequestConvertible, completion: @escaping (Result<Data, Error>) -> Void) -> DataRequest? {
        session
            .request(request)
            .responseJSON(queue: .networking) { (response) in
                guard let data = response.data else {
                    completion(.failure(.noData)) ; return
                }

                completion(.success(data))
            }
    }
}

extension RemoteDataSource {
    enum Error: Swift.Error {
        case noData
    }
}
