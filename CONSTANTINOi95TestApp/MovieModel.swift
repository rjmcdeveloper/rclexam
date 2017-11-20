//
//  MovieModel.swift
//  CONSTANTINOi95TestApp
//
//  Created by Guest User on 19/11/2017.
//  Copyright © 2017 Rj Constantino. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData

struct MovieDetail {
    
    var artworkUrl100: String!
    var contentAdvisoryRating: String!
    var longDescription: String!
    var previewUrl: String!
    var primaryGenreName: String!
    var releaseDate: String!
    var shortDescriptionU: String!
    var trackId: Int!
    var trackName: String!
    var trackViewUrl: String!
    
    init(artworkUrl100: String, contentAdvisoryRating: String, longDescription: String, previewUrl: String, primaryGenreName: String, releaseDate: String, shortDescriptionU: String, trackId: Int, trackName: String, trackViewUrl: String) {

        self.artworkUrl100 = artworkUrl100
        self.contentAdvisoryRating = contentAdvisoryRating
        self.longDescription = longDescription
        self.previewUrl = previewUrl
        self.primaryGenreName = primaryGenreName
        self.releaseDate = releaseDate
        self.shortDescriptionU = shortDescriptionU
        self.trackId = trackId
        self.trackName = trackName
        self.trackViewUrl = trackViewUrl
    }

    init(json: JSON) {

        artworkUrl100 = json["artworkUrl100"].stringValue
        contentAdvisoryRating = json["contentAdvisoryRating"].stringValue
        longDescription = json["longDescription"].stringValue
        previewUrl = json["previewUrl"].stringValue
        primaryGenreName = json["primaryGenreName"].stringValue
        releaseDate = json["releaseDate"].stringValue
        shortDescriptionU = json["shortDescription"].stringValue
        trackId = json["trackId"].int
        trackName = json["trackName"].stringValue
        trackViewUrl = json["trackViewUrl"].stringValue
    }
    
    init(data: NSManagedObject) {
        
        artworkUrl100 = data.value(forKey: "artworkUrl100") as! String!
        contentAdvisoryRating = data.value(forKey: "contentAdvisoryRating") as! String!
        longDescription = data.value(forKey: "longDescription") as! String!
        previewUrl = data.value(forKey: "previewUrl") as! String!
        primaryGenreName = data.value(forKey: "primaryGenreName") as! String!
        releaseDate = data.value(forKey: "releaseDate") as! String!
        shortDescriptionU = data.value(forKey: "shortDescriptionU") as! String!
        trackId = data.value(forKey: "trackId") as! Int!
        trackName = data.value(forKey: "trackName") as! String!
        trackViewUrl = data.value(forKey: "trackViewUrl") as! String!
    }
}
