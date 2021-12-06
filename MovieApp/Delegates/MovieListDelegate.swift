//
//  MovieListDelegate.swift
//  MovieApp
//
//  Created by Mariam Busayo Abdulkareem on 05/12/2021.
//

import Foundation

//protocols to pass movie fetched from api by network class to the screen where the data is needed
protocol GetMovieList {
    func getMovieList(value: [Movie]?)
}

protocol GetMovieDetails {
    func getMovieDetail(value: [String: Any])
}

