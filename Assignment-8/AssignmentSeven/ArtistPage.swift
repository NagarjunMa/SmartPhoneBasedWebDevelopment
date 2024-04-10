//
//  ArtistPage.swift
//  AssignmentSeven
//
//  Created by Nagarjun Mallesh on 05/03/24.
//

import UIKit

class ArtistPage: UIViewController, UITextFieldDelegate {
    
    var nextId:Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var displayArtistView: UITextView!
    

    @IBOutlet var artistIDText: UITextField!
    
    @IBOutlet var artistNameTxt: UITextField!
    
    public func alertMessage(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title:"Ok", style: UIAlertAction.Style.default, handler:nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addArtistBtn(_ sender: Any) {
        guard let name = artistNameTxt.text, !name.isEmpty else {
            alertMessage("Please Enter the correct Name..")
            return
        }
        
        let artist = Artist(id: nextId, name: name)
        ArtistService.shared.addArtist(artist)
        nextId += 1
        alertMessage("Artist Added Successfully")
        artistIDText.text = ""
        artistNameTxt.text = ""
        
    }
    
    @IBAction func displayBtn(_ sender: Any) {
        
        let artists = ArtistService.shared.artistDisplay()
        displayArtistView.text = artists
    }
    
    
    @IBAction func deleteBtn(_ sender: Any) {
        
        guard let artistStringId = artistIDText.text, let id = Int(artistStringId), !artistStringId.isEmpty else {
            
            alertMessage("Please enter the correct Id")
            return
        }
        
        if ArtistService.shared.artistExists(artistId: id) {
            let albumCount = ArtistService.shared.checkAlbumsinArtist(artistId: id)
            if albumCount > 0 {
                alertMessage("There are albums for artist. Cannot download the artist")
            }else{
                if ArtistService.shared.artistDelete(artistId: id) {
                    alertMessage("Artist Deleted Successfully")
                }else {
                    alertMessage("Artist deletion unsuccessful")
                }
            }

        }
        
        artistIDText.text=""
        
    }
    
    @IBAction func updateBtn(_ sender: UIButton) {
        
        guard let name = artistNameTxt.text, let artistStringId = artistIDText.text,
              !artistStringId.isEmpty, !name.isEmpty, let id = Int(artistStringId) else {
            alertMessage("Please enter the correct information to update")
            return
        }
        
        ArtistService.shared.updateArtistName(artistId: id, newName: name)
        alertMessage("Artist Updated Successfully..")
        artistIDText.text = ""
        artistNameTxt.text = ""
        
    }
    
    
    @IBAction func searchBtn(_ sender: Any) {
        guard let name = artistNameTxt.text, !name.isEmpty else {
            alertMessage("Enter the Correct Name")
            return
        }
        
        let artistName = ArtistService.shared.findArtistByName(artistName: name)
        displayArtistView.text = artistName
        artistNameTxt.text = ""
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
