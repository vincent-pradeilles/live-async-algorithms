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
                            .aspectRatio(contentMode: .fill)
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
            .task {
                if movie == viewModel.movies.last {
                    await viewModel.commandChannel.send(.fetchMoreData)
                }
            }
        }
        .navigationTitle("Upcomming Movies")
        .task {
            await viewModel.commandChannel.send(.fetchInitialData)
        }
        .searchable(text: $viewModel.searchQuery)
        .refreshable {
            await viewModel.commandChannel.send(.fetchInitialData)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesView()
    }
}
