//
//  SongDisplayList.swift
//  AssignmentNine
//
//  Created by Nagarjun Mallesh on 24/03/24.
//

import UIKit

class SongDisplayList: UITableViewController {
    
    var songs : [Song] = []
    var selectedSong : Song?

    override func viewDidLoad() {
        super.viewDidLoad()
        songs = SongService.shared.songDisplay()

       
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return songs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // Ensure you cast the dequeued cell to your custom cell type
        print("testing inside tableView")
            let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath)
            let song = songs[indexPath.row]
        let details = "Song ID: \(song.id) Song Name: \(song.title)"

        cell.textLabel?.text=details

            return cell
        }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let song = songs[indexPath.row]
        selectedSong = song
        
        performSegue(withIdentifier: "ShowSongDetail", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSongDetail" {
            let productTVC = segue.destination as! SongEachDisplay
            productTVC.song = selectedSong
        }
    }

    

   
}
