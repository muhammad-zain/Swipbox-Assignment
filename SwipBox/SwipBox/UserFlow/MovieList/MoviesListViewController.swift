//
//  MoviesListViewController.swift
//  SwipBox
//
//  Created by Zain Sidhu on 01/09/2023.
//

import UIKit

final class MoviesListViewController: BaseViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var viewModel: MovieListViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(ofType: MovieListCollectionViewCell.self)
        setupViewModel()
        
        fetchMovies()
    }
    
    private func setupViewModel() {
        let networkManager: NetworkManagerProtocol = NetworkManager()
        let service: MovieListServiceProtocol = MovieListService(networkManager: networkManager)
        viewModel = MovieListViewModel(service: service)
        viewModel.delegate = self
    }
    
    private func fetchMovies() {
        collectionView.showLoadingIndicator()
        viewModel.fetchMovies()
    }
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MoviesListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.totalMovies
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeue(ofType: MovieListCollectionViewCell.self, for: indexPath)
        
        cell.movie = viewModel.itemAt(indexPath.row)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.width - 40)/3
        return CGSize(width: size, height: size * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigator.navigate(.movieDetail(viewModel.itemAt(indexPath.row)))
    }
}

// MARK: MovieListViewModelDelegate
extension MoviesListViewController: MovieListViewModelDelegate {
    func dataLoaded(_ callCount: Int) {
        DispatchQueue.main.async {
            self.collectionView.hideLoadingIndicator()
            self.collectionView.reloadData()
        }
    }
    
    func onFailedLoadingData(_ error: Error) {
        DispatchQueue.main.async {
            self.collectionView.hideLoadingIndicator()
            self.alertPresenter.showErrorMessageAlert(message: error.localizedDescription)
        }
    }
}
