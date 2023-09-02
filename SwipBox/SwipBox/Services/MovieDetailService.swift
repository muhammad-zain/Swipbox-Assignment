//
//  MovieDetailService.swift
//  SwipBox
//
//  Created by Zain Sidhu on 01/09/2023.
//

import Foundation

import Foundation

protocol MovieDetailServiceProtocol {
    func fetchMovieDetail(movieId: Int, completion: @escaping (Result<MovieProtocol, Error>) -> Void)
}

struct MovieDetailService: MovieDetailServiceProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func fetchMovieDetail(movieId: Int, completion: @escaping (Result<MovieProtocol, Error>) -> Void) {
        guard let url = URL(string: String(format: APIEndpoints.movieDetail, "\(movieId)")) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        networkManager.getRequest(with: url, headers: [:]) { result in
            switch result {
            case .success(let data):
                do {
                    let movie = try JSONDecoder().decode(Movie.self, from: data)
                    completion(.success(movie))
                } catch {
                    completion(.failure(NetworkError.invalidData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
