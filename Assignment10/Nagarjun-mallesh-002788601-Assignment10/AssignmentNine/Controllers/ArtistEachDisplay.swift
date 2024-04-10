//
//  ArtistEachDisplay.swift
//  AssignmentNine
//
//  Created by Nagarjun Mallesh on 24/03/24.
//

import UIKit

class ArtistEachDisplay: UITableViewController {

    @IBOutlet var artistIdTxt: UITextField!
    
    @IBOutlet var artistNameTxt: UITextField!
    @IBOutlet var artistImg: UIImageView!
    var artist: Artist?
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    // MARK: - Table view data source

    func updateUI() {
        
        if let artistId = artist?.id, let artistName = artist?.name {
            artistIdTxt.text = String(artistId)
            artistNameTxt.text = artistName
            
            print("testing the artist name \(artistName)")
            
            let imagePath = getDocumentsDirectory().appendingPathComponent("\(artistName).jpg").path
            if FileManager.default.fileExists(atPath: imagePath) {
                artistImg.image = UIImage(contentsOfFile: imagePath)
            } else {
                artistImg.image = UIImage(named: "defaultArtistImage") // Make sure this image exists in your Assets.
            }
        }
        
    }
    
    
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
