//
//  GenreDisplayList.swift
//  AssignmentNine
//
//  Created by Nagarjun Mallesh on 24/03/24.
//

import UIKit

class GenreDisplayList: UITableViewController {

    var genres: [Genre] = []
    var selectedGenre: Genre?

    override func viewDidLoad() {
        super.viewDidLoad()
        genres = GenreService.shared.genreDisplay()

       
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return genres.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // Ensure you cast the dequeued cell to your custom cell type
        print("testing inside tableView")
            let cell = tableView.dequeueReusableCell(withIdentifier: "GenreCell", for: indexPath)
            let genre = genres[indexPath.row]
        let details = "Genre ID: \(genre.id) Genre Name: \(genre.name)"

        cell.textLabel?.text=details

            return cell
        }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let genre = genres[indexPath.row]
        selectedGenre = genre
        
        performSegue(withIdentifier: "ShowGenreDetail", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowGenreDetail" {
            let productTVC = segue.destination as! GenreEachDisplay
            productTVC.genre = selectedGenre
        }
    }
}
