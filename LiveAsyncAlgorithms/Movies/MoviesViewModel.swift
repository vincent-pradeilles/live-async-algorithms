//
//  MoviesViewModel.swift
//  AsyncAlgorithms
//
//  Created by Vincent on 03/07/2022.
//

import Foundation
import Combine
import AsyncAlgorithms

@MainActor
class MoviesViewModel: ObservableObject {

    enum Command {
        case fetchInitialData
        case fetchMoreData
    }

    private(set) var commandChannel = AsyncChannel<Command>()
    
    @Published private var upcommingMovies = [Movie]()

    @Published var searchQuery: String = ""
    @Published private var searchResults = [Movie]()

    var movies: [Movie] {
        if searchQuery.isEmpty {
            return upcommingMovies
        } else {
            return searchResults
        }
    }

    private var currentPage = 1

    func listenToSearchQuery() async {
        for await searchQuery in $searchQuery.values.debounce(for: .milliseconds(300)) {
            searchResults = await searchMovies(for: searchQuery).results
        }
    }

    func listenToCommands() async {
        for await command in commandChannel {
            switch command {
            case .fetchInitialData:
                await fetchInitialData()
            case .fetchMoreData:
                await fetchMoreData()
            }
        }
    }

    private func fetchInitialData() async {
        currentPage = 1
        upcommingMovies = await getMovies().results
    }

    private func fetchMoreData() async {
        currentPage += 1
        upcommingMovies += await getMovies(page: currentPage).results
    }
}
