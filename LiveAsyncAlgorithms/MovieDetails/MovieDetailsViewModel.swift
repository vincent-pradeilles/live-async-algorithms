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
        async let credits = getCredits(for: movie)
        async let reviews = getReviews(for: movie)

        data = await (credits: credits.cast, reviews: reviews.results)
    }
}
