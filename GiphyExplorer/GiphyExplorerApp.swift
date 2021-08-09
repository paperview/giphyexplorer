//
//  GiphyExplorerApp.swift
//  GiphyExplorer
//
//  Created by Phillip Pape on 8/8/21.
//

import SwiftUI
import Model
import Network

@main
struct GiphyExplorerApp: App {
    @StateObject var model = GiphyFeedModel(services: Services(networkService: URLSession.shared))
    var body: some Scene {
        WindowGroup {
            ContentView(model: model)
        }
    }
}
