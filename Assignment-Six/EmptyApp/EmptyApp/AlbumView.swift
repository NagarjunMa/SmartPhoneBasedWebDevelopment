//
//  AlbumView.swift
//  EmptyApp
//
//  Created by Nagarjun Mallesh on 23/02/24.
//  Copyright © 2024 rab. All rights reserved.
//

import SwiftUI

class AlbumView : UIView {
    
    
    var albums: [Album] = []
    private var nextAlbumId: Int = 1
    var artists: [Artist] = []
    
    var landing: LandingPage?
    
    
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
        textField.placeholder = "Enter Album title"
        return textField
    }()
    
    private let artistIdField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter artist id"
        return textField
    }()
    
    private let releaseDateField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter release date"
        return textField
    }()
    
    
    
    
    func showSuccessMessage(_ message: String){
        let alertView = CustomAlertView(frame: CGRect(x:0,y:0,width:250, height:150))
        alertView.showAlert(on: self, withMessage: message)
    }
    
    private let addButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Add Album", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        return button
    }()
    
    private let viewButton: UIButton = {
       
        let button = UIButton(type: .system)
        button.setTitle("Display all Albums", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        return button
    }()

    private let albumDisplayTextView: UITextView = {
        
        let textView = UITextView()
        textView.isEditable = false
        return textView
    }()
    
    private let updateField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter album id to be updated"
        return textField
    }()
    
    private let updateAlbumField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter album id to be updated"
        return textField
    }()
    
    private let updateButton: UIButton = {
       
        let button = UIButton(type: .system)
        button.setTitle("Update Album", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        return button
    }()
    
    private let searchButton: UIButton = {
       
        let button = UIButton(type: .system)
        button.setTitle("Search Album", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        return button
    }()
    
    
    
    private let deleteField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter album id to be deleted"
        return textField
    }()
    
    
    private let deleteButton: UIButton = {
       
        let button = UIButton(type: .system)
        button.setTitle("Delete Album", for: .normal)
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
        
        let stackView = UIStackView(arrangedSubviews: [titleField, releaseDateField, artistIdField, addButton, viewButton, albumDisplayTextView, updateField, updateAlbumField, searchButton, updateButton, deleteField, deleteButton, backButton])
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
                    updateField.heightAnchor.constraint(equalToConstant: 40),
                    deleteField.heightAnchor.constraint(equalToConstant: 40),
                    updateAlbumField.heightAnchor.constraint(equalToConstant: 40),
                    addButton.heightAnchor.constraint(equalToConstant: 40),
                    releaseDateField.heightAnchor.constraint(equalToConstant: 40),
                    artistIdField.heightAnchor.constraint(equalToConstant: 40),
                    viewButton.heightAnchor.constraint(equalToConstant: 40),
                    searchButton.heightAnchor.constraint(equalToConstant: 40),
                    updateButton.heightAnchor.constraint(equalToConstant: 40),
                    deleteButton.heightAnchor.constraint(equalToConstant: 40),
                    backButton.heightAnchor.constraint(equalToConstant: 40),
                    albumDisplayTextView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        addButton.addTarget(self, action: #selector(addAlbum), for: .touchUpInside)
        updateButton.addTarget(self, action: #selector(updateAlbum), for: .touchUpInside)
        viewButton.addTarget(self, action: #selector(displayAlbums), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteAlbum), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(handleBackBtn), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(searchAlbum), for: .touchUpInside)
        
    }
    
    
    @objc private func addAlbum() {
        
        guard let artistIdString = artistIdField.text,
              let artistId = Int(artistIdString),
              let title = titleField.text,
              let releasedDate = releaseDateField.text,
              ArtistService.shared.artistExists(artistId: artistId),
              !title.isEmpty,
              !releasedDate.isEmpty else {
            showSuccessMessage("All fields are required.")
            return
        }
        
        
        
        let newAlbum = Album(id: nextAlbumId, artistId: artistId, title: title, releaseDate: releasedDate)
        AlbumService.shared.addAlbum(newAlbum)
        nextAlbumId += 1
        showSuccessMessage("Album added successfully")
        
        //clear all the text fields in the form
        artistIdField.text = ""
        titleField.text = ""
        releaseDateField.text = ""
        
    }
    
    @objc private func updateAlbum() {
        guard let albumString = updateField.text,
              let albumId = Int(albumString),
              let newName = updateAlbumField.text,
              !albumString.isEmpty,
              !newName.isEmpty else {
            print("Enter the correct album id and new name")
            showSuccessMessage("Please enter the correct albumId and newName")
            return
        }
        
        
        AlbumService.shared.updateAlbum(albumId: albumId, newAlbumName: newName)
        showSuccessMessage("The Value is updated")
        updateField.text = ""
        updateAlbumField.text = ""
    }
    
    @objc private func displayAlbums() {
        let displayAlbum = AlbumService.shared.albumDisplay()
        albumDisplayTextView.text = displayAlbum
    }
    
    @objc private func deleteAlbum(){
        guard let idString = deleteField.text, let id = Int(idString), !idString.isEmpty else {
            showSuccessMessage("Please enter the valid Album ID")
            return
        }
        
        if let index = AlbumService.shared.findIndex(albumId: id) {
            if AlbumService.shared.albumDelete(albumId: index) {
                showSuccessMessage("Album with ID \(id) has been deleted successfully..")
            }else{
                showSuccessMessage("Album with ID \(id) could not be deleted..")
            }
        }else{
            showSuccessMessage("No Album found with ID \(id).")
        }
        
        deleteField.text = ""
    }
    
    @objc private func handleBackBtn() {
        self.isHidden = true
        landing?.isHidden = false
    }
    
    @objc private func searchAlbum() {
        guard let albumName = titleField.text,
              !albumName.isEmpty else {
            showSuccessMessage("Enter the Album name to search")
            return
        }
        
        let album = AlbumService.shared.findAlbumByName(albumName: albumName)
        albumDisplayTextView.text = album
        titleField.text = ""
    }
    
}
