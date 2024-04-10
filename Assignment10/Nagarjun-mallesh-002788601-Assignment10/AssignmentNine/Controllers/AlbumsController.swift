//
//  AlbumsController.swift
//  AssignmentNine
//
//  Created by Nagarjun Mallesh on 24/03/24.
//

import UIKit

class AlbumsController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var nextId : Int = 1
    
    public func alertMessage(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title:"Ok", style: UIAlertAction.Style.default, handler:nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        // Do any additional setup after loading the view.
        // Dismiss the keyboard when tapping outside of a text field
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // So the tap doesn't interfere with other controls
        view.addGestureRecognizer(tapGesture)
    }
    

    @IBOutlet var AlbumNameTxt: UITextField!

    @IBOutlet var artistIdTxt: UITextField!
    @IBOutlet var releaseDate: UIDatePicker!
    
    @IBOutlet var albumIdTxt: UITextField!
    
    @IBAction func addAlbum(_ sender: Any) {
        guard let albumName = AlbumNameTxt.text,let artistString = artistIdTxt.text, !artistString.isEmpty, !albumName.isEmpty,
        let artistId = Int(artistString) else {
            alertMessage("Enter the correct details to create album")
           return
        }
        
        let releaseDate = releaseDate.date
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd" // Adjust the format as needed
            let dateString = dateFormatter.string(from: releaseDate)
        
        if ArtistService.shared.artistExists(artistId: artistId){
            let album = Album(id: nextId, artistId: artistId, title: albumName, releaseDate: dateString)
            AlbumService.shared.addAlbum(album)
            nextId += 1
            AlbumNameTxt.text = ""
            artistIdTxt.text = ""
            alertMessage("Created the albums successfully...")
        }else {
            alertMessage("Artist ID doesn't exist to create the album")
        }
        
        
    }
    @IBAction func deleteAlbum(_ sender: Any) {
        
        guard let idString = albumIdTxt.text, let id = Int(idString), !idString.isEmpty else {
             alertMessage("Please enter the valid Album ID")
             return
         }

         print("testing \(id)")
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
        
        
    }
    @IBAction func updateAlbum(_ sender: Any) {
        
        
        guard let albumStringId = albumIdTxt.text, let name = AlbumNameTxt.text, !albumStringId.isEmpty, !name.isEmpty, let albumId = Int(albumStringId) else {
            alertMessage("please enter the correct details to update..")
            return
        }
        
        let releaseDate = releaseDate.date
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd" // Adjust the format as needed
            let dateString = dateFormatter.string(from: releaseDate)
        
        AlbumService.shared.updateAlbum(albumId: albumId, newAlbumName: name, newRelease: dateString)
        alertMessage("Album details updated successfully..")
        albumIdTxt.text = ""
        artistIdTxt.text = ""
        AlbumNameTxt.text = ""
        
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
