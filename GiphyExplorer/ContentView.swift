//
//  ContentView.swift
//  GiphyExplorer
//
//  Created by Phillip Pape on 8/8/21.
//

import SwiftUI
import Model

struct ContentView: View {
    @ObservedObject var model: GiphyFeedModel
    var body: some View {
        NavigationView {
            GiphySearchView(model: model)
            Color.clear
        }
        .alert(item: $model.error) { error in
            Alert(title: Text(verbatim: error.localizedDescription))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        // todo insert mock
        ContentView(model: GiphyFeedModel(services: Services(networkService: URLSession.shared)))
    }
}
