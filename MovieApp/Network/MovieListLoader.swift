//
//  MovieListLoader.swift
//  MovieApp
//
//  Created by Mariam Busayo Abdulkareem on 05/12/2021.
//

import Foundation

class MovieListLoader {
    var movieListDelegate: GetMovieList?
    var movieDetailDelegate: GetMovieDetails?
    
    func getMovies(movieName: String) {
//        api call to get the brief movie information displayed in the list
        let url = "https://www.omdbapi.com/?S=\(movieName)&apikey=b8acaf2f"
        let defaultUrl = "https://www.omdbapi.com/?S=batman)&apikey=b8acaf2f"
        let task = URLSession.shared.dataTask(with: (URL(string: url) ?? URL(string: defaultUrl))!, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            
            var results: MovieList?
            do {
                results = try JSONDecoder().decode(MovieList.self, from: data)
            }
            catch {
                print("failed to convert \(error.localizedDescription)")
            }
            
            guard let json = results else {
                return
            }
            let movieList = json.movies
            self.movieListDelegate?.getMovieList(value: movieList)
        })
        task.resume()
    }
    
    func getMovieDetails(id: String) {
        //        api call to get the full movie information displayed on details screen
        let url = "https://www.omdbapi.com/?i=\(id)&apikey=b8acaf2f"
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            
            var results: MovieDetail?
            do {
                results = try JSONDecoder().decode(MovieDetail.self, from: data)
            }
            catch {
                print("failed to convert \(error.localizedDescription)")
            }
            
            guard let json = results else {
                return
            }
            self.movieDetailDelegate?.getMovieDetail(value: json.dictionary)
        })
        task.resume()
    }
}
