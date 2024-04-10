//
//  LandingPage.swift
//  EmptyApp
//
//  Created by Nagarjun Mallesh on 22/02/24.
//  Copyright © 2024 rab. All rights reserved.
//

import SwiftUI

class LandingPage : UIView {
    
    let welcomeLabel = UILabel()
    let artistButton = UIButton(type: .system)
    let songsButton = UIButton(type: .system)
    let genreButton = UIButton(type: .system)
    let albumButton = UIButton(type: .system)
    
    var artistView: ArtistManagementView? // Reference to the artist view
    var albumView: AlbumView?
    var songView: SongsView?
    var genreView: GenreView?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setUpApplication()
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented..")
    }
    
    private func setUpApplication() {
        
        welcomeLabel.text = "Welcome to the Music Application"
        welcomeLabel.textAlignment = .center
        welcomeLabel.font = UIFont(name:"fontname", size: 30.0)
        welcomeLabel.textColor = .systemGray
        
        artistButton.setTitle("Artist View", for: .normal)
        artistButton.setTitleColor(.white, for: .normal)
        artistButton.backgroundColor = .orange
        songsButton.setTitle("Songs View", for: .normal)
        songsButton.setTitleColor(.white, for: .normal)
        songsButton.backgroundColor = .orange
        genreButton.setTitle("Genre View", for: .normal)
        genreButton.setTitleColor(.white, for: .normal)
        genreButton.backgroundColor = .orange
        albumButton.setTitle("Album View", for: .normal)
        albumButton.setTitleColor(.white, for: .normal)
        albumButton.backgroundColor = .orange
        
        let stackView = UIStackView(arrangedSubviews: [welcomeLabel, artistButton, songsButton, genreButton, albumButton])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints=false
        
        artistButton.addTarget(self, action: #selector(showArtistView), for: .touchUpInside)
        albumButton.addTarget(self, action: #selector(showAlbumView), for: .touchUpInside)
        songsButton.addTarget(self, action: #selector(showSongsView), for: .touchUpInside)
        genreButton.addTarget(self, action: #selector(showGenreView), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 200),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            artistButton.heightAnchor.constraint(equalToConstant: 40),
            albumButton.heightAnchor.constraint(equalToConstant: 40),
            songsButton.heightAnchor.constraint(equalToConstant: 40),
            genreButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    
    @objc private func showArtistView() {
        self.isHidden = true
        artistView?.isHidden = false
    }
    
    @objc private func showAlbumView() {
        self.isHidden = true
        albumView?.isHidden = false
    }
    
    @objc private func showSongsView() {
        self.isHidden = true
        songView?.isHidden = false
    }
    
    @objc private func showGenreView() {
        self.isHidden = true
        genreView?.isHidden = false
    }
}
