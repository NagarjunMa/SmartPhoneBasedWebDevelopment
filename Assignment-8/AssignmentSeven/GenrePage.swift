//
//  GenrePage.swift
//  AssignmentSeven
//
//  Created by Nagarjun Mallesh on 05/03/24.
//

import UIKit

class GenrePage: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var nextId: Int = 1
    
    
    public func alertMessage(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title:"Ok", style: UIAlertAction.Style.default, handler:nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    @IBOutlet var genreDisplayView: UITextView!
    @IBOutlet var genreNameTxt: UITextField!
    @IBOutlet var genreIdTxt: UITextField!
    
    @IBAction func addBtn(_ sender: Any) {
        guard let genreName = genreNameTxt.text, !genreName.isEmpty else {
            alertMessage("Please enter the correct genre Name")
            return
        }
        
        let genre = Genre(id: nextId, name: genreName)
        GenreService.shared.addGenre(genre)
        alertMessage("Successfully added genre..")
        genreNameTxt.text = ""
    }
    

    @IBAction func backBtn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func displayBtn(_ sender: Any) {
        
        let displayGenre = GenreService.shared.genreDisplay()
        genreDisplayView.text = displayGenre
    }
    
    
    @IBAction func updateBtn(_ sender: Any) {
        
        guard let genreStringId = genreIdTxt.text, let genreName = genreNameTxt.text, !genreStringId.isEmpty, !genreName.isEmpty, let genreId = Int(genreStringId) else {
            alertMessage("Please enter the correct genre information")
            return
        }
        
        GenreService.shared.updateGenre(genreId: genreId, newGenreName: genreName)
        alertMessage("Genre Updated Successfully..")
        genreIdTxt.text = ""
        genreNameTxt.text = ""
        
    }
    
    
    @IBAction func deleteBtn(_ sender: Any) {
        
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
    
    
    @IBAction func searchBtn(_ sender: Any) {
        guard let name = genreNameTxt.text, !name.isEmpty else {
            alertMessage("Enter the Correct Name")
            return
        }
        print("Entering the genre search")
        let genreName = GenreService.shared.findGenreByName(genreName: name)
        genreDisplayView.text = genreName
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

}
