//
//  AlbumPage.swift
//  AssignmentSeven
//
//  Created by Nagarjun Mallesh on 05/03/24.
//

import UIKit

class AlbumPage: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var nextId:Int  = 1
    
    public func alertMessage(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title:"Ok", style: UIAlertAction.Style.default, handler:nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBOutlet var displayAlbumView: UITextView!
    @IBOutlet var albumIdTxt: UITextField!
    @IBOutlet var releaseDateTxt: UITextField!
    @IBOutlet var artistIdTxt: UITextField!
    @IBOutlet var albumNameTxt: UITextField!
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    

    @IBAction func addAlbum(_ sender: Any) {
        
        guard let name = albumNameTxt.text, let artistId = artistIdTxt.text, let releaseDate = releaseDateTxt.text, !name.isEmpty, !artistId.isEmpty, !releaseDate.isEmpty, let artistID = Int(artistId) else {
            alertMessage("Please enter the details correctly..")
            return
        }
        
        guard AlbumService.shared.isValidReleaseDate(releaseDate) else {
            alertMessage("Enter the correct date format")
            return
        }
        
        let album = Album(id: nextId, artistId: artistID, title: name, releaseDate: releaseDate)
        if ArtistService.shared.artistExists(artistId: artistID) {
            AlbumService.shared.addAlbum(album)
            alertMessage("Album added successfully..")
        } else {
            alertMessage("The Artisti doesn't exist to create album")
        }

        
        albumIdTxt.text = ""
        artistIdTxt.text = ""
        releaseDateTxt.text = ""
        albumNameTxt.text = ""
        
        
    }
    
    
    @IBAction func updateAlbum(_ sender: Any) {
        
        guard let albumStringId = albumIdTxt.text, let name = albumNameTxt.text, let releaseDate = releaseDateTxt.text, !albumStringId.isEmpty, !name.isEmpty, !releaseDate.isEmpty, let albumId = Int(albumStringId) else {
            alertMessage("please enter the correct details to update..")
            return
        }
        
        
        AlbumService.shared.updateAlbum(albumId: albumId, newAlbumName: name, newRelease: releaseDate)
        alertMessage("Album details updated successfully..")
        albumIdTxt.text = ""
        artistIdTxt.text = ""
        releaseDateTxt.text = ""
        albumNameTxt.text = ""
        
    }
    
    
    
    @IBAction func displayAlbum(_ sender: Any) {
        
        let displayAlbum = AlbumService.shared.albumDisplay()
        displayAlbumView.text = displayAlbum
    }
    
    
    @IBAction func deleteBtn(_ sender: Any) {
        
        
        guard let idString = albumIdTxt.text, let id = Int(idString), !idString.isEmpty else {
             alertMessage("Please enter the valid Album ID")
             return
         }
        
        
         
        if AlbumService.shared.albumExists(albumId: id) {
            let count = SongService.shared.checkSongsInAlbum(albumId: id)
            if  count > 0 {
                alertMessage("There are songs of this album. Album cannot be deleted")
            }else {
                if AlbumService.shared.albumDelete(albumId: id) {
                    alertMessage("Album with ID \(id) has been deleted successfully..")
                }else{
                    alertMessage("Album with ID \(id) could not be deleted..")
                }
            }
         }else{
             alertMessage("No Album found with ID \(id).")
         }
         
         albumIdTxt.text = ""
        alertMessage("NEEDS TO BE PROCESSED YET... ")
        
    }
    
    
    
    @IBAction func searchBtn(_ sender: Any) {
        
        guard let name = albumNameTxt.text, !name.isEmpty else {
            alertMessage("Enter the Correct Name")
            return
        }
        
        let artistName = AlbumService.shared.findAlbumByName(albumName: name)
        displayAlbumView.text = artistName
        albumNameTxt.text = ""
        
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
