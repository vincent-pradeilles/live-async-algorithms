//
//  MoviesViewModel.swift
//  AsyncAlgorithms
//
//  Created by Vincent on 03/07/2022.
//

import Foundation
import Combine

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
    private var cancellables = Set<AnyCancellable>()

    init() {
        $searchQuery
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .flatMap { searchMovies(for: $0) }
            .map(\.results)
            .receive(on: DispatchQueue.main)
            .assign(to: &$searchResults)
    }

    func fetchInitialData() {
        currentPage = 1
        
        getMovies()
            .map(\.results)
            .receive(on: DispatchQueue.main)
            .assign(to: \.upcommingMovies, on: self)
            .store(in: &cancellables)
    }

    func fetchMoreData() {
        currentPage += 1

        getMovies(page: currentPage)
            .map(\.results)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] newMovies in
                self?.upcommingMovies.append(contentsOf: newMovies)
            })
            .store(in: &cancellables)
    }
}
