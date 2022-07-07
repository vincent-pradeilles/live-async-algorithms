//
//  MovieDetailsViewModel.swift
//  AsyncAlgorithms
//
//  Created by Vincent on 03/07/2022.
//

import Foundation
import Combine
import AsyncAlgorithms

@MainActor
class MovieDetailsViewModel: ObservableObject {
    
    let movie: Movie

    @Published var data: (credits: [MovieCastMember],
                          reviews: [MovieReview]) = ([], [])

    init(movie: Movie) {
        self.movie = movie
    }

    func fetchData() async {
        let creditsPublisher = getCredits(for: movie).map(\.cast)
        let reviewsPublisher = getReviews(for: movie).map(\.results)

        for await (credits, reviews) in combineLatest(creditsPublisher.values, reviewsPublisher.values) {
            data = (credits, reviews)
        }
    }
}
