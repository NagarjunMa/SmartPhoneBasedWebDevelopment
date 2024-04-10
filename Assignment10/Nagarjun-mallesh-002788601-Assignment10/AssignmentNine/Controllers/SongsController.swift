//
//  SongsController.swift
//  AssignmentNine
//
//  Created by Nagarjun Mallesh on 24/03/24.
//

import UIKit

class SongsController: UIViewController {
    
    var nextId: Int = 1
    
    public func alertMessage(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title:"Ok", style: UIAlertAction.Style.default, handler:nil))
        self.present(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        // Do any additional setup after loading the view.
        // Dismiss the keyboard when tapping outside of a text field
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // So the tap doesn't interfere with other controls
        view.addGestureRecognizer(tapGesture)
    }
    @IBOutlet var songDurationTxt: UITextField!
    

    @IBOutlet var genreIdTxt: UITextField!
    @IBOutlet var artistIdTxt: UITextField!
    @IBOutlet var songNameTxt: UITextField!
    @IBOutlet var albumIdTxt: UITextField!
    
    @IBOutlet var songIdTxt: UITextField!
    

    @IBOutlet var songUpdateID: UITextField!
    
    @IBAction func addSong(_ sender: Any) {
        
        guard let songName = songNameTxt.text, let artistStringId = artistIdTxt.text, let albumStringId = albumIdTxt.text, let genreStringId = genreIdTxt.text, let durationString = songDurationTxt.text, !songName.isEmpty, !durationString.isEmpty, !genreStringId.isEmpty, !albumStringId.isEmpty, !artistStringId.isEmpty, let duration = Double(durationString), let albumId = Int(albumStringId), let artistId = Int(artistStringId), let genreId = Int(genreStringId) else {
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
            songNameTxt.text = ""
            artistIdTxt.text=""
            albumIdTxt.text=""
            genreIdTxt.text=""
            songDurationTxt.text=""
        
    }
    
    
    @IBAction func deleteSong(_ sender: Any) {
        
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
    
    
    @IBAction func updateSong(_ sender: Any) {
        
        guard let songIdString = songUpdateID.text,
              let songId = Int(songIdString),!songIdString.isEmpty
        else{
            alertMessage("Please enter the correct song Id")
            return
        }
        
        guard let updatedSong = songNameTxt.text,!updatedSong.isEmpty,
              let duration = songDurationTxt.text,!duration.isEmpty,
              let updatedDuration = Double(duration)
        else{
            alertMessage("Please enter the correct songName and Duration")
            return
        }
        
        SongService.shared.updateSong(songId: songId, updatedSongName: updatedSong, duration: updatedDuration)
        alertMessage("Song have been updated successfully..")
        songNameTxt.text = ""
        songDurationTxt.text = ""
        songUpdateID.text=""
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

        // Check if the view has already been moved up
        if self.view.frame.origin.y == 0 {
            // Move the view's origin up so that the text field that might be hidden comes into view
            self.view.frame.origin.y -= keyboardSize.height
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        // Move the view back to its original place
        self.view.frame.origin.y = 0
    }

    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}
