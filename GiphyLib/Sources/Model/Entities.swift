//
//  File.swift
//  
//
//  Created by Phillip Pape on 8/8/21.
//

import Foundation

public struct Feed: Codable {
    public let data: [GiphyGIF]
}

public struct GiphyGIF: Codable {
    public let images: GiphyImageOptions
    public let id: String
}

public struct GiphyImageOptions: Codable {
    public let fixedHeightVersion: GiphyImage

    enum CodingKeys: String, CodingKey {
        case fixedHeightVersion = "fixed_height"
    }
}

public struct GiphyImage: Codable {
    public let url: String
    public let width: String
    public let height: String
}

extension GiphyGIF: Hashable {
    public static func == (lhs: GiphyGIF, rhs: GiphyGIF) -> Bool {
        return rhs.id == lhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
