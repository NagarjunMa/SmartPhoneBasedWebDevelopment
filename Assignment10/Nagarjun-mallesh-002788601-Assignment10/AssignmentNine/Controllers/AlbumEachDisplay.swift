//
//  AlbumEachDisplay.swift
//  AssignmentNine
//
//  Created by Nagarjun Mallesh on 24/03/24.
//

import UIKit

class AlbumEachDisplay: UITableViewController {
    
    var album:Album?

    @IBOutlet var releaseDate: UITextField!
    @IBOutlet var artistIdTxt: UITextField!
    @IBOutlet var albumNameTxt: UITextField!
    @IBOutlet var albumIdTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    func updateUI() {
        if let albumId = album?.id, let albumName = album?.title,
        let releaseDateVal = album?.releaseDate,
        let artistId = album?.artistId {
            
            print("testing the album name \(albumName)")
            
            albumIdTxt.text = String(albumId)
            albumNameTxt.text = albumName
            releaseDate.text = releaseDateVal
            artistIdTxt.text = String(artistId)
            
        }
    }

    // MARK: - Table view data source

    
}
