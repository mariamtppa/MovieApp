//
//  MovieDetailStruct.swift
//  MovieApp
//
//  Created by Mariam Busayo Abdulkareem on 05/12/2021.
//

import Foundation
import Realm

struct MovieDetail: Codable {
    let title, year, rated, released: String
    let runtime, genre, director, writer: String
    let actors, plot, language, country: String
    let awards: String
    let poster: String
    let ratings: [Rating]
    let metascore, imdbRating, imdbVotes, imdbID: String
    let type, dvd, boxOffice, production: String
    let website, response: String
    var dictionary: [String: Any] {
        return ["Title": title,
                "Year": year,
                "Rated": rated,
                "Released": released,
                "Runtime": runtime,
                "Genre": genre,
                "Director": director,
                "Writer": writer,
                "Actors": actors,
                "Plot": plot,
                "Language": language,
                "Country": country,
                "Awards": awards,
                "Ratings": ratings,
                "Metascore": metascore,
                "ImdbRating": imdbRating,
                "ImdbVotes": imdbVotes,
                "ImdbID": imdbID,
                "Type": type,
                "Dvd": dvd,
                "BoxOffice": boxOffice,
                "Production": production,
                "Website": website
        ]
    }
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case country = "Country"
        case awards = "Awards"
        case poster = "Poster"
        case ratings = "Ratings"
        case metascore = "Metascore"
        case imdbRating, imdbVotes, imdbID
        case type = "Type"
        case dvd = "DVD"
        case boxOffice = "BoxOffice"
        case production = "Production"
        case website = "Website"
        case response = "Response"
    }
}

struct Rating: Codable {
    let source, value: String
    
    enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
}

class DetailsCell {
    var header: String
    var description : String
    
    init(header: String, description: String) {
        self.header = header
        self.description = description
    }
}
