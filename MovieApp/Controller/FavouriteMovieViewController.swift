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
    let realmStorage = RealmStorage()
    var favouriteMovies: Results<FavouriteMovie>?
    @IBOutlet weak var tableView: UITableView?
    
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
            self.tableView?.reloadData()
        }
    }
    
    func getSpecificDataNeededToPopulateFavoriteMovieList(posterImageData: String, savedMovieInformationList: List<FavMovieInformation>) -> SavedMovie {
        //        convert realm movie object to table view cell object to populate the table view on list page
        var title = ""; var year = ""; var type = ""
        for movieInformation in savedMovieInformationList {
            if movieInformation.header == "Title" {
                title = movieInformation.content ?? ""
            }
            if movieInformation.header == "Type" {
                type = movieInformation.content ?? ""
            }
            if movieInformation.header == "Year" {
                year = movieInformation.content ?? ""
            }
            if movieInformation.header == "ImdbID" {
                movieID = movieInformation.content ?? ""
            }
        }
        return SavedMovie(poster: posterImageData, title: title, type: type, year: year)
    }
    
    func convertRealmDataToTableViewCellDataForMovieDetailsList(favoriteMovieInformationList: List<FavMovieInformation>) -> [DetailsCell] {
        //        convert realm movie object to table view cell object to populate the table view on details page
        var movieInformationArray = [DetailsCell]()
        for movieInformation in favoriteMovieInformationList {
            movieInformationArray.append(DetailsCell(header: movieInformation.header ?? "", description: movieInformation.content ?? ""))
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
            let movie = favouriteMovies?[indexPath.row].favMovieInformationList
            let movieListData = getSpecificDataNeededToPopulateFavoriteMovieList(posterImageData: favouriteMovies?[indexPath.row].poster ?? "", savedMovieInformationList: movie!)
            cell.setupFromRealm(movie: movieListData)
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
        destinationViewController?.posterUrl = favouriteMovies?[indexPath.row].poster
        destinationViewController?.movieInformationArray = convertRealmDataToTableViewCellDataForMovieDetailsList(favoriteMovieInformationList: (favouriteMovies?[indexPath.row].favMovieInformationList)!)
        let movieId = Int(movieID.dropFirst(2)) ?? 0
        destinationViewController?.movieIsAfavorite = realmStorage.movieIsSaved(id: movieId)
        self.navigationController?.pushViewController(destinationViewController ?? DetailsViewController(), animated: true)
    }
}
