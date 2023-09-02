//
//  MovieDetailViewController.swift
//  SwipBox
//
//  Created by Zain Sidhu on 01/09/2023.
//

import UIKit
import Kingfisher

final class MovieDetailViewController: BaseViewController {
    
    @IBOutlet private weak var bannerImageView: UIImageView!
    @IBOutlet private weak var movieNameLabel: UILabel!
    @IBOutlet private weak var taglineLabel: UILabel!
    @IBOutlet private weak var releaseDateView: UIView!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var ratingView: UIView!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var overviewHeadingLabel: UILabel!
    @IBOutlet private weak var overviewLabel: UILabel!
    var viewModel: MovieDetailViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        
        loadData()
        viewModel.fetchDetail()
    }
    
    private func loadData() {
        let movie = viewModel.movie
        navigationItem.title = movie.title ?? "Detail"
        movieNameLabel.text = movie.title
        taglineLabel.text = movie.tagline
        overviewLabel.text = movie.overview
        
        if let releaseDate = movie.releaseDate {
            releaseDateView.isHidden = false
            releaseDateLabel.text = releaseDate.toDate(dateFormat: .yyyyMMdd)?.toString(dateFormat: .ddMMMyyyy)
        } else {
            releaseDateView.isHidden = true
        }
        
        if let rating = movie.rating {
            ratingView.isHidden = false
            ratingLabel.text = "\(String(format: "%.1f", rating))/10"
        } else {
            ratingView.isHidden = true
        }
        
        if let banner = movie.banner {
            bannerImageView.kf.setImage(with: URL(string: banner))
        }
    }
    
}
// MARK: - MovieDetailViewModelDelegate
extension MovieDetailViewController: MovieDetailViewModelDelegate {
    func dataLoaded() {
        DispatchQueue.main.async {
            self.loadData()
        }
    }
    
    func onFailedLoadingData(_ error: Error) {
        DispatchQueue.main.async {
            self.alertPresenter.showErrorMessageAlert(message: error.localizedDescription)
        }
    }
    
    
}
