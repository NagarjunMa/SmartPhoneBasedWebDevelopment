//
//  ArtistController.swift
//  AssignmentNine
//
//  Created by Nagarjun Mallesh on 22/03/24.
//

import UIKit

class ArtistController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    var nextId : Int = 1
    var currentArtistName : String?
    var image: UIImage?

    @IBOutlet var artistIdTxt: UITextField!
    @IBOutlet var artistImg: UIImageView!
    @IBOutlet var artistNameTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.artistImg.layer.borderColor = UIColor.systemOrange.cgColor
        self.artistImg.layer.masksToBounds = false
        self.artistImg.layer.cornerRadius = artistImg.frame.size.height/2
        self.artistImg.clipsToBounds = true
        
        tapGesture()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        // Do any additional setup after loading the view.
        // Dismiss the keyboard when tapping outside of a text field
        let tapGestureKb = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureKb.cancelsTouchesInView = false // So the tap doesn't interfere with other controls
        view.addGestureRecognizer(tapGestureKb)
    }
    
    
    public func alertMessage(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title:"Ok", style: UIAlertAction.Style.default, handler:nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func tapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        print("tsting inside the tapGesture")
        artistImg.isUserInteractionEnabled = true
        artistImg.addGestureRecognizer(tap)
    }
    
    
    @objc func imageTapped(){
        let imagePicker = UIImagePickerController()
        print("tsting inside the imageTapped")
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let selectedImage = info[.originalImage] as? UIImage {
            // Assuming 'artistName' is available and is a unique identifier
            image = selectedImage
            artistImg.image = image
        }
    }
    
    

    
    
    // Save the selected image with the artist's name as the filename
    func saveImage(image: UIImage, artistName: String) {
        guard let imageData = image.jpegData(compressionQuality: 1) else { return }
        
        let filePath = getDocumentsDirectory().appendingPathComponent("\(artistName).jpg")
        try? imageData.write(to: filePath)
    }
    
    // Helper function to get the path to the documents directory
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    

    
    @IBAction func addArtistBtn(_ sender: Any) {
        guard let name = artistNameTxt.text, !name.isEmpty else {
            alertMessage("Please Enter the correct artist Name : ")
            return
        }
        
        if let imageToSave = image {
            saveImage(image: imageToSave, artistName: name)
            let artist = Artist(id: nextId, name: name)
            ArtistService.shared.addArtist(artist)
            
            currentArtistName = name
            artistNameTxt.text = ""
            artistImg.image = nil
            image = nil
            alertMessage("The artist is created successfully...")
        } else {
            alertMessage("Please Select an image for the artist")
        }

        

        
    }
    @IBAction func updateArtistBtn(_ sender: Any) {
        
        guard let name = artistNameTxt.text, let artistStringId = artistIdTxt.text,
              !artistStringId.isEmpty, !name.isEmpty, let id = Int(artistStringId) else {
            alertMessage("Please enter the correct information to update")
            return
        }
        
        ArtistService.shared.updateArtistName(artistId: id, newName: name)
        alertMessage("Artist Updated Successfully..")
        artistIdTxt.text = ""
        artistNameTxt.text = ""
        
    }
    
    
    @IBAction func deleteArtistBtn(_ sender: Any) {
        
        guard let artistString = artistIdTxt.text, !artistString.isEmpty, let artistId = Int(artistString) else {
            alertMessage("Enter the correct artist ID")
            return
        }
        
        if ArtistService.shared.artistExists(artistId: artistId) {
            let albumCount = ArtistService.shared.checkAlbumsinArtist(artistId: artistId)
            if albumCount > 0 {
                alertMessage("There are albums for artist. Cannot download the artist")
            }else{
                if ArtistService.shared.artistDelete(artistId: artistId) {
                    alertMessage("Artist Deleted Successfully")
                }else {
                    alertMessage("Artist deletion unsuccessful")
                }
            }

        }
        
        artistIdTxt.text=""
        
    }
    
    
    @IBAction func displayArtistBtn(_ sender: Any) {
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
