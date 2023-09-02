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
    func itemAt(_ index: Int) -> MovieProtocol
    var isLoading: Bool { get }
    func fetchInitialMovies()
    func fetchNextPage()
}

protocol MovieListViewModelDelegate: AnyObject {
    func dataLoaded(_ count: Int, isFirstPage: Bool)
    func onFailedLoadingData(_ error: Error)
}

final class MovieListViewModel: MovieListViewModelProtocol {
    private let service: MovieListServiceProtocol
    private var movies: [MovieProtocol] = []
    private var currentPage = 1
    private var isFetching = false
    weak var delegate: MovieListViewModelDelegate?
    
    var totalMovies: Int {
        movies.count
    }
    
    var isLoading: Bool {
        isFetching
    }

    init(service: MovieListServiceProtocol) {
        self.service = service
    }
    
    func fetchInitialMovies() {
        guard !isFetching else { return }
        currentPage = 1
        fetchMovies()
    }
    
    func fetchNextPage() {
        guard !isFetching else { return }
        currentPage += 1
        fetchMovies()
    }

    func fetchMovies() {
        debugPrint("Fetching \(currentPage)")
        isFetching = true
        service.fetchMovies(page: currentPage) { [weak self] result in
            guard let self else { return }
            self.isFetching = false
            debugPrint("End Fetching \(currentPage)")
            switch result {
            case .success(let movies):
                if self.currentPage == 1 {
                    self.movies = movies
                } else {
                    self.movies.append(contentsOf: movies)
                }
                self.delegate?.dataLoaded(self.movies.count, isFirstPage: currentPage == 1)
            case .failure(let error):
                self.delegate?.onFailedLoadingData(error)
            }
        }
    }
    
    func itemAt(_ index: Int) -> MovieProtocol {
        movies[index]
    }
}
