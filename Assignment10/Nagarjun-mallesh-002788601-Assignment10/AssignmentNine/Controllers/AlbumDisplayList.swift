//
//  AlbumDisplayList.swift
//  AssignmentNine
//
//  Created by Nagarjun Mallesh on 24/03/24.
//

import UIKit

class AlbumDisplayList: UITableViewController {
    
    var albums: [Album] = []
    var selectedAlbum : Album?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        albums = AlbumService.shared.albumDisplay()
        fetchAlbums()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // Ensure you cast the dequeued cell to your custom cell type
        print("testing inside tableView")
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath)
            let album = albums[indexPath.row]
        let details = "AlbumId: \(album.id) AlbumName: \(album.title)"

        cell.textLabel?.text=details

            return cell
        }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let album = albums[indexPath.row]
        selectedAlbum = album
        
        performSegue(withIdentifier: "ShowAlbumDetail", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAlbumDetail" {
            let productTVC = segue.destination as! AlbumEachDisplay
            productTVC.album = selectedAlbum
        }
    }
    
    
    func fetchAlbums() {
        guard let url = URL(string: "https://65feee10b2a18489b386c2a6.mockapi.io/album") else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let data = data {
                do {
                    let newAlbums = try JSONDecoder().decode([Album].self, from: data)
                    DispatchQueue.main.async {
                        self?.albums.append(contentsOf: newAlbums)
                        self?.tableView.reloadData()
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }
    
    
    
    

}
