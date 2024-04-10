//
//  ViewController.swift
//  AssignmentNine
//
//  Created by Nagarjun Mallesh on 21/03/24.
//

import UIKit
import Network

class ViewController: UIViewController {
    
    private let monitor = NWPathMonitor()
    private let networkQueue = DispatchQueue(label: "NetworkMonitor")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        startNetworkMonitoring()
    }
    
    
    private func startNetworkMonitoring() {
            monitor.pathUpdateHandler = { [weak self] path in
                if path.status == .satisfied {
                    // Network is available
                    print("Internet connection is available")
                    DispatchQueue.main.async {
                        // This is where you can update your UI to reflect connectivity
                        // For example, you could call a method to fetch data from an API
                        self?.fetchData()
                    }
                } else {
                    // Network is unavailable
                    print("No internet connection")
                    DispatchQueue.main.async {
                        // Here you might update your UI to show a 'no connection' message
                        self?.showNoInternetConnectionAlert()
                    }
                }
            }

            monitor.start(queue: networkQueue)
        }

        private func fetchData() {
            print("the connection is established to fetch data ")
        }
        
        private func showNoInternetConnectionAlert() {
            // This method would show an alert to the user indicating there is no internet connection.
            let alert = UIAlertController(title: "No Internet Connection", message: "Please check your connection and try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            monitor.cancel()
        }


}

