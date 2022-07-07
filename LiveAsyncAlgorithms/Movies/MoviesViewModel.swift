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
        for await searchQuery in $searchQuery.values.debounce(for: .microseconds(300)) {
            searchResults = await searchMovies(for: searchQuery).results
        }
    }

    func fetchInitialData() async {
        currentPage = 1
        upcommingMovies = await getMovies().results
    }

    func fetchMoreData() async {
        currentPage += 1
        upcommingMovies += await getMovies(page: currentPage).results
    }
}
