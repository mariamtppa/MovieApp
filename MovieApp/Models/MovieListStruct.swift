//
//  MovieListStruct.swift
//  MovieApp
//
//  Created by Mariam Busayo Abdulkareem on 05/12/2021.
//

import Foundation

struct MovieList: Codable {
    let movies: [Movie]?
    let error: String?
    let totalResults: String?
    let response: String?

    enum CodingKeys: String, CodingKey {
        case movies = "Search"
        case totalResults, error
        case response = "Response"
    }
}

struct Movie: Codable {
    let title, year, imdbID: String
    let type: TypeEnum
    let poster: String

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}

struct SavedMovie {
    var poster: Data
    var title: String
    var type: String
    var year: String
}

enum TypeEnum: String, Codable {
    case movie = "movie"
    case series = "series"
}

struct ApiCallError: Codable {
    var response: String
    var error: String
    
    enum CodingKeys: String, CodingKey {
        case response = "Response"
        case error = "Error"
    }
}
