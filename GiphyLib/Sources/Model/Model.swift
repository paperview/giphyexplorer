//
//  File.swift
//  
//
//  Created by Phillip Pape on 8/8/21.
//

import Foundation
import Combine
import Tools

public protocol Model {
    func reload()
}

public class GiphyFeedModel: ObservableObject, Model {
    @Published public private(set) var feed: Feed?
    @Published public var error: IdentifiableError?
    private var searchString: String = ""
    private var offset: Int = 0
    private var isReloading = false
    
    var task: AnyCancellable?
    let services: Services
    public init(services: Services) {
        self.services = services
        reload()
    }
    
    public func reload(withSearchString searchString: String) {
        self.searchString = searchString
        self.offset = 0
        reload()
    }
    
    public func loadMore(offset: Int) {
        self.offset = offset
        reload()
    }
    
    public func reload() {
        let endpoint = self.searchString.isEmpty ? giphyTrendingEndpoint() : giphySearchEndpoint()
        guard let feedUrl = URL(string: endpoint), !isReloading else {
            return
        }
        
        isReloading = true
        let request = URLRequest(url: feedUrl)
        task = services.networkService.fetchData(with: request) { [unowned self] data, response, error in
            self.isReloading = false
            do {
                if let error = error { throw error }
                let feed = try JSONDecoder().decode(Feed.self, from: data ?? Data())
                
                if (self.offset > 0) {
                    let combinedGifs = Array(Set((self.feed?.data ?? []) + feed.data))
                    let combinedFeed = Feed(data: combinedGifs)
                    DispatchQueue.main.async { self.feed = combinedFeed }
                } else {
                    DispatchQueue.main.async { self.feed = feed }
                }

            } catch {
                DispatchQueue.main.async { self.error = IdentifiableError(underlying: error) }
            }
        }
    }
    
    private func giphySearchEndpoint() -> String {
        let queryParams: [String: String] = [
            "api_key": "ZsUpUm2L6cVbvei347EQNp7HrROjbOdc",
            "q": self.searchString,
            "offset": "\(self.offset)"
        ]
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.giphy.com"
        urlComponents.path = "/v1/gifs/search"
        urlComponents.setQueryItems(with: queryParams)
        return urlComponents.url?.absoluteString ?? "";
    }
    
    private func giphyTrendingEndpoint() -> String {
        let queryParams: [String: String] = [
            "api_key": "ZsUpUm2L6cVbvei347EQNp7HrROjbOdc",
            "offset": "\(self.offset)"
        ]
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.giphy.com"
        urlComponents.path = "/v1/gifs/trending"
        urlComponents.setQueryItems(with: queryParams)
        return urlComponents.url?.absoluteString ?? "";
    }
}

