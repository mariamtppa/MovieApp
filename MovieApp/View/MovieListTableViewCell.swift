//
//  MovieListTableViewCell.swift
//  MovieApp
//
//  Created by Mariam Busayo Abdulkareem on 05/12/2021.
//

import UIKit

class MovieListTableViewCell: UITableViewCell {
    @IBOutlet weak var poster: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var yearLabel: UILabel?
    @IBOutlet weak var typeLabel: UILabel?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(movie: Movie) {
//       assigns values to the table view cell components from data gotten from api
        poster?.downloaded(from: movie.poster)
        titleLabel?.text = movie.title
        yearLabel?.text = movie.year
        typeLabel?.text = movie.type.rawValue
    }
    
    func setupFromRealm(movie: SavedMovie) {
        //       assigns values to the table view cell components from data gotten retrived from realm
        poster?.image = UIImage(data: movie.poster)
        titleLabel?.text = movie.title
        yearLabel?.text = movie.year
        typeLabel?.text = movie.type
    }
}

