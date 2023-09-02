//
//  UICollectionView+Extension.swift
//  SwipBox
//
//  Created by Zain Sidhu on 01/09/2023.
//

import UIKit

extension UICollectionViewCell: ReusableView { }

extension UICollectionView {
    func register<T: UICollectionViewCell>(ofType cellClass: T.Type) {
        let cell = UINib(nibName: cellClass.reuseIdentifier, bundle: nil)
        register(cell, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    func dequeue<T: UICollectionViewCell>(ofType cellClass: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: cellClass.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Error: cell with id: \(cellClass.reuseIdentifier) is not \(T.self)")
        }
        
        return cell
    }
    
    private var loadingViewTag: Int { return 9999 }
    
    func showLoadingIndicator() {
        let indicatorView = UIActivityIndicatorView(style: .large)
        indicatorView.startAnimating()
        
        addSubview(indicatorView)
        
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        indicatorView.tag = loadingViewTag
        
        isUserInteractionEnabled = false
    }
    
    func hideLoadingIndicator() {
        if let indicatorView = viewWithTag(loadingViewTag) as? UIActivityIndicatorView {
            indicatorView.removeFromSuperview()
        }
        isUserInteractionEnabled = true
    }
}
