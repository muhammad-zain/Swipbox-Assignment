//
//  MovieDetailViewModel.swift
//  SwipBox
//
//  Created by Zain Sidhu on 02/09/2023.
//

import Foundation


protocol MovieDetailViewModelProtocol {
    var delegate: MovieDetailViewModelDelegate? { get set }
    var movie: MovieProtocol { set get }
    func fetchDetail()
}

protocol MovieDetailViewModelDelegate: AnyObject {
    func dataLoaded()
    func onFailedLoadingData(_ error: Error)
}

final class MovieDetailViewModel: MovieDetailViewModelProtocol {
    private let service: MovieDetailServiceProtocol
    var movie: MovieProtocol
    weak var delegate: MovieDetailViewModelDelegate?
    
    init(movie: MovieProtocol) {
        self.movie = movie
        self.service = MovieDetailService(networkManager: NetworkManager())
    }

    func fetchDetail() {
        service.fetchMovieDetail(movieId: movie.id) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let movie):
                self.movie = movie
                self.delegate?.dataLoaded()
            case .failure(let error):
                self.delegate?.onFailedLoadingData(error)
            }
        }
    }
}
