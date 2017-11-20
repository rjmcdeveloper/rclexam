//
//  MovieCVCell.swift
//  CONSTANTINOi95TestApp
//
//  Created by Guest User on 19/11/2017.
//  Copyright © 2017 Rj Constantino. All rights reserved.
//

import UIKit

protocol MovieCVCellDelegate {
    func didTappedFavorite(cell: MovieCVCell)
}

class MovieCVCell: UICollectionViewCell {
    
    @IBOutlet weak var moviePhoto: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var detailsContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    var delegate: MovieCVCellDelegate?
    
    @IBOutlet weak var favoriteLeftConstraint: NSLayoutConstraint!
    @IBAction func favoriteAction(_ sender: UIButton) {
        delegate?.didTappedFavorite(cell: self)
    }
}

