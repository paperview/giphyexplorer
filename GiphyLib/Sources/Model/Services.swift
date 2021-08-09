//
//  File.swift
//  
//
//  Created by Phillip Pape on 8/8/21.
//

import Foundation
import Combine

public protocol NetworkService {
    func fetchData(with: URLRequest, handler: @escaping (Data?, URLResponse?, Error?) -> Void) -> AnyCancellable
}

public struct Services {
    let networkService: NetworkService
    public init(networkService: NetworkService) {
        self.networkService = networkService
    }
}
