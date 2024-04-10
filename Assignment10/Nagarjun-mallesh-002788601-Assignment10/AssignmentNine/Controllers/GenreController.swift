//
//  GenreController.swift
//  AssignmentNine
//
//  Created by Nagarjun Mallesh on 24/03/24.
//

import UIKit

class GenreController: UIViewController {
    
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
    
    @IBOutlet var genreNameTxt: UITextField!
    @IBOutlet var genreIdTxt: UITextField!
    
    @IBAction func updateGenre(_ sender: Any) {
        
        guard let genreStringId = genreIdTxt.text, let genreName = genreNameTxt.text, !genreStringId.isEmpty, !genreName.isEmpty, let genreId = Int(genreStringId) else {
            alertMessage("Please enter the correct genre information")
            return
        }
        
        GenreService.shared.updateGenre(genreId: genreId, newGenreName: genreName)
        alertMessage("Genre Updated Successfully..")
        genreIdTxt.text = ""
        genreNameTxt.text = ""
        
    }
    
    @IBAction func addGenreBtn(_ sender: Any) {
        
        guard let name = genreNameTxt.text, !name.isEmpty else {
            alertMessage("Enter the details correctly")
            return
        }
        
        let genre = Genre(id: nextId, name: name)
        GenreService.shared.addGenre(genre)
        nextId += 1
        genreNameTxt.text = ""
        alertMessage("The genre is created successfully")
        
        
    }
    
    @IBAction func deleteGenre(_ sender: Any) {
        
        guard let genreStringId = genreIdTxt.text, !genreStringId.isEmpty, let genreId = Int(genreStringId) else {
            alertMessage("Please enter the correct genre ID")
            return
        }
        
        if GenreService.shared.genreExists(genreId: genreId) {
            let songCount = SongService.shared.checkSongsInGenre(genreId: genreId)
            if  songCount > 0 {
                alertMessage("Genres cannot be deleted as there are Songs under the following genre")
            }else {
                if GenreService.shared.genreDelete(genreId: genreId) {
                    alertMessage("Genre Deleted Successfully")
                } else {
                    alertMessage("Genre could not be deleted..")
                }
            }
        }else {
            alertMessage("Genre not found...")
        }
        genreIdTxt.text = ""
        genreNameTxt.text = ""
        
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
