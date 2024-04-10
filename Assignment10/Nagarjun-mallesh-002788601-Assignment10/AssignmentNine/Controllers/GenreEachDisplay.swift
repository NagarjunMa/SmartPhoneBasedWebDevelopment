//
//  GenreEachDisplay.swift
//  AssignmentNine
//
//  Created by Nagarjun Mallesh on 24/03/24.
//

import UIKit

class GenreEachDisplay: UITableViewController {

    @IBOutlet var genreIdTxt: UITextField!
    @IBOutlet var genreNameTxt: UITextField!
    var genre: Genre?
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    func updateUI(){
        
        if let genreId = genre?.id ,let genreName = genre?.name{
            genreNameTxt.text = genreName
            genreIdTxt.text = String(genreId)
        }
    }

    
}
