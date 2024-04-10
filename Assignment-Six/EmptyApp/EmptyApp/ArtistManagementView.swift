//
//  ArtistManagementView.swift
//  EmptyApp
//
//  Created by Nagarjun Mallesh on 22/02/24.
//  Copyright © 2024 rab. All rights reserved.
//

import Foundation
import SwiftUI

class ArtistManagementView : UIView {
    var artists : [Artist] = []
    private var nextArtistId: Int = 1
    
    var landingPage: LandingPage?
    
    
    private let titleField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter artist name"
        return textField
    }()
    
    
    func showSuccessMessage(_ message: String){
        let alertView = CustomAlertView(frame: CGRect(x:0,y:0,width:250, height:150))
        alertView.showAlert(on: self, withMessage: message)
    }
    
    private let addButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Add Artist", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        return button
    }()
    
    private let viewButton: UIButton = {
       
        let button = UIButton(type: .system)
        button.setTitle("Display all Artists", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        return button
    }()

    private let artistDisplayTextView: UITextView = {
        
        let textView = UITextView()
        textView.isEditable = false
        return textView
    }()
    
    private let updateField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter artist id to be updated"
        return textField
    }()
    
    private let updateButton: UIButton = {
       
        let button = UIButton(type: .system)
        button.setTitle("Update Artist", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        return button
    }()
    
    
    private let deleteField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter artist id to be deleted"
        return textField
    }()
    
    
    private let deleteButton: UIButton = {
       
        let button = UIButton(type: .system)
        button.setTitle("Delete Artist", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        return button
    }()
    
    
    private let searchBtn: UIButton = {
       
        let button = UIButton(type: .system)
        button.setTitle("Search Artist", for: .normal)
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
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder: ) has not been implemented")
    }
    
    private func setupUI() {
        
        let stackView = UIStackView(arrangedSubviews: [titleField, addButton, viewButton, artistDisplayTextView, updateField, updateButton, deleteField, deleteButton,searchBtn, backButton])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                    stackView.topAnchor.constraint(equalTo: topAnchor, constant: 100),
                    stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
                    stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
                    titleField.heightAnchor.constraint(equalToConstant: 40),
                    updateField.heightAnchor.constraint(equalToConstant: 40),
                    deleteField.heightAnchor.constraint(equalToConstant: 40),
                    addButton.heightAnchor.constraint(equalToConstant: 40),
                    viewButton.heightAnchor.constraint(equalToConstant: 40),
                    updateButton.heightAnchor.constraint(equalToConstant: 40),
                    deleteButton.heightAnchor.constraint(equalToConstant: 40),
                    searchBtn.heightAnchor.constraint(equalToConstant: 40),
                    backButton.heightAnchor.constraint(equalToConstant: 40),
                    artistDisplayTextView.heightAnchor.constraint(equalToConstant: 150)
                    
        ])
        
        addButton.addTarget(self, action: #selector(addArtist), for: .touchUpInside)
        updateButton.addTarget(self, action: #selector(updateArtist), for: .touchUpInside)
        viewButton.addTarget(self, action: #selector(displayArtists), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteArtist), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        searchBtn.addTarget(self, action: #selector(searchArtist), for: .touchUpInside)
        
    }
    
    
    @objc private func addArtist() {
        guard let name = titleField.text, !name.isEmpty else {
            print("There is an issue while adding the artist")
            return
        }
        
        let artist = Artist(id: nextArtistId, name: name)
        ArtistService.shared.addArtist(artist)
        nextArtistId += 1
        titleField.text = ""
        
        showSuccessMessage("Artists added successfully..")
    }
    
    
    @objc private func displayArtists() {
        let displayText = ArtistService.shared.artistDisplay()
        artistDisplayTextView.text = displayText
    } 
    
    
    @objc private func updateArtist() {
        guard let artistString = updateField.text,
              let artistId = Int(artistString),
              !artistString.isEmpty,
              let name=titleField.text,
              !name.isEmpty else{
            showSuccessMessage("Please enter the name and id correctly")
            return
        }
        
        
        ArtistService.shared.updateArtistName(artistId: artistId, newName: name)
        showSuccessMessage("The update processed successfully..")
        
        
    }
    
    @objc private func deleteArtist() {
        guard let idString = deleteField.text, let id = Int(idString), !idString.isEmpty else {
            showSuccessMessage("Please enter the valid Artist ID")
            return
        }
        
        if let index = ArtistService.shared.findIndex(artistId: id) {
            if ArtistService.shared.artistDelete(artistId: index) {
                showSuccessMessage("Artist with ID \(id) has been deleted successfully..")
            } else {
                showSuccessMessage("No artist found with ID \(id).")
            }
        }else{
            showSuccessMessage("No artist found with ID \(id).")
        }
        
        deleteField.text = ""
    }
    
    @objc private func handleBack() {
        self.isHidden = true
        landingPage?.isHidden = false
    }
    
    
    @objc private func searchArtist() {
        guard let name = titleField.text,
              !name.isEmpty else {
            showSuccessMessage("Please enter the name to search..")
            return
        }
        let artist = ArtistService.shared.findArtistByName(artistName: name)
        artistDisplayTextView.text = artist
        titleField.text = ""
    }
    
    
    

    
    
    
}
