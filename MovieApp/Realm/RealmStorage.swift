//
//  RealmStorage.swift
//  MovieApp
//
//  Created by Mariam Busayo Abdulkareem on 05/12/2021.
//

import Foundation
import UIKit
import RealmSwift

class RealmStorage {
    
    let realm = try! Realm()
    
    func addAfavoriteMovie(obj: FavouriteMovie, id: Int) {
        // Write to Realm
        print("Write to Realm")
        if realm.object(ofType: FavouriteMovie.self, forPrimaryKey: id) == nil {
            try! self.realm.write {
                self.realm.refresh()
                self.realm.add(obj)
            }
        }
    }
    
    func retrieveFavoriteMovies() -> Results<FavouriteMovie> {
        // Read from Realm
        print("Read from Realm")
        let data = realm.objects(FavouriteMovie.self)
        return data
    }
    
    func deleteAfavoriteMovie(id: Int) {
        // Delete data
        if realm.object(ofType: FavouriteMovie.self, forPrimaryKey: id) != nil {
            print("Delete Data")
            let movieToDelete = self.realm.objects(FavouriteMovie.self).filter("id = \(id)")
            try! self.realm.write {
                self.realm.refresh()
                self.realm.delete(movieToDelete)
            }
        }
    }
    
    func movieIsSaved(id: Int) -> Bool {
//    does object exist
        return realm.object(ofType: FavouriteMovie.self, forPrimaryKey: id) != nil
    }
}
