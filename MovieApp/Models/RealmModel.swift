//
//  RealmModel.swift
//  MovieApp
//
//  Created by Mariam Busayo Abdulkareem on 05/12/2021.
//

import Foundation
import RealmSwift

class FavouriteMovie: Object {
    @objc dynamic var id = 0
    let fav = true
    let movieInfo = List<FavMovie>()
    @objc dynamic var picture: Data? = nil
    override static func primaryKey() -> String? {
        return "id"
    }
}

class FavMovie: Object {
    @objc dynamic var header: String?
    @objc dynamic var content: String?
}
