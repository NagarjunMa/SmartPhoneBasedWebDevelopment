//
//  DatabaseManager.swift
//  AssignmentNine
//
//  Created by Nagarjun Mallesh on 24/03/24.
//

import Foundation
import SQLite3

class DatabaseManager {
    static let shared = DatabaseManager()
    var db : OpaquePointer?
    
    private init() {
        openDatabase()
        createTables()
        checkDatabaseExistence()
    }
    
    public func openDatabase() {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("AssignmentNine.sqlite3")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
    }
    
    public func createTables() {
        
        let createTableString = """
        CREATE TABLE IF NOT EXISTS Artists(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL);
        CREATE TABLE IF NOT EXISTS Albums(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        artistId INTEGER,
        title TEXT NOT NULL,
        releaseDate TEXT NOT NULL,
        FOREIGN KEY(artistId) REFERENCES Artists(id) ON DELETE RESTRICT);
        CREATE TABLE IF NOT EXISTS Songs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        artistId INTEGER,
        albumId INTEGER,
        genreId INTEGER,
        title TEXT NOT NULL,
        duration DOUBLE NOT NULL,
        favorite BOOLEAN NOT NULL,
        FOREIGN KEY(artistId) REFERENCES Artists(id) ON DELETE RESTRICT,
        FOREIGN KEY(albumId) REFERENCES Albums(id) ON DELETE RESTRICT,
        FOREIGN KEY(genreId) REFERENCES Genres(id) ON DELETE RESTRICT);
        CREATE TABLE IF NOT EXISTS Genres(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL);
        """
        
        var createTableStatement: OpaquePointer?
        if sqlite3_exec(db, createTableString, nil,nil,nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        sqlite3_finalize(createTableStatement)
        
    }
    
    
    deinit {
        sqlite3_close(db)
    }
    
    
    func checkDatabaseExistence() {
        let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("/AssignmentNine.sqlite3")
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            print("Database exists at path: \(filePath)")
        } else {
            print("Database does not exist.")
        }
    }

    
}

