//
//  Models.swift
//  AssignmentNine
//
//  Created by Nagarjun Mallesh on 24/03/24.
//

import Foundation


class Artist: Codable {
    var id: Int
    var name: String
    
    enum CodingKeys: String, CodingKey {
            case id, name
        }

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            name = try container.decode(String.self, forKey: .name)
            
            // Decode the id as a String and then try to convert it to an Int
            let idString = try container.decode(String.self, forKey: .id)
            guard let idInt = Int(idString) else {
                throw DecodingError.dataCorruptedError(forKey: .id, in: container, debugDescription: "ID is not convertible to Int")
            }
            id = idInt
        }

        // If you also need to encode back to JSON and keep the id as a string in JSON, implement the encode(to:) method
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
            try container.encode(String(id), forKey: .id) // Encode id as String in JSON
        }
    
    init(id: Int, name:String) {
        self.id = id
        self.name = name
    }
}



class Album: Codable {
    var id: Int
    var artistId: Int
    var title: String
    var releaseDate: String
    var songs: [Song] = []
    
    

    
    
    enum CodingKeys: String, CodingKey {
        case id, artistId = "artist_id", title, releaseDate = "released_date", songs
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Decode 'id' as a String first, then convert to Int
        let idString = try container.decode(String.self, forKey: .id)
        guard let idInt = Int(idString) else {
            throw DecodingError.dataCorruptedError(forKey: .id, in: container,
                                                   debugDescription: "The value couldn'e be decoded")
        }
        id = idInt
        
        // Decoding 'artistId' as String and then converting to Int
            let artistIdString = try container.decode(String.self, forKey: .artistId)
            guard let artistIdInt = Int(artistIdString) else {
                throw DecodingError.dataCorruptedError(forKey: .artistId, in: container,
                                                       debugDescription: "Artist ID is not convertible to Int")
            }
            artistId = artistIdInt
            
            // Decode other properties directly as their expected types
            title = try container.decode(String.self, forKey: .title)
            releaseDate = try container.decode(String.self, forKey: .releaseDate)
            songs = try container.decodeIfPresent([Song].self, forKey: .songs) ?? []
        

    }
    
    init(id: Int, artistId: Int, title: String, releaseDate: String) {
        self.id = id
        self.artistId = artistId
        self.title = title
        self.releaseDate = releaseDate
    }
    
    
    
    
}



class Song : Codable {
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
