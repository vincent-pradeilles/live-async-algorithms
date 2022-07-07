//
//  Model.swift
//  AsyncAlgorithms
//
//  Created by Vincent on 03/07/2022.
//

import Foundation
import Combine

let apiKey = "da9bc8815fb0fc31d5ef6b3da097a009"

let jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
}()

// MARK: - Movies

struct Movie: Decodable, Equatable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String
    var posterURL: URL {
        URL(string: "https://image.tmdb.org/t/p/w400/\(posterPath)")!
    }
}

struct MovieResponse: Decodable {
    let results: [Movie]
}

func getMovies(page: Int = 1) -> AnyPublisher<MovieResponse, Never> {
    let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=\(apiKey)&page=\(page)")!

    return URLSession
        .shared
        .dataTaskPublisher(for: url)
        .map { $0.data }
        .decode(type: MovieResponse.self, decoder: jsonDecoder)
        .replaceError(with: MovieResponse(results: []))
        .eraseToAnyPublisher()
}

func getMovies(page: Int = 1) async -> MovieResponse {
    let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=\(apiKey)&page=\(page)")!

    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try jsonDecoder.decode(MovieResponse.self, from: data)

        return decoded
    } catch {
        return MovieResponse(results: [])
    }
}

//MARK: - Search

func searchMovies(for query: String) -> AnyPublisher<MovieResponse, Never> {
    let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(encodedQuery)")!

    return URLSession
        .shared
        .dataTaskPublisher(for: url)
        .map { $0.data }
        .decode(type: MovieResponse.self, decoder: jsonDecoder)
        .replaceError(with: MovieResponse(results: []))
        .eraseToAnyPublisher()
}

func searchMovies(for query: String) async -> MovieResponse {
    let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(encodedQuery)")!

    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try jsonDecoder.decode(MovieResponse.self, from: data)

        return decoded
    } catch {
        return MovieResponse(results: [])
    }
}

//MARK: - Credits

struct MovieCastMember: Identifiable, Equatable, Decodable {
    let id: Int
    let name: String
    let character: String
}

struct MovieCreditsResponse: Decodable {
    let cast: [MovieCastMember]
}

func getCredits(for movie: Movie) -> AnyPublisher<MovieCreditsResponse, Never> {
    let url = URL(string: "https://api.themoviedb.org/3/movie/\(movie.id)/credits?api_key=\(apiKey)")!

    return URLSession
        .shared
        .dataTaskPublisher(for: url)
        .map { $0.data }
        .decode(type: MovieCreditsResponse.self, decoder: jsonDecoder)
        .replaceError(with: MovieCreditsResponse(cast: []))
        .eraseToAnyPublisher()
}

func getCredits(for movie: Movie) async -> MovieCreditsResponse {
    let url = URL(string: "https://api.themoviedb.org/3/movie/\(movie.id)/credits?api_key=\(apiKey)")!

    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try jsonDecoder.decode(MovieCreditsResponse.self, from: data)

        return decoded
    } catch {
        return MovieCreditsResponse(cast: [])
    }
}

//MARK: - Reviews

struct MovieReview: Identifiable, Equatable, Decodable {
    let id: String
    let author: String
    let content: String
}

struct MovieReviewsResponse: Decodable {
    let results: [MovieReview]
}

func getReviews(for movie: Movie) -> AnyPublisher<MovieReviewsResponse, Never> {
    let url = URL(string: "https://api.themoviedb.org/3/movie/\(movie.id)/reviews?api_key=\(apiKey)")!

    return URLSession
        .shared
        .dataTaskPublisher(for: url)
        .map { $0.data }
        .decode(type: MovieReviewsResponse.self, decoder: jsonDecoder)
        .replaceError(with: MovieReviewsResponse(results: []))
        .eraseToAnyPublisher()
}

func getReviews(for movie: Movie) async -> MovieReviewsResponse {
    let url = URL(string: "https://api.themoviedb.org/3/movie/\(movie.id)/reviews?api_key=\(apiKey)")!

    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try jsonDecoder.decode(MovieReviewsResponse.self, from: data)

        return decoded
    } catch {
        return MovieReviewsResponse(results: [])
    }
}
