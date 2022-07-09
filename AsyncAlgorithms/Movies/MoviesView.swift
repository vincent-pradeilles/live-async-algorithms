//
//  MoviesView.swift
//  AsyncAlgorithms
//
//  Created by Vincent on 03/07/2022.
//

import SwiftUI

struct MoviesView: View {

    @StateObject var viewModel = MoviesViewModel()

    var body: some View {
        List(viewModel.movies) { movie in
            NavigationLink {
                MovieDetailsView(movie: movie)
            } label: {
                HStack {
                    AsyncImage(url: movie.posterURL) { poster in
                        poster
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 100)
                    }

                    VStack(alignment: .leading) {
                        Text(movie.title)
                            .font(.headline)
                        Text(movie.overview)
                            .font(.caption)
                            .lineLimit(3)
                    }
                }
            }
            .onAppear {
                if movie == viewModel.movies.last {
                    viewModel.fetchMoreData()
                }
            }
        }
        .navigationTitle("Upcomming Movies")
        .onAppear {
            viewModel.fetchInitialData()
        }
        .searchable(text: $viewModel.searchQuery)
        .refreshable {
            viewModel.fetchInitialData()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesView()
    }
}