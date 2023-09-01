//
//  MovieListService.swift
//  SwipBox
//
//  Created by Zain Sidhu on 01/09/2023.
//

import Foundation

import Foundation

protocol MovieListServiceProtocol {
    func fetchMovies(completion: @escaping (Result<[MovieProtocol], Error>) -> Void)
}

struct MovieListService: MovieListServiceProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func fetchMovies(completion: @escaping (Result<[MovieProtocol], Error>) -> Void) {
        guard let url = URL(string: APIEndpoints.popularMovies) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        networkManager.getRequest(with: url, headers: [:]) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(PopularMoviesResponse.self, from: data)
                    completion(.success(response.movies))
                } catch {
                    completion(.failure(NetworkError.invalidData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
