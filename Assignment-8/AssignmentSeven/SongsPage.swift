//
//  SongsPage.swift
//  AssignmentSeven
//
//  Created by Nagarjun Mallesh on 05/03/24.
//

import UIKit

class SongsPage: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var nextId : Int = 1
    
    
    public func alertMessage(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title:"Ok", style: UIAlertAction.Style.default, handler:nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet var SongTitleTxt: UITextField!
    
    @IBOutlet var songIdTxt: UITextField!
    @IBOutlet var songDisplayView: UITextView!
    @IBOutlet var favoriteTxt: UITextField!
    @IBOutlet var durationTxt: UITextField!
    @IBOutlet var genreIdTxt: UITextField!
    @IBOutlet var albumIdTxt: UITextField!
    @IBOutlet var artistIdTxt: UITextField!
    
    
    @IBAction func addBtn(_ sender: Any) {
                
        guard let songName = SongTitleTxt.text, let artistStringId = artistIdTxt.text, let albumStringId = albumIdTxt.text, let genreStringId = genreIdTxt.text, let durationString = durationTxt.text, !songName.isEmpty, !durationString.isEmpty, !genreStringId.isEmpty, !albumStringId.isEmpty, !artistStringId.isEmpty, let duration = Double(durationString), let albumId = Int(albumStringId), let artistId = Int(artistStringId), let genreId = Int(genreStringId) else {
            alertMessage("Please enter the details correctly.")
            return
        }
        
    
        
        guard ArtistService.shared.artistExists(artistId: artistId) else {
            alertMessage("Artist with ID - \(artistId) does not exist")
            return
        }
        
        guard AlbumService.shared.albumExists(albumId: albumId) else {
            alertMessage("Album with ID - \(albumId) does not exist")
            return
        }
        
        guard GenreService.shared.genreExists(genreId: genreId) else {
            alertMessage("Genre with ID - \(genreId) does not exist")
            return
        }
        
        
            let song = Song(id: nextId, artistId: artistId, albumId: albumId, genreId: genreId, title: songName, duration: duration, favorite: false)
            //AlbumService.shared.addSongToAlbum(albumId: albumId, song: song)
            SongService.shared.addSong(song)
            alertMessage("Song added successfully")
            SongTitleTxt.text = ""
            artistIdTxt.text=""
            albumIdTxt.text=""
            genreIdTxt.text=""
            durationTxt.text=""
    
        

    }

    @IBAction func updateBtn(_ sender: Any) {
        
        guard let songIdString = songIdTxt.text,
              let songId = Int(songIdString),!songIdString.isEmpty
        else{
            alertMessage("Please enter the correct song Id")
            return
        }
        
        guard let updatedSong = SongTitleTxt.text,!updatedSong.isEmpty,
              let duration = durationTxt.text,!duration.isEmpty,
              let updatedDuration = Double(duration)
        else{
            alertMessage("Please enter the correct songName and Duration")
            return
        }
        
        SongService.shared.updateSong(songId: songId, updatedSongName: updatedSong, duration: updatedDuration)
        alertMessage("Song have been updated successfully..")
        SongTitleTxt.text = ""
        durationTxt.text = ""
        songIdTxt.text=""
    }
        
    @IBAction func displayBtn(_ sender: Any) {
        
        let songs = SongService.shared.songDisplay()
        songDisplayView.text = songs
    }
    
    @IBAction func deleteBtn(_ sender: Any) {
        
        guard let songStringId = songIdTxt.text, !songStringId.isEmpty, let songId = Int(songStringId) else{
            alertMessage("Please enter the correct song Id")
            return
        }
        
        if SongService.shared.songDelete(songId: songId) {
            songIdTxt.text = ""
            alertMessage("Deleted Sucessfully..")
        }else{
            alertMessage("Song could not be deleted")
        }

    }

    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func searchBtn(_ sender: Any) {
        
        guard let name = SongTitleTxt.text, !name.isEmpty else {
            alertMessage("Enter the Correct Name")
            return
        }
        let songName = SongService.shared.findSongByName(songName: name)
        songDisplayView.text = songName
        SongTitleTxt.text = ""
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
