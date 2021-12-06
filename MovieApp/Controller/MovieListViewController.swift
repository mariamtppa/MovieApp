//
//  ViewController.swift
//  MovieApp
//
//  Created by Mariam Busayo Abdulkareem on 04/12/2021.
//

import UIKit
import Foundation

class MovieListViewController: UIViewController, UISearchBarDelegate {
    
    var movieList: [Movie]?
    let realmStorage = RealmStorage()
    let loadMovies = MovieListLoader()
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title =  "Movie App"
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        searchField?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        registerTableViewCell()
        loadMovies.movieListDelegate = self
        loadMovies.getMovies(movieName: "batman")
    }
    
    private func registerTableViewCell() {
        //register the table view cell
        let menuCell = UINib(nibName: "MovieListTableViewCell", bundle: nil)
        self.tableView?.register(menuCell, forCellReuseIdentifier: "MovieListTableViewCell")
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        loadMovies.getMovies(movieName: searchField.text ?? "")
    }
}

extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListTableViewCell", for: indexPath) as? MovieListTableViewCell {
            cell.setup(movie: (movieList?[indexPath.row])!)
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationViewController = storyBoard.instantiateViewController(withIdentifier: "DetailsScreen") as? DetailsViewController
        destinationViewController?.movieId = movieList?[indexPath.row].imdbID ?? ""
        let movieIsInRealm = movieList?[indexPath.row]
        let id = Int(movieIsInRealm?.imdbID.dropFirst(2) ?? Substring()) ?? 0
        destinationViewController?.favorite = realmStorage.movieIsSaved(id: id)
        destinationViewController?.posterUrl = movieList?[indexPath.row].poster ?? ""
        destinationViewController?.populateDataFrom = .api
        self.navigationController?.pushViewController(destinationViewController ?? DetailsViewController(), animated: true)
    }
}

extension MovieListViewController: GetMovieList {
    //gets the list of movies after the api call and populates the table view with it
    func getMovieList(value: [Movie]?) {
        self.movieList = value
        //reload table view only when there is a search result
        if self.movieList != nil {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
