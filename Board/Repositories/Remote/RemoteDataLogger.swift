//
//  RemoteDataLogger.swift
//  Board
//
//  Created by Abraham Isaac Durán on 3/17/21.
//

import Foundation
import Alamofire

final class RemoteDataLogger: EventMonitor {
    var queue: DispatchQueue = .networking

    func requestDidResume(_ request: Request) {
        print("REQUEST: \(request)")
    }

    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        debugPrint("RESPONSE: \(response)")
    }
}
