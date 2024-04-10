//
//  SongEachDisplay.swift
//  AssignmentNine
//
//  Created by Nagarjun Mallesh on 24/03/24.
//

import UIKit

class SongEachDisplay: UITableViewController {
    
    var song: Song?

    @IBOutlet var songIdTxt: UITextField!
    
    @IBOutlet var genreIdTxt: UITextField!
    @IBOutlet var albumIdTxt: UITextField!
    @IBOutlet var artistIdTxt: UITextField!
    @IBOutlet var durationTxt: UITextField!
    @IBOutlet var songNameTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()

    }
    
    func updateUI() {
        
        if let songId = song?.id, let albumId = song?.albumId, let artistId = song?.artistId, let genreId = song?.genreId, let songTitle = song?.title  , let duration = song?.duration {
            
            
            songIdTxt.text = String(songId)
            songNameTxt.text = songTitle
            durationTxt.text = String(duration)
            artistIdTxt.text = String(artistId)
            albumIdTxt.text = String(albumId)
            genreIdTxt.text = String(genreId)
            
            
        }
        
    }

   
}
