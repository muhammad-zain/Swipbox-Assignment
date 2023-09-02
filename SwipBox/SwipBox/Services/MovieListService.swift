//
//  MovieListService.swift
//  SwipBox
//
//  Created by Zain Sidhu on 01/09/2023.
//

import Foundation

import Foundation

protocol MovieListServiceProtocol {
    func fetchMovies(page: Int, completion: @escaping (Result<[MovieProtocol], Error>) -> Void)
}

struct MovieListService: MovieListServiceProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func fetchMovies(page: Int, completion: @escaping (Result<[MovieProtocol], Error>) -> Void) {
        guard let url = URL(string: String(format: APIEndpoints.popularMovies, page)) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        networkManager.getRequest(with: url, headers: [:]) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(PopularMoviesResponse.self, from: data)
                    
                    for movie in response.movies {
                        if let movieModel = DataModel.shared.entity(entity: MovieModel.self, id: "\(movie.id)") {
                            movieModel.id = Int32(movie.id)
                            movieModel.title = movie.title
                            movieModel.overview = movie.overview
                            movieModel.releaseDate = movie.releaseDate
                            movieModel.backdropPath = movie.backdropPath
                            movieModel.posterPath = movie.posterPath
                            movieModel.rating = movie.rating ?? 0.0
                        }
                    }
                    
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
