//
//  Movie.swift
//  SwipBox
//
//  Created by Zain Sidhu on 01/09/2023.
//

import Foundation

protocol MovieProtocol {
    var id: Int { set get }
    var title: String? { set get }
    var tagline: String? { set get }
    var overview: String? { set get }
    var releaseDate: String? { set get }
    var rating: Double? { set get }
    var poster: String? { get }
    var banner: String? { get }
}

struct Movie: MovieProtocol, Codable {
    var id: Int
    var title: String?
    var tagline: String?
    var overview: String?
    var releaseDate: String?
    var rating: Double?
    
    var posterPath: String?
    var backdropPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, tagline, overview
        case releaseDate = "release_date"
        case rating = "vote_average"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
    
    var poster: String? {
        guard let posterPath else { return nil }
        return "\(AppConfig.imagesUrl)/t/p/w300\(posterPath)"
    }
    
    var banner: String? {
        guard let backdropPath else { return nil }
        return "\(AppConfig.imagesUrl)/t/p/w400\(backdropPath)"
    }
}

struct PopularMoviesResponse: Codable {
    var page: Int
    var movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
    }
}
