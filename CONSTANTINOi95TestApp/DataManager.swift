//
//  DataManager.swift
//  CONSTANTINOi95TestApp
//
//  Created by Guest User on 19/11/2017.
//  Copyright © 2017 Rj Constantino. All rights reserved.
//

import UIKit
import CoreData

class DataManager: NSObject {
    
    static let favoriteEntity = "Favorite"
    
    class func core() -> (manageContext: NSManagedObjectContext, entity: NSEntityDescription) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let manageContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: favoriteEntity, in: manageContext)
        
        return (manageContext, entity!)
    }
    
    class func add(movie: MovieDetail) {

        let model = NSManagedObject(entity: core().entity, insertInto: core().manageContext)
        model.setValue(movie.trackId, forKey: "trackId")
        model.setValue(movie.trackName, forKey: "trackName")
        model.setValue(movie.artworkUrl100, forKey: "artworkUrl100")
        model.setValue(movie.contentAdvisoryRating, forKey: "contentAdvisoryRating")
        model.setValue(movie.shortDescriptionU, forKey: "shortDescriptionU")
        model.setValue(movie.longDescription, forKey: "longDescription")
        model.setValue(movie.previewUrl, forKey: "previewUrl")
        model.setValue(movie.trackViewUrl, forKey: "trackViewUrl")
        model.setValue(movie.releaseDate, forKey: "releaseDate")
        model.setValue(movie.primaryGenreName, forKey: "primaryGenreName")
        
        do {
            try core().manageContext.save()
        } catch let error as NSError {
            print("something went wrong here: \(error.userInfo)")
        }
    }
    
    class func fetchData(id: Int = -1) -> [NSManagedObject] {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: favoriteEntity)
        
        if id != -1 {
            fetchRequest.predicate = NSPredicate(format: "trackId = %d", id)
        }
        
        do {
            return try core().manageContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("something went wrong here: \(error.userInfo)")
        }
        
        return [NSManagedObject]()
    }

    class func deleteMovie(withId trackId: Int) {
        core().manageContext.delete(fetchData(id: trackId)[0] as NSManagedObject)
        do {
            try core().manageContext.save()
        } catch let error as NSError {
            print("something went wrong here: \(error.userInfo)")
        }
    }
    
    class func movieAlreadyExist(withID id: Int) -> Bool {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: favoriteEntity)
        fetchRequest.predicate = NSPredicate(format: "trackId = %d", id)

        var results: [NSManagedObject] = []
        
        do {
            results = try core().manageContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("something went wrong here: \(error.userInfo)")
        }
        
        return results.count != 0 ? true : false
    }
    
}
