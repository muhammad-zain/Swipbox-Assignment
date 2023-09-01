//
//  MovieListViewModel.swift
//  SwipBox
//
//  Created by Zain Sidhu on 01/09/2023.
//

import Foundation

protocol MovieListViewModelProtocol {
    var delegate: MovieListViewModelDelegate? { get set }
    var totalMovies: Int { get }
    func fetchMovies()
    func itemAt(_ index: Int) -> MovieProtocol
}

protocol MovieListViewModelDelegate: AnyObject {
    func dataLoaded(_ count: Int)
    func onFailedLoadingData(_ error: Error)
}

final class MovieListViewModel: MovieListViewModelProtocol {
    private let service: MovieListServiceProtocol
    private var movies: [MovieProtocol] = []
    weak var delegate: MovieListViewModelDelegate?
    
    var totalMovies: Int {
        movies.count
    }

    init(service: MovieListServiceProtocol) {
        self.service = service
    }

    func fetchMovies() {
        service.fetchMovies { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let movies):
                self.movies = movies
                self.delegate?.dataLoaded(self.movies.count)
            case .failure(let error):
                self.delegate?.onFailedLoadingData(error)
            }
        }
    }
    
    func itemAt(_ index: Int) -> MovieProtocol {
        movies[index]
    }
}
