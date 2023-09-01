//
//  MovieListCollectionViewCell.swift
//  SwipBox
//
//  Created by Zain Sidhu on 01/09/2023.
//

import UIKit
import Kingfisher

final class MovieListCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var movieImageView: UIImageView!
    
    var movie: MovieProtocol? {
        didSet {
            guard let movie else { return }
            
            if let poster = movie.poster {
                movieImageView.kf.setImage(with: URL(string: poster))
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 10
        movieImageView.backgroundColor = .lightGray
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
