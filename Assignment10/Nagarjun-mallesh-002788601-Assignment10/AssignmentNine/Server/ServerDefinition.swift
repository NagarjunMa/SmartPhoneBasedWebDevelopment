//
//  ServerDefinition.swift
//  AssignmentNine
//
//  Created by Nagarjun Mallesh on 24/03/24.
//

import Foundation
import SQLite3


class ArtistService {
    static let shared = ArtistService()
    private var db: OpaquePointer?
    private init() {
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("/AssingmentNine.sqlite3")
                
                // Open the database
                if sqlite3_open(path, &db) != SQLITE_OK {
                    print("Unable to open database.")
                    return
                }
                
                // Create the Artists table if it doesn't exist
                if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Artists (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL)", nil, nil, nil) != SQLITE_OK {
                    print("Unable to create table.")
                    return
                }
    }
    
    deinit {
        sqlite3_close(db)
    }
    
    var artists: [Artist] = []
    
    func addArtist(_ artist: Artist) {
//        artists.append(artist)
        let insertStatementString = "INSERT INTO Artists (name) VALUES (?);"
        var insertStatement: OpaquePointer?
        
        // Prepare the insertion statement
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            // Bind the artist name to the statement
            sqlite3_bind_text(insertStatement, 1, (artist.name as NSString).utf8String, -1, nil)
            
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted artist")
            } else {
                print("Could not insert artist.")
            }
            
            sqlite3_finalize(insertStatement)
        }else {
            print("INSERT Statement could not be prepared")
        }
        
        
    }
    
    func artistExists(artistId: Int) -> Bool {
        let queryStatementString = "SELECT * FROM Artists WHERE id = ?;"
        var queryStatement: OpaquePointer?
        
        //Prepare the query statement
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(queryStatement, 1, Int32(artistId))
            
            let result = sqlite3_step(queryStatement)
            sqlite3_finalize(queryStatement)
            return result == SQLITE_ROW
        } else {
                print("SELECT Statement could not prepared.")
        }
        
        return false
    }
    
    
    func checkAlbumsinArtist(artistId : Int) -> Int {
        let checkSongsStatementString = "SELECT COUNT(*) FROM Albums WHERE artistId = ?;"
        var checkSongsStatement: OpaquePointer? = nil
        var songCount = 0
        
        if sqlite3_prepare_v2(db, checkSongsStatementString, -1, &checkSongsStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(checkSongsStatement, 1, Int32(artistId))
            
            if sqlite3_step(checkSongsStatement) == SQLITE_ROW {
                songCount = Int(sqlite3_column_int(checkSongsStatement, 0))
            } else {
                print("Could not retrieve song count for genre.")
            }
        } else {
            print("CHECK SONGS statement could not be prepared.")
        }
        sqlite3_finalize(checkSongsStatement)
        return songCount
    }
    
    func artistDelete(artistId: Int) -> Bool {
        
        let deleteStatementString = "DELETE FROM Artists WHERE id = ?;"
               var deleteStatement: OpaquePointer? = nil
               if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
                   sqlite3_bind_int(deleteStatement, 1, Int32(artistId))
                   
                   if sqlite3_step(deleteStatement) == SQLITE_DONE {
                       print("Successfully deleted row.")
                       return true
                   } else {
                       print("Could not delete row.")
                   }
               } else {
                   print("DELETE statement could not be prepared")
               }
               sqlite3_finalize(deleteStatement)
               return false
    }
    
    
    func artistDisplay() -> [Artist] {
        let queryStatementString = "SELECT * FROM Artists;"
        var queryStatement: OpaquePointer? = nil
        var result = [Artist]()
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil ) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(queryStatement, 0))
                guard let queryResultCol1 = sqlite3_column_text(queryStatement, 1) else {
                    print("Query Result is nil.")
                    continue
                }
                let name = String(cString: queryResultCol1)
                let artist = Artist(id: id, name: name)
                result.append(artist)
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return result
    }
    
    func updateArtistName(artistId: Int, newName: String) {
        let updateStatementString = "UPDATE Artists SET name = ? WHERE id = ?;"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, (newName as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 2, Int32(artistId))
            
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }
    
    func canDeleteArtist(artistId: Int) -> Bool {
        
        return !AlbumService.shared.albums.contains(where: {$0.artistId == artistId})
    }
    
    
    
    func checkArtists(artistId : Int) -> Int {
        let checkArtistString = "SELECT COUNT(*) FROM Artists WHERE artistId = ?;"
        var checkArtist: OpaquePointer? = nil
        var artistCount = 0
        
        if sqlite3_prepare_v2(db,checkArtistString,-1,&checkArtist, nil) == SQLITE_OK {
            sqlite3_bind_int(checkArtist,1 , Int32(artistId))
            
            if sqlite3_step(checkArtist) == SQLITE_ROW {
                artistCount = Int(sqlite3_column_int(checkArtist, 0))
            } else {
                print("Could not retrieve artist count.")
            }
        }else{
            print("CHECK artist statement could not be prepared")
        }
        sqlite3_finalize(checkArtist)
        return artistCount
    }
    
    
    func findArtistByName(artistName: String) -> String {
        let queryStatementString = "SELECT * FROM Artists WHERE name LIKE ?;"
            var queryStatement: OpaquePointer? = nil
            var result = ""

            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                // Binding the name parameter to the SQL query, '%' characters allow for partial matching
                let searchString = "%\(artistName)%"
                sqlite3_bind_text(queryStatement, 1, (searchString as NSString).utf8String, -1, nil)
                
                // Iterating over each row in the result set
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    let id = sqlite3_column_int(queryStatement, 0)
                    guard let queryResultCol1 = sqlite3_column_text(queryStatement, 1) else {
                        print("Query result is nil.")
                        continue
                    }
                    let name = String(cString: queryResultCol1)
                    result += "ID: \(id), Name: \(name)\n"
                }
            } else {
                print("SELECT statement for finding by name could not be prepared")
            }
            sqlite3_finalize(queryStatement)
            return result
    }
    
}

class AlbumService {
    static let shared = AlbumService()
    private var db: OpaquePointer?
    private init() {
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("/AssignmentNine.sqlite3")
                
                // Open the database
                if sqlite3_open(path, &db) != SQLITE_OK {
                    print("Unable to open database.")
                    return
                }
                
                // Create the Artists table if it doesn't exist
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Albums ( id INTEGER PRIMARY KEY AUTOINCREMENT,artistId INTEGER,title TEXT NOT NULL,releaseDate TEXT NOT NULL,FOREIGN KEY(artistId) REFERENCES Artists(id) ON DELETE RESTRICT)", nil, nil,nil) != SQLITE_OK {
                    print("Unable to create table.")
                    return
                }
    }
    
    var albums: [Album] = []
    
    
    deinit {
        sqlite3_close(db)
    }
    
    
    func isValidReleaseDate(_ dateString: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"  // Define your date format here.
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let _ = dateFormatter.date(from: dateString) {
            return true  // Valid date format
        } else {
            return false  // Invalid date format
        }
    }
    
    
    func addAlbum(_ album: Album) {
//        albums.append(album)
        


        
        let insertStatementString = "INSERT INTO Albums (artistId, title, releaseDate) VALUES (?, ?, ?);"
               var insertStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error preparing insert: \(errmsg)")
        }
        
               if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                   sqlite3_bind_int(insertStatement, 1, Int32(album.artistId))
                   sqlite3_bind_text(insertStatement, 2, (album.title as NSString).utf8String, -1, nil)
                   sqlite3_bind_text(insertStatement, 3, (album.releaseDate as NSString).utf8String, -1, nil)
                   
                   if sqlite3_step(insertStatement) == SQLITE_DONE {
                       print("Successfully inserted album.")
                   } else {
                       print("Could not insert album.")
                   }
               } else {
                   print("INSERT statement could not be prepared.")
               }
               sqlite3_finalize(insertStatement)
    }
    
    func albumExists(albumId: Int) -> Bool {
        let queryStatementString = "SELECT * FROM Albums WHERE id = ?;"
        var queryStatement: OpaquePointer?
        
        //Prepare the query statement
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(queryStatement, 1, Int32(albumId))
            
            let result = sqlite3_step(queryStatement)
            sqlite3_finalize(queryStatement)
            return result == SQLITE_ROW
        } else {
            print("SELECT Statement could not prepared.")
        }
        
        return false
    }
    
    func albumDelete(albumId: Int)  -> Bool{
        print("inside albumDelte 1 \(albumId)")
        let songCount = SongService.shared.checkSongsInAlbum(albumId: albumId)
        print("inside albumDelte \(songCount)")
            let deleteStatementString = "DELETE FROM Albums WHERE id = ?;"
            var deleteStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
                sqlite3_bind_int(deleteStatement, 1, Int32(albumId))
                if sqlite3_step(deleteStatement) == SQLITE_DONE {
                    print("Successfully deleted album.")
                    return true
                } else {
                    print("Could not delete album.")
                }
            } else {
                print("DELETE statement could not be prepared.")
            }
            sqlite3_finalize(deleteStatement)
            return false
}
    

    
    func albumDisplay() -> [Album] {

        let queryStatementString = "SELECT * FROM Albums;"
        var queryStatement: OpaquePointer? = nil
        var result = [Album]()
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(queryStatement, 0))
                let artistId = Int(sqlite3_column_int(queryStatement, 1))
                guard let queryResultCol2 = sqlite3_column_text(queryStatement, 2),
                      let queryResultCol3 = sqlite3_column_text(queryStatement, 3) else {
                    print("Query result is nil.")
                    continue
                }
                let title = String(cString: queryResultCol2)
                let releaseDate = String(cString: queryResultCol3)
                let album = Album(id: id, artistId: artistId, title: title, releaseDate: releaseDate)
                result.append(album)
            }
        } else {
            print("SELECT statement could not be prepared.")
        }
        sqlite3_finalize(queryStatement)
        return result
    }
    
    
    func updateAlbum(albumId: Int, newAlbumName: String, newRelease: String){
        let updateStatementString = "UPDATE Albums SET title = ?, releaseDate = ? WHERE id = ?;"
                var updateStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
                    sqlite3_bind_text(updateStatement, 1, (newAlbumName as NSString).utf8String, -1, nil)
                    sqlite3_bind_text(updateStatement, 2, (newRelease as NSString).utf8String, -1, nil)
                    sqlite3_bind_int(updateStatement, 3, Int32(albumId))
                    
                    if sqlite3_step(updateStatement) == SQLITE_DONE {
                        print("Successfully updated album.")
                    } else {
                        print("Could not update album.")
                    }
                } else {
                    print("UPDATE statement could not be prepared.")
                }
                sqlite3_finalize(updateStatement)
        
    }
    
    func findAlbumByName(albumName: String) -> String {
        let queryStatementString = "SELECT * FROM Albums WHERE name LIKE ?;"
            var queryStatement: OpaquePointer? = nil
            var result = ""

            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                // Binding the name parameter to the SQL query, '%' characters allow for partial matching
                let searchString = "%\(albumName)%"
                sqlite3_bind_text(queryStatement, 1, (searchString as NSString).utf8String, -1, nil)
                
                // Iterating over each row in the result set
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    let id = sqlite3_column_int(queryStatement, 0)
                    guard let queryResultCol1 = sqlite3_column_text(queryStatement, 1) else {
                        print("Query result is nil.")
                        continue
                    }
                    let name = String(cString: queryResultCol1)
                    result += "ID: \(id), Name: \(name)\n"
                }
            } else {
                print("SELECT statement for finding by name could not be prepared")
            }
            sqlite3_finalize(queryStatement)
            return result
    }
    
    
    
    func checkAlbums(albumId : Int) -> Int {
        let checkAlbumString = "SELECT COUNT(*) FROM Albums WHERE albumId = ?;"
        var checkAlbum: OpaquePointer? = nil
        var albumCount = 0
        
        if sqlite3_prepare_v2(db,checkAlbumString,-1,&checkAlbum, nil) == SQLITE_OK {
            sqlite3_bind_int(checkAlbum,1 , Int32(albumId))
            
            if sqlite3_step(checkAlbum) == SQLITE_ROW {
                albumCount = Int(sqlite3_column_int(checkAlbum, 0))
            } else {
                print("Could not retrieve artist count.")
            }
        }else{
            print("CHECK artist statement could not be prepared")
        }
        sqlite3_finalize(checkAlbum)
        return albumCount
    }
    
}

class GenreService {
    static let shared = GenreService()
    private var db: OpaquePointer?
    private init() {
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("/AssignmentNine.sqlite3")
                
                // Open the database
                if sqlite3_open(path, &db) != SQLITE_OK {
                    print("Unable to open database.")
                    return
                }
                
                // Create the Artists table if it doesn't exist
                if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Genres(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT NOT NULL)", nil, nil,nil) != SQLITE_OK {
                    print("Unable to create table.")
                    return
                }
        
    }
    
    var genres: [Genre] = []
    
    deinit {
        sqlite3_close(db)
    }
    
    
    func addGenre(_ genre: Genre) {
//        genres.append(genre)
        let insertStatementString = "INSERT INTO Genres (name) VALUES (?);"
               var insertStatement: OpaquePointer? = nil
               if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                   sqlite3_bind_text(insertStatement, 1, (genre.name as NSString).utf8String, -1, nil)
                   
                   if sqlite3_step(insertStatement) == SQLITE_DONE {
                       print("Successfully inserted Genre.")
                   } else {
                       print("Could not insert genre.")
                   }
               } else {
                   print("INSERT statement could not be prepared.")
               }
               sqlite3_finalize(insertStatement)
    }
    
    func genreExists(genreId: Int) -> Bool {
        let queryStatementString = "SELECT * FROM Genres WHERE id = ?;"
        var queryStatement: OpaquePointer?
        
        //Prepare the query statement
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(queryStatement, 1, Int32(genreId))
            
            let result = sqlite3_step(queryStatement)
            sqlite3_finalize(queryStatement)
            return result == SQLITE_ROW
        } else {
                print("SELECT Statement could not prepared.")
        }
        
        return false
    }
    
    func genreDelete(genreId: Int) -> Bool {
        
        let deleteStatementString = "DELETE FROM Genres WHERE id = ?;"
               var deleteStatement: OpaquePointer? = nil
               if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
                   sqlite3_bind_int(deleteStatement, 1, Int32(genreId))
                   
                   if sqlite3_step(deleteStatement) == SQLITE_DONE {
                       print("Successfully deleted row.")
                       return true
                   } else {
                       print("Could not delete row.")
                   }
               } else {
                   print("DELETE statement could not be prepared")
               }
               sqlite3_finalize(deleteStatement)
               return false
    }
    
    func genreDisplay() -> [Genre] {
        //return genres.map { "\($0.id): \($0.name)" }.joined(separator: "\n")
        let displayStatementString = "SELECT * FROM Genres;"
        var displayStatement: OpaquePointer? = nil
        var result = [Genre]()
        if sqlite3_prepare_v2(db, displayStatementString,-1, &displayStatement,nil) == SQLITE_OK {
            while sqlite3_step(displayStatement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(displayStatement, 0))
                guard let queryResultCol2 = sqlite3_column_text(displayStatement, 1) else {
                    print("Query result is nil.")
                    continue
                }
                let title = String(cString: queryResultCol2)
                let genre = Genre(id: id, name: title)
                result.append(genre)
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(displayStatement)
        return result
    }
    
    
    func updateGenre(genreId: Int, newGenreName: String){
        
        let updateStatementString = "UPDATE Genres SET name = ? WHERE id = ?;"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, (newGenreName as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 2, Int32(genreId))
            
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }
    
    func findGenreByName(genreName: String) -> String {
        let findStatementString = "SELECT * FROM Genres WHERE name LIKE ?;"
            var findStatement: OpaquePointer? = nil
            var result = ""

            if sqlite3_prepare_v2(db, findStatementString, -1, &findStatement, nil) == SQLITE_OK {

                let searchString = "%\(genreName)%"
                sqlite3_bind_text(findStatement, 1, (searchString as NSString).utf8String, -1, nil)
                
                while sqlite3_step(findStatement) == SQLITE_ROW {
                    let id = sqlite3_column_int(findStatement, 0)
                    guard let queryResultCol1 = sqlite3_column_text(findStatement, 1) else {
                        print("Query result is nil.")
                        continue
                    }
                    let name = String(cString: queryResultCol1)
                    result += "ID: \(id), Name: \(name)\n"
                }
            } else {
                print("SELECT statement for finding by name could not be prepared")
            }
            sqlite3_finalize(findStatement)
            return result
    }

}


class SongService {
    static let shared = SongService()
    private var db: OpaquePointer?
    private init() {
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("/AssignmentNine.sqlite3")
                
                // Open the database
                if sqlite3_open(path, &db) != SQLITE_OK {
                    print("Unable to open database.")
                    return
                }
                
                // Create the Artists table if it doesn't exist
                if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Songs(id INTEGER PRIMARY KEY AUTOINCREMENT,artistId INTEGER,albumId INTEGER,genreId INTEGER,title TEXT NOT NULL,duration DOUBLE NOT NULL,favorite BOOLEAN NOT NULL,FOREIGN KEY(artistId) REFERENCES Artists(id) ON DELETE RESTRICT,FOREIGN KEY(albumId) REFERENCES Albums(id) ON DELETE RESTRICT,FOREIGN KEY(genreId) REFERENCES Genres(id) ON DELETE RESTRICT)", nil, nil,nil) != SQLITE_OK {
                    print("Unable to create table.")
                    return
                }
        
    }
    
    var songs: [Song] = []
    
    func addSong(_ song: Song) {
//        songs.append(song)
        let insertStatementString = "INSERT INTO songs (artistId, albumId, genreId, title, duration, favorite) VALUES (?, ?, ?, ?, ?, ?);"
               var insertStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error preparing insert: \(errmsg)")
        }
        
               if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                   sqlite3_bind_int(insertStatement, 1, Int32(song.artistId))
                   sqlite3_bind_int(insertStatement, 2, Int32(song.albumId))
                   sqlite3_bind_int(insertStatement, 3, Int32(song.genreId))
                   sqlite3_bind_text(insertStatement, 4, (song.title as NSString).utf8String, -1, nil)
                   sqlite3_bind_double(insertStatement, 5, Double(song.duration))
                   sqlite3_bind_int(insertStatement, 6, song.favorite ? 1 : 0)
                   
                   if sqlite3_step(insertStatement) == SQLITE_DONE {
                       print("Successfully inserted Song.")
                   } else {
                       print("Could not insert Song.")
                   }
               } else {
                   print("INSERT statement could not be prepared.")
               }
               sqlite3_finalize(insertStatement)
    }
    
    func songExists(songId: Int) -> Bool {
//        return songs.contains { $0.id == songId}
        let existStatementString = "SELECT * FROM Songs WHERE id = ?;"
        var existStatement: OpaquePointer?
        
        //Prepare the query statement
        if sqlite3_prepare_v2(db, existStatementString, -1, &existStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(existStatement, 1, Int32(songId))
            
            let result = sqlite3_step(existStatement)
            sqlite3_finalize(existStatement)
            return result == SQLITE_ROW
        } else {
            print("SELECT Statement could not prepared.")
        }
        
        return false
    }
    
    func songDelete(songId: Int)  ->  Bool{
        
        let deleteStatementString = "DELETE FROM Songs WHERE id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(songId))
            
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted album.")
                return true
            } else {
                print("Could not delete album.")
            }
        } else {
            print("DELETE statement could not be prepared.")
        }
        sqlite3_finalize(deleteStatement)
        return false
        
    }
    
    func songDisplay() -> [Song] {
        
        let displayStatementString = "SELECT * FROM Songs;"
        var displayStatement: OpaquePointer? = nil
        var result = [Song]()
        if sqlite3_prepare_v2(db, displayStatementString, -1, &displayStatement, nil) == SQLITE_OK {
            while sqlite3_step(displayStatement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(displayStatement, 0))
                let artistId = Int(sqlite3_column_int(displayStatement, 1))
                let albumId = Int(sqlite3_column_int(displayStatement, 2))
                let genreId = Int(sqlite3_column_int(displayStatement, 3))
                guard let queryResultCol2 = sqlite3_column_text(displayStatement, 4),
                      let queryResultCol3 = sqlite3_column_text(displayStatement, 5) else {
                    print("Query result is nil.")
                    continue
                }
                let title = String(cString: queryResultCol2)
                let duration = Double(String(cString: queryResultCol3)) ?? 0.0
                let favorite = sqlite3_column_int(displayStatement,6)
                let isFavorite = favorite != 0
                let song = Song(id: id, artistId: artistId, albumId: albumId, genreId: genreId, title: title, duration: duration, favorite: isFavorite)
                result.append(song)

            }
        } else {
            print("SELECT statement could not be prepared.")
        }
        sqlite3_finalize(displayStatement)
        return result
    }
    
    
    func updateSong(songId: Int, updatedSongName: String, duration: Double){
        
        let updateStatementString = "UPDATE Songs SET title = ?, duration = ? WHERE id = ?;"
                var updateStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
                    sqlite3_bind_text(updateStatement, 1, (updatedSongName as NSString).utf8String, -1, nil)
                    sqlite3_bind_double(updateStatement, 2, Double(duration))
                    sqlite3_bind_int(updateStatement, 3, Int32(songId))
                    
                    if sqlite3_step(updateStatement) == SQLITE_DONE {
                        print("Successfully updated album.")
                    } else {
                        print("Could not update album.")
                    }
                } else {
                    print("UPDATE statement could not be prepared.")
                }
                sqlite3_finalize(updateStatement)
    }
    
    func findSongByName(songName: String) -> String {
        
        let queryStatementString = "SELECT * FROM Songs WHERE title LIKE ?;"
            var queryStatement: OpaquePointer? = nil
            var result = ""
            print("inside server")
            print("song name \(songName)")
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                // Binding the name parameter to the SQL query, '%' characters allow for partial matching
                let searchString = "%\(songName)%"
                sqlite3_bind_text(queryStatement, 1, (searchString as NSString).utf8String, -1, nil)
                
                // Iterating over each row in the result set
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                            let id = sqlite3_column_int(queryStatement, 0)
                            let artistId = sqlite3_column_int(queryStatement, 1)
                            let albumId = sqlite3_column_int(queryStatement, 2)
                            let genreId = sqlite3_column_int(queryStatement, 3)
                            guard let queryResultCol4 = sqlite3_column_text(queryStatement, 4) else {
                                print("Query result is nil.")
                                continue
                            }
                            let title = String(cString: queryResultCol4)
                            let duration = sqlite3_column_double(queryStatement, 5)
                            let favorite = sqlite3_column_int(queryStatement, 6) == 1 ? "Yes" : "No"

                            // Concatenating all the information into a single string
                            result += "ID: \(id), Artist ID: \(artistId), Album ID: \(albumId), Genre ID: \(genreId), Title: \(title), Duration: \(duration), Favorite: \(favorite)\n"
                        }
                    } else {
                        let errmsg = String(cString: sqlite3_errmsg(db))
                        print("SELECT statement for finding by title could not be prepared: \(errmsg)")
                    }
                    sqlite3_finalize(queryStatement)
                    return result
    }
    
    
    func checkSongsInAlbum(albumId : Int) -> Int {
        let checkSongsStatementString = "SELECT COUNT(*) FROM Songs WHERE albumId = ?;"
        var checkSongsStatement: OpaquePointer? = nil
        var songCount = 0
        
        if sqlite3_prepare_v2(db, checkSongsStatementString, -1, &checkSongsStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(checkSongsStatement, 1, Int32(albumId))
            
            if sqlite3_step(checkSongsStatement) == SQLITE_ROW {
                songCount = Int(sqlite3_column_int(checkSongsStatement, 0))
            } else {
                print("Could not retrieve song count for album.")
            }
        } else {
            print("CHECK SONGS statement could not be prepared.")
        }
        sqlite3_finalize(checkSongsStatement)
        return songCount
    }
    
    

    
    
    func checkSongsInGenre(genreId : Int) -> Int {
        let checkSongsStatementString = "SELECT COUNT(*) FROM Songs WHERE genreId = ?;"
        var checkSongsStatement: OpaquePointer? = nil
        var songCount = 0
        
        if sqlite3_prepare_v2(db, checkSongsStatementString, -1, &checkSongsStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(checkSongsStatement, 1, Int32(genreId))
            
            if sqlite3_step(checkSongsStatement) == SQLITE_ROW {
                songCount = Int(sqlite3_column_int(checkSongsStatement, 0))
            } else {
                print("Could not retrieve song count for genre.")
            }
        } else {
            print("CHECK SONGS statement could not be prepared.")
        }
        sqlite3_finalize(checkSongsStatement)
        return songCount
    }
}

