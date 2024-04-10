//
//  LandingPage.swift
//  AssignmentSeven
//
//  Created by Nagarjun Mallesh on 05/03/24.
//

import UIKit

class LandingPage: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func artistBtn(_ sender: UIButton) {
    // Presenting the ArtistPage modally
        let artistVC = ArtistPage(nibName: "ArtistPage", bundle: nil)
        self.present(artistVC, animated: true, completion: nil)
    }
    
    @IBAction func showAlbums(_ sender: UIButton) {
        
        let albumVC = AlbumPage(nibName: "AlbumPage", bundle: nil)
        self.present(albumVC, animated: true, completion: nil)
        
    }
    
    @IBAction func showGenres(_ sender: UIButton) {
        
        let genreVC = GenrePage(nibName: "GenrePage", bundle: nil)
        self.present(genreVC, animated: true, completion: nil)

        
    }
    @IBAction func songsBtn(_ sender: UIButton) {
        
        let songsVC = SongsPage(nibName: "SongsPage", bundle: nil)
        self.present(songsVC, animated: true, completion: nil)
        
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
