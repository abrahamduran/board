//
//  BlogEntriesRouter.swift
//  Board
//
//  Created by Abraham Isaac Durán on 3/17/21.
//

import Foundation
import Alamofire

enum BlogEntriesRouter: URLRequestConvertible {
    case fetch

    var baseUrl: URL {
        URL(string: "https://mock.koombea.io/mt/api")!
    }

    var path: String { "/users/posts" }

    var method: HTTPMethod { .get }

    func asURLRequest() throws -> URLRequest {
        let url = baseUrl.appendingPathComponent(path)
        return try URLRequest(url: url, method: method)
    }
}
