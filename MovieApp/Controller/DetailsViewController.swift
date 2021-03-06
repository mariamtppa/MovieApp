//
//  DetailsViewController.swift
//  MovieApp
//
//  Created by Mariam Busayo Abdulkareem on 05/12/2021.
//

import UIKit

enum PopulateDataFrom {
    case realm
    case api
}

class DetailsViewController: UIViewController {
        
    var movieId: String?
    var posterUrl: String?
    var movieIsAfavorite = false
    let realmStorage = RealmStorage()
    var populateDataFrom: PopulateDataFrom?
    let loadMoviesDetails = MovieListLoader()
    var movieInformationArray = [DetailsCell]()
    @IBOutlet weak var poster: UIImageView?
    @IBOutlet weak var favouriteButton: UIButton?
    @IBOutlet weak var tableView: UITableView?
    
    @IBAction func favouriteButtonAction(_ sender: Any) {
//        on click of button, if movie was liked, unlike movie i.e change heart fill icon to empty heart icon, then remove that movie from the offline storage(realm) else like movie and change icon t heart fill and add the movie to realm
        if movieIsAfavorite == true {
            favouriteButton?.setImage(UIImage(systemName: "suit.heart"), for: .normal)
            movieIsAfavorite = false
            deleteFromRealm()
        } else {
            favouriteButton?.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
            movieIsAfavorite = true
            saveToRealm()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        registerTableViewCell()
        loadMoviesDetails.movieDetailDelegate = self
        initialSetup()
    }
    
    func initialSetup() {
//        if movie is saved, show a heart filled icon else show an empty heart icon. Also populate the different data from realm and api
        if movieIsAfavorite == true {
            favouriteButton?.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
        } else { favouriteButton?.setImage(UIImage(systemName: "suit.heart"), for: .normal) }
        if populateDataFrom == PopulateDataFrom.api {
            loadMoviesDetails.getMovieDetails(id: movieId ?? "")
        }
        poster?.downloaded(from: posterUrl ?? "")
    }
    
    private func registerTableViewCell() {
        let menuCell = UINib(nibName: "MovieDetailsTableViewCell", bundle: nil)
        self.tableView?.register(menuCell, forCellReuseIdentifier: "MovieDetailsTableViewCell")
    }
    
    func populateTableView(movieDetails: [String: Any]) {
//        converts api fetched data from an array of [String: Any] to an array of table view cell struct to populate the table view and reloads table view after
        for movieDetail in movieDetails {
            var description = ""
            if movieDetail.key == "Ratings" {
                let ratings = movieDetail.value as? [Rating]
                for rating in 0..<ratings!.count {
                    description += "\(ratings?[rating].source ?? "" ) : \(ratings?[rating].value ?? "")\n"
                }
            } else {
                description = movieDetail.value as? String ?? ""
            }
            let movieInformation = DetailsCell(header: movieDetail.key, description: description)
            movieInformationArray.append(movieInformation)
        }
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }
    
    func saveToRealm() {
//        converts movie object to realm object, uses imdbID as primary key for database query ease then add list of favorite movies to realm and updates favorite list
        let favoriteMovie = FavouriteMovie()
        favoriteMovie.poster = posterUrl
        favoriteMovie.id = Int(movieId?.dropFirst(2) ?? Substring()) ?? 0
        for i in 0..<movieInformationArray.count {
            let movieInformation = FavMovieInformation()
            movieInformation.header = movieInformationArray[i].header
            movieInformation.content = movieInformationArray[i].description
            favoriteMovie.favMovieInformationList.append(movieInformation)
        }
        realmStorage.addAfavoriteMovie(obj: favoriteMovie, id: favoriteMovie.id)
    }
    
    func deleteFromRealm() {
//        deletes favorite movie from realm and updates favorite list
        realmStorage.deleteAfavoriteMovie(id: Int(movieId?.dropFirst(2) ?? Substring()) ?? 0)
    }
}

extension DetailsViewController: GetMovieDetails {
//    get the movie information data used to populate the table view from the api
    func getMovieDetail(value: [String : Any]) {
        populateTableView(movieDetails: value)
    }
}

extension DetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension DetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieInformationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MovieDetailsTableViewCell", for: indexPath) as? MovieDetailsTableViewCell {
            cell.setup(movieInformation: movieInformationArray[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}
