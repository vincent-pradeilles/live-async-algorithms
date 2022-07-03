//
//  MovieDetailsViewModel.swift
//  AsyncAlgorithms
//
//  Created by Vincent on 03/07/2022.
//

import Foundation
import Combine

class MovieDetailsViewModel: ObservableObject {
    
    let movie: Movie

    @Published var data: (credits: [MovieCastMember],
                          reviews: [MovieReview]) = ([], [])

    private var cancellables = Set<AnyCancellable>()

    init(movie: Movie) {
        self.movie = movie
    }

    func fetchData() {
        let creditsPublisher = getCredits(for: movie).map(\.cast)
        let reviewsPublisher = getReviews(for: movie).map(\.results)

        Publishers.CombineLatest(creditsPublisher, reviewsPublisher)
            .receive(on: DispatchQueue.main)
            .map { (credits: $0.0, reviews: $0.1) }
            .assign(to: \.data, on: self)
            .store(in: &cancellables)
    }
}
