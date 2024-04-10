//
//  GenreView.swift
//  EmptyApp
//
//  Created by Nagarjun Mallesh on 23/02/24.
//  Copyright © 2024 rab. All rights reserved.
//

import SwiftUI

class GenreView : UIView {
    
    var landingPage : LandingPage?
    var nextGenreId : Int = 1
    
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
        textField.placeholder = "Enter Genre Name"
        return textField
    }()
    
    
    
    
    
    func showSuccessMessage(_ message: String){
        let alertView = CustomAlertView(frame: CGRect(x:0,y:0,width:250, height:150))
        alertView.showAlert(on: self, withMessage: message)
    }
    
    private let addButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Add Genre", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        return button
    }()
    
    private let viewButton: UIButton = {
       
        let button = UIButton(type: .system)
        button.setTitle("Display all Genres", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        return button
    }()

    private let genreDisplayView: UITextView = {
        
        let textView = UITextView()
        textView.isEditable = false
        return textView
    }()
    
    private let updateField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter genre id to be updated"
        return textField
    }()
    
    private let updateGenreField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter genre id to be updated"
        return textField
    }()
    
    private let updateButton: UIButton = {
       
        let button = UIButton(type: .system)
        button.setTitle("Update Genre", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        return button
    }()
    
    private let searchBtn: UIButton = {
       
        let button = UIButton(type: .system)
        button.setTitle("Search Genre", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        return button
    }()
    
    
    private let deleteField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter genre id to be deleted"
        return textField
    }()
    
    
    private let deleteButton: UIButton = {
       
        let button = UIButton(type: .system)
        button.setTitle("Delete Genre", for: .normal)
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
        
        let stackView = UIStackView(arrangedSubviews: [titleField, addButton, viewButton, genreDisplayView,searchBtn, updateField,updateGenreField, updateButton, deleteField, deleteButton, backButton])
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
                    updateGenreField.heightAnchor.constraint(equalToConstant: 40),
                    deleteField.heightAnchor.constraint(equalToConstant: 40),
                    addButton.heightAnchor.constraint(equalToConstant: 40),
                    viewButton.heightAnchor.constraint(equalToConstant: 40),
                    searchBtn.heightAnchor.constraint(equalToConstant: 40),
                    updateButton.heightAnchor.constraint(equalToConstant: 40),
                    deleteButton.heightAnchor.constraint(equalToConstant: 40),
                    backButton.heightAnchor.constraint(equalToConstant: 40),
                    genreDisplayView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        addButton.addTarget(self, action: #selector(addGenre), for: .touchUpInside)
        updateButton.addTarget(self, action: #selector(updateGenre), for: .touchUpInside)
        viewButton.addTarget(self, action: #selector(displayGenre), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteGenre), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(handleBackBtn), for: .touchUpInside)
        searchBtn.addTarget(self, action: #selector(searchGenre), for: .touchUpInside)
    }
    
    
    @objc private func addGenre() {
        guard let name = titleField.text,
              !name.isEmpty else {
            print("There is an issue while adding the artist")
            return
        }
        
        let genre = Genre(id: nextGenreId, name: name)
        GenreService.shared.addGenre(genre)
        nextGenreId += 1
        titleField.text = ""
        
        showSuccessMessage("The genre is added successfully..")
        
    }
    
    @objc private func updateGenre() {
        guard let genreString = updateField.text,
              let genreId = Int(genreString),
              let newName = updateGenreField.text,
              !genreString.isEmpty,
              !newName.isEmpty else {
            print("Please enter the correct field value")
            showSuccessMessage("Please enter the correct genreId and genreName")
            return
        }
        
        GenreService.shared.updateGenre(genreId: genreId, newGenreName: newName)
        showSuccessMessage("The value is updated successfully..")
        updateField.text=""
        updateGenreField.text=""
    }
    
    @objc private func deleteGenre() {
        guard let idString = deleteField.text, let id = Int(idString), !idString.isEmpty else{
            showSuccessMessage("Please enter the valid Genre ID")
            return
        }
        
        if let index = GenreService.shared.findIndex(genreId: id){
            GenreService.shared.genreDelete(genreId: index)
            showSuccessMessage("Genre with ID \(id) has been deleted successfully..")
        }else{
            showSuccessMessage("No Genre found with ID \(id).")
        }
        
        deleteField.text = ""
    }
    
    @objc private func displayGenre() {
        let displayGenre = GenreService.shared.genreDisplay()
        genreDisplayView.text = displayGenre
        
    }
    
    @objc private func searchGenre() {
        guard let genreName = titleField.text,
              !genreName.isEmpty else {
                  showSuccessMessage("Enter the genre name to be searched..")
                  return
              }
        
        let genre = GenreService.shared.findGenreByName(genreName: genreName)
        genreDisplayView.text = genre
        titleField.text = ""
    }
    
    
    @objc private func handleBackBtn() {
        self.isHidden = true
        landingPage?.isHidden = false
    }
}
