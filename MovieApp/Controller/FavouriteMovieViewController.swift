//
//  FavouriteMovieViewController.swift
//  MovieApp
//
//  Created by Mariam Busayo Abdulkareem on 05/12/2021.
//

import UIKit
import RealmSwift

class FavouriteMovieViewController: UIViewController {
    
    var movieID = ""
    var selectedMovie: SavedMovie?
    let realmStorage = RealmStorage()
    var favouriteMovies: Results<FavouriteMovie>?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title =  "Favorite Movies"
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        registerTableViewCell()
        favouriteMovies = RealmStorage().retrieveFavoriteMovies()
    }
    
    private func registerTableViewCell() {
        let menuCell = UINib(nibName: "MovieListTableViewCell",
                             bundle: nil)
        self.tableView?.register(menuCell, forCellReuseIdentifier: "FavoriteMovieTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        favouriteMovies = RealmStorage().retrieveFavoriteMovies()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func getDataToPopulateList(imageData: Data, infoList: List<FavMovie>) -> SavedMovie {
        //        convert realm movie object to table view cell object to populate the table view on list page
        var title = ""; var year = ""; var type = ""
        for fav in infoList {
            if fav.header == "Title" {
                title = fav.content ?? ""
            }
            if fav.header == "Type" {
                type = fav.content ?? ""
            }
            if fav.header == "Year" {
                year = fav.content ?? ""
            }
            if fav.header == "ImdbID" {
                movieID = fav.content ?? ""
            }
        }
        return SavedMovie(image: imageData, title: title, type: type, year: year)
    }
    
    func convertRealmDataToTableViewCellData(movieList: List<FavMovie>) -> [DetailsCell] {
        //        convert realm movie object to table view cell object to populate the table view on details page
        var movieInformationArray = [DetailsCell]()
        for movie in movieList {
            movieInformationArray.append(DetailsCell(header: movie.header ?? "", description: movie.content ?? ""))
        }
        return movieInformationArray
    }
}

extension FavouriteMovieViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension FavouriteMovieViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteMovies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteMovieTableViewCell", for: indexPath) as? MovieListTableViewCell {
            let movie = favouriteMovies?[indexPath.row].movieInfo
            selectedMovie = getDataToPopulateList(imageData: favouriteMovies?[indexPath.row].picture ?? Data(), infoList: movie!)
            cell.setupFromRealm(movie: selectedMovie!)
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationViewController = storyBoard.instantiateViewController(withIdentifier: "DetailsScreen") as? DetailsViewController
        destinationViewController?.movieId = movieID
        destinationViewController?.populateDataFrom = .realm
        destinationViewController?.posterImageData = favouriteMovies?[indexPath.row].picture
        destinationViewController?.movieInformationArray = convertRealmDataToTableViewCellData(movieList: (favouriteMovies?[indexPath.row].movieInfo)!)
        let id = Int(movieID.dropFirst(2)) ?? 0
        destinationViewController?.favorite = realmStorage.movieIsSaved(id: id)
        self.navigationController?.pushViewController(destinationViewController ?? DetailsViewController(), animated: true)
    }
}
