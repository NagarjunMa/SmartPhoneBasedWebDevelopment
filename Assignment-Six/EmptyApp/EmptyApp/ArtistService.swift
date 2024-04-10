//
//  ArtistService.swift
//  EmptyApp
//
//  Created by Nagarjun Mallesh on 23/02/24.
//  Copyright © 2024 rab. All rights reserved.
//

import Foundation


class ArtistService {
    static let shared = ArtistService()
    private init() {}
    
    var artists: [Artist] = []
    
    func addArtist(_ artist: Artist) {
        artists.append(artist)
    }
    
    func artistExists(artistId: Int) -> Bool {
        return artists.contains { $0.id == artistId }
    }
    
    func artistDelete(artistId: Int) -> Bool {
        if canDeleteArtist(artistId: artistId) {
            artists.remove(at: artistId)
            return true
        }
        
        return false

    }
    
    func findIndex(artistId: Int) -> Int? {
        return artists.firstIndex(where: { $0.id == artistId})
    }
    
    func artistDisplay() -> String {
        return artists.map { "\($0.id): \($0.name)" }.joined(separator: "\n")
    }
    
    func updateArtistName(artistId: Int, newName: String) {
        if let index = findIndex(artistId: artistId){
            artists[index].name = newName
        }
    }
    
    func canDeleteArtist(artistId: Int) -> Bool {
        
        return !AlbumService.shared.albums.contains(where: {$0.artistId == artistId})
    }
    
    
    func findArtistByName(artistName: String) -> String {
        if let artist = artists.first(where: {$0.name == artistName}){
            
            return "Artist ID : \(artist.id); Artist Name: \(artist.name); "
        }else{
            return "Artist not found"
        }
    }
    
    func updateArtist(artistId:Int, artistName:String) {
        if let index = findIndex(artistId: artistId) {
            artists[index].name = artistName
        }
    }
}

class AlbumService {
    static let shared = AlbumService()
    private init() {}
    
    var albums: [Album] = []
    
    func addAlbum(_ album: Album) {
        albums.append(album)
    }
    
    func albumExists(albumId: Int) -> Bool {
        return albums.contains { $0.id == albumId }
    }
    
    func albumDelete(albumId: Int)  -> Bool{
        if let album = albums.first(where: {$0.id == albumId}), !album.songs.isEmpty {
            albums.remove(at: albumId)
            return true
        }
        return false
    }
    
    func addSongToAlbum(albumId: Int, song: Song) {
        let index = (self.findIndex(albumId: albumId))!
        albums[index].songs.append(song)
    }
    
    
    func albumDisplay() -> String {
        return albums.map { album in
                let songsString = album.songs.map { song in
                    "Song ID: \(song.id), Title: \"\(song.title)\", Duration: \(song.duration)"
                }.joined(separator: "; ")

                return "Album No: \(album.id); Title: \(album.title); Artist ID: \(album.artistId); Release Date: \(album.releaseDate); Songs: [\(songsString)]"
            }.joined(separator: "\n")
    }
    
    func findIndex(albumId: Int) -> Int? {
        return albums.firstIndex(where: { $0.id == albumId})
    }
    
    func updateAlbum(albumId: Int, newAlbumName: String){
        if let index = findIndex(albumId: albumId) {
            albums[index].title = newAlbumName
        }
        
    }
    
    func findAlbumByName(albumName: String) -> String {
        if let album = albums.first(where: {$0.title == albumName}){
            
            let songsString = album.songs.map { song in
                "Song ID: \(song.id), Title: \"\(song.title)\", Duration: \(song.duration)"
            }.joined(separator: "; ")
            
            return "Album ID : \(album.id); Album Name: \(album.title); Album's Artist Id: \(album.artistId); Album release date: \(album.releaseDate); Album Songs: \(songsString);"
        }else{
            return "Album not found"
        }
    }

    
}

class GenreService {
    static let shared = GenreService()
    private init() {}
    
    var genres: [Genre] = []
    
    func addGenre(_ genre: Genre) {
        genres.append(genre)
    }
    
    func genreExists(genreId: Int) -> Bool {
        return genres.contains { $0.id == genreId}
    }
    
    func genreDelete(genreId: Int) {
        genres.remove(at: genreId)
    }
    
    func genreDisplay() -> String {
        return genres.map { "\($0.id): \($0.name)" }.joined(separator: "\n")
    }
    
    func findIndex(genreId: Int) -> Int? {
        return genres.firstIndex(where: { $0.id == genreId})
    }
    
    func updateGenre(genreId: Int, newGenreName: String){
        if let index = findIndex(genreId: genreId) {
            genres[index].name = newGenreName
        }
    }
    
    func findGenreByName(genreName: String) -> String {
        if let genre = genres.first(where: {$0.name == genreName}){
            return "Genre ID: \(genre.id); Genre Name: \(genre.name)"
        }else{
            return "Genre not found"
        }
    }

}


class SongService {
    static let shared = SongService()
    private init() {}
    
    var songs: [Song] = []
    
    func addSong(_ song: Song) {
        songs.append(song)
    }
    
    func songExists(songId: Int) -> Bool {
        return songs.contains { $0.id == songId}
    }
    
    func songDelete(songId: Int) {
        
        guard let song = songs.first(where: {$0.id == songId}) else {
            print("Song not found")
            return
        }
        songs.removeAll{$0.id == songId}
        
        if let albumId = AlbumService.shared.albums.firstIndex(where: { $0.id == song.albumId}) {
            AlbumService.shared.albums[albumId].songs.removeAll{$0.id == songId}
        }
        
        
    }
    
    func songDisplay() -> String {
        return songs.map { "\($0.id):Title: \($0.title) :Artist: \($0.artistId) :Album \($0.albumId) :GenreID \($0.genreId) :Duration \($0.duration) :Favorite \($0.favorite) :" }.joined(separator: "\n")
    }
    
    func findIndex(songId: Int) -> Int? {
        return songs.firstIndex(where: { $0.id == songId})
    }
    
    func updateSong(songId: Int, updatedSongName: String, duration: Double){
        if let index = findIndex(songId: songId){
            songs[index].title = updatedSongName
            songs[index].duration = duration
        }
    }
    
    func findSongByName(songName: String) -> String {
        if let song = songs.first(where: {$0.title == songName}){
            return "Song ID : \(song.id); Song Name: \(song.title); Song's Album: \(song.albumId); Song's Artist: \(song.artistId); Song Duration: \(song.duration); favorite: \(song.favorite); Song's Genre: \(song.genreId)"
        }else{
            return "Song not found"
        }
    }
}
