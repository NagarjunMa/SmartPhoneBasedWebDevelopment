//
//  Service.swift
//  AssignmentSeven
//
//  Created by Nagarjun Mallesh on 05/03/24.
//

import Foundation

class Artist {
    var id: Int
    var name: String
    
    init(id: Int, name:String) {
        self.id = id
        self.name = name
    }
}


class Album {
    var id: Int
    var artistId: Int
    var title: String
    var releaseDate: String
    var songs: [Song] = []
    
    init(id: Int, artistId: Int, title: String, releaseDate: String) {
        self.id = id
        self.artistId = artistId
        self.title = title
        self.releaseDate = releaseDate
    }
}

class Song {
    var id: Int
    var artistId: Int
    var albumId: Int
    var genreId: Int
    var title: String
    var duration: Double
    var favorite: Bool
    
    init(id: Int, artistId: Int, albumId: Int, genreId: Int, title: String, duration: Double, favorite: Bool) {
        self.id = id
        self.artistId = artistId
        self.albumId = albumId
        self.genreId = genreId
        self.title = title
        self.duration = duration
        self.favorite = favorite
    }
    
}

class Genre {
    var id: Int
    var name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
}



