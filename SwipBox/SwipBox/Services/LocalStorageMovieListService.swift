//
//  LocalStorageMovieListService.swift
//  SwipBox
//
//  Created by Zain Sidhu on 02/09/2023.
//

import Foundation

final class LocalStorageMovieListService: MovieListServiceProtocol {
    private var offset = 0
    init() {}

    func fetchMovies(page: Int, completion: @escaping (Result<[MovieProtocol], Error>) -> Void) {
        
        if let movies = DataModel.shared.fetchMovies(fetchOffset: offset) {
            offset += movies.count
            completion(.success(movies.compactMap({ movie in
                return movie.toMovieObject
            })))
        } else {
            completion(.failure(NetworkError.invalidData))
        }
    }
}
