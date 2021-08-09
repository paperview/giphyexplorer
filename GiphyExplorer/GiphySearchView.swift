//
//  GiphySearchView.swift
//  GiphyExplorer
//
//  Created by Phillip Pape on 8/8/21.
//

import Foundation
import SwiftUI
import Model
import SDWebImageSwiftUI

struct GiphySearchView: View {

    @ObservedObject var model: GiphyFeedModel
    @State private var searchText = ""

    let columns = [
        GridItem()
    ]

    var body: some View {
        VStack {
            SearchBar(text: $searchText)
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(model.feed?.data ?? [], id: \.self) { gifObject in
                        let url = URL(string: gifObject.images.fixedHeightVersion.url)
                        WebImage(url: url)
                            .indicator(.activity)
                    }
                    Rectangle().onAppear {
                        if let gifs = model.feed?.data, gifs.count > 0 {
                            model.loadMore(offset: gifs.count)
                        }
                    }
                }
                .padding(.horizontal)
            }
            if (!searchText.isEmpty) {
                Button("Search") {
                    model.reload(withSearchString: searchText)
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }.padding(44)
                .background(Color.green)
                .foregroundColor(Color.white)
                .cornerRadius(10)
            }
        }.navigationBarHidden(true).padding(.vertical, 32)
    }
}

struct SearchBar: View {
    @Binding var text: String
    @State private var isEditing = false

    var body: some View {
        HStack {

            TextField("Search ...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)

                        if isEditing {
                            Button(action: {
                                self.text = ""

                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }

            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""

                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(AnyTransition.move(edge: .trailing).combined(with: .opacity))
                .animation(.default)
            }
        }
    }
}
