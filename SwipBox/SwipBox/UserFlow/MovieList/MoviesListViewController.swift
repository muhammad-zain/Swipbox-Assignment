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
        setupRefreshControl()
        fetchInitialMovies()
    }
    
    private func setupViewModel() {
        let networkManager: NetworkManagerProtocol = NetworkManager()
        let service: MovieListServiceProtocol = MovieListService(networkManager: networkManager)
        viewModel = MovieListViewModel(service: service)
        viewModel.delegate = self
    }
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    private func fetchInitialMovies() {
        collectionView.showLoadingIndicator()
        viewModel.fetchInitialMovies()
    }
    
    @objc private func refreshMovies() {
        viewModel.fetchInitialMovies()
    }
    
    private func fetchNextPage() {
        viewModel.fetchNextPage()
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if collectionView.contentOffset.y >= collectionView.contentSize.height - collectionView.bounds.size.height {
            if !viewModel.isLoading && viewModel.totalMovies > 0 {
                fetchNextPage()
            }
        }
    }
}

// MARK: MovieListViewModelDelegate
extension MoviesListViewController: MovieListViewModelDelegate {
    func dataLoaded(_ count: Int, isFirstPage: Bool) {
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
