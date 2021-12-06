//
//  MovieDetailsTableViewCell.swift
//  MovieApp
//
//  Created by Mariam Busayo Abdulkareem on 05/12/2021.
//

import UIKit

class MovieDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var header: UILabel?
    @IBOutlet weak var content: UILabel?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(movieInformation: DetailsCell) {
        //       assigns values to the table view cell components to populate the movie txt information(excluding the image)
        header?.text = movieInformation.header
        content?.text = movieInformation.description
    }
}
