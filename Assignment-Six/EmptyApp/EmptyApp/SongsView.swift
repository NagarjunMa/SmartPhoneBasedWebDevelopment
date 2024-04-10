//
//  SongsView.swift
//  EmptyApp
//
//  Created by Nagarjun Mallesh on 23/02/24.
//  Copyright © 2024 rab. All rights reserved.
//

import SwiftUI

class SongsView : UIView {
    
    
    var landingPage : LandingPage?
    var songId: Int = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder: ) has not been implemented")
    }
    
    private let titleField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter Song title"
        return textField
    }()
    
    private let durationField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter the song duration"
        return textField
    }()
    
    private let artistIdField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter artist id"
        return textField
    }()
    
    private let albumIdField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter album id"
        return textField
    }()
    
    
    private let genreIdField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter genre id"
        return textField
    }()
    
    
    
    
    func showSuccessMessage(_ message: String){
        let alertView = CustomAlertView(frame: CGRect(x:0,y:0,width:250, height:150))
        alertView.showAlert(on: self, withMessage: message)
    }
    
    func showErrorMessage(_ message: String){
        let alertView = CustomAlertView(frame: CGRect(x:0,y:0,width: 250, height: 150))
        alertView.showAlert(on: self, withMessage: message)
    }
    
    private let addButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Add Song", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        return button
    }()
    
    private let viewButton: UIButton = {
       
        let button = UIButton(type: .system)
        button.setTitle("Display all Songs", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        return button
    }()

    private let songDisplayTextView: UITextView = {
        
        let textView = UITextView()
        textView.isEditable = false
        return textView
    }()
    
    private let updateField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter song id to be updated"
        return textField
    }()
    
    private let updateButton: UIButton = {
       
        let button = UIButton(type: .system)
        button.setTitle("Update Song", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        return button
    }()
    
    
    private let searchBtn: UIButton = {
       
        let button = UIButton(type: .system)
        button.setTitle("Search Song", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        return button
    }()
    
    
    private let deleteField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter song id to be deleted"
        return textField
    }()
    
    
    private let deleteButton: UIButton = {
       
        let button = UIButton(type: .system)
        button.setTitle("Delete Song", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        return button
    }()
    
    
    private let backButton: UIButton = {
       
        let button = UIButton(type: .system)
        button.setTitle("Back Button", for: .normal)
        button.backgroundColor = .systemGray
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    

    
    private func setupUI() {
        
        let stackView = UIStackView(arrangedSubviews: [titleField, durationField,albumIdField, artistIdField, genreIdField, addButton, viewButton, songDisplayTextView, searchBtn, deleteField, updateButton, deleteButton, backButton])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                    stackView.topAnchor.constraint(equalTo: topAnchor, constant: 60),
                    stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
                    stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
                    titleField.heightAnchor.constraint(equalToConstant: 40),
                    durationField.heightAnchor.constraint(equalToConstant: 40),
                    albumIdField.heightAnchor.constraint(equalToConstant: 40),
                    artistIdField.heightAnchor.constraint(equalToConstant: 40),
                    genreIdField.heightAnchor.constraint(equalToConstant: 40),
                    deleteField.heightAnchor.constraint(equalToConstant: 40),
                    addButton.heightAnchor.constraint(equalToConstant: 40),
                    viewButton.heightAnchor.constraint(equalToConstant: 40),
                    searchBtn.heightAnchor.constraint(equalToConstant: 40),
                    updateButton.heightAnchor.constraint(equalToConstant: 40),
                    deleteButton.heightAnchor.constraint(equalToConstant: 40),
                    backButton.heightAnchor.constraint(equalToConstant: 40),
                    songDisplayTextView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        addButton.addTarget(self, action: #selector(addSongs), for: .touchUpInside)
        updateButton.addTarget(self, action: #selector(updateSongs), for: .touchUpInside)
        viewButton.addTarget(self, action: #selector(displaySongs), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteSongs), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(handleBackBtn), for: .touchUpInside)
        searchBtn.addTarget(self, action: #selector(searchSong), for: .touchUpInside)
    }
    
    
    @objc private func addSongs() {
        print("Songs addition process in progress..")
        
        guard let songName = titleField.text,
              let artistIdString = artistIdField.text,
              let albumIdString = albumIdField.text,
              let artistId = Int(artistIdString),
              let albumId = Int(albumIdString),
              let durationString = durationField.text,
              let duration = Double(durationString),
              let genreString = genreIdField.text,
              let genre = Int(genreString),
              ArtistService.shared.artistExists(artistId: artistId),
              AlbumService.shared.albumExists(albumId: albumId),
              GenreService.shared.genreExists(genreId: genre),
              !songName.isEmpty else {
            showErrorMessage("All field are required.")
            return
        }
        
        let newSong = Song(id: songId, artistId: artistId, albumId: albumId, genreId: genre, title: songName, duration: duration, favorite: false)
        
        AlbumService.shared.addSongToAlbum(albumId: albumId, song: newSong)
        SongService.shared.addSong(newSong)
        songId += 1
        showSuccessMessage("Song Added successfully..")
        
        titleField.text = ""
        artistIdField.text = ""
        albumIdField.text = ""
        durationField.text=""
        genreIdField.text = ""
        
        
              
    }
    
    @objc private func updateSongs() {
        guard let songIdString = deleteField.text,
              let songId = Int(songIdString),!songIdString.isEmpty
        else{
            showErrorMessage("Please enter the correct song Id")
            return
        }
        
        guard let updatedSong = titleField.text,!updatedSong.isEmpty,
              let duration = durationField.text,!duration.isEmpty,
              let updatedDuration = Double(duration)
        else{
            showErrorMessage("Please enter the correct songName and Duration")
            return
        }
        
        SongService.shared.updateSong(songId: songId, updatedSongName: updatedSong, duration: updatedDuration)
        showSuccessMessage("Song have been updated successfully..")
        titleField.text = ""
        durationField.text = ""
        deleteField.text=""
    }
    

    
    @objc private func deleteSongs() {
        guard let songIdString = deleteField.text,
              let songId = Int(songIdString),!songIdString.isEmpty
               else {
            showErrorMessage("Please enter the song Id correctly.")
            return
        }
        SongService.shared.songDelete(songId: songId)
    }
    
    @objc private func displaySongs() {
        let songs = SongService.shared.songDisplay()
        songDisplayTextView.text = songs
        
        deleteField.text = ""
    }
    
    @objc private func searchSong(){
        guard let songName = titleField.text,
              !songName.isEmpty else {
            showErrorMessage("Enter the song name to search")
            return
        }
        
        let song = SongService.shared.findSongByName(songName: songName)
        songDisplayTextView.text = song
        titleField.text = ""
    }
    
    
    @objc private func handleBackBtn() {
        self.isHidden = true
        landingPage?.isHidden = false
    }
    
    
}

