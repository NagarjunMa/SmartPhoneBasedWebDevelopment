//
//  ArtistControllerDisplay.swift
//  AssignmentNine
//
//  Created by Nagarjun Mallesh on 24/03/24.
//

import UIKit

class ArtistControllerDisplay: UITableViewController {


    
    var artists: [Artist] = []
    var selectedArtist : Artist?
    override func viewDidLoad() {
        super.viewDidLoad()
        artists = ArtistService.shared.artistDisplay()
        fetchArtists()

    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // Ensure you cast the dequeued cell to your custom cell type
        print("testing inside tableView")
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCell", for: indexPath)
        let artist = artists[indexPath.row]
    let details = "ArtistId : \(artist.id) ArtistName : \(artist.name)"

    cell.textLabel?.text=details

            return cell
        }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let artist = artists[indexPath.row]
        selectedArtist = artist
        
        performSegue(withIdentifier: "ShowArtistDetail", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowArtistDetail" {
            let productTVC = segue.destination as! ArtistEachDisplay
            productTVC.artist = selectedArtist
        }
    }

    // MARK: - Table view data source
    
    // Fetch artists from the API
        func fetchArtists() {
            guard let url = URL(string: "https://65feee10b2a18489b386c2a6.mockapi.io/artist") else { return }
            
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                if let data = data {
                    do {
                        let newArtists = try JSONDecoder().decode([Artist].self, from: data)
                        DispatchQueue.main.async {
                            self?.artists.append(contentsOf: newArtists)
                            self?.tableView.reloadData()
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }.resume()
        }

    

}
