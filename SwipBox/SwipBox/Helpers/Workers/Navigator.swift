//
//  Navigator.swift
//  SwipBox
//
//  Created by Zain Sidhu on 01/09/2023.
//

import UIKit

enum Route {
    case movieDetail(MovieProtocol)
}

final class Navigator {
    
    private weak var viewController: UIViewController!
    
    init(_ viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func navigate(_ route: Route) {
        switch route {
        case .movieDetail(let movieDetail):
            redirectToMovieDetail(movieDetail)
        }
    }
    
    private func redirectToMovieDetail(_ movieDetail: MovieProtocol) {
        let controller = UIStoryboard.main.instantiateViewController(ofType: MovieDetailViewController.self)
        controller.viewModel = MovieDetailViewModel(movie: movieDetail)
        viewController.navigationController?.pushViewController(controller, animated: true)
    }
    
}
