//
//  File.swift
//  
//
//  Created by Phillip Pape on 8/8/21.
//

import Foundation

public extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
