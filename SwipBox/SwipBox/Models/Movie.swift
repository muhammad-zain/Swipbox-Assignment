//
//  Movie.swift
//  SwipBox
//
//  Created by Zain Sidhu on 01/09/2023.
//

import Foundation

protocol MovieProtocol: Codable {
    var id: Int { set get }
    var title: String? { set get }
    var releaseDate: String? { set get }
    var rating: Double? { set get }
    var posterPath: String? { set get }
    
    var poster: String? { get }
}

struct Movie: MovieProtocol {
    var id: Int
    var title: String?
    var releaseDate: String?
    var rating: Double?
    var posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case releaseDate = "release_date"
        case rating = "vote_average"
        case posterPath = "poster_path"
    }
    
    var poster: String? {
        guard let posterPath else { return nil }
        return "\(AppConfig.imagesUrl)/t/p/w300\(posterPath)"
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
