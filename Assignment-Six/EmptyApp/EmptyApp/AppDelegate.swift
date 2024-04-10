//
//  AppDelegate.swift
//  EmptyApp
//
//  Created by rab on 02/15/24.
//  Copyright © 2024 rab. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let landingPageView = LandingPage(frame: window!.bounds)
        let artistManagementView = ArtistManagementView(frame: window!.bounds)
        let songsView = SongsView(frame: window!.bounds)
        let genreView = GenreView(frame: window!.bounds)
        let albumView = AlbumView(frame: window!.bounds)
        
        albumView.isHidden = true
        artistManagementView.isHidden = true
        songsView.isHidden = true
        genreView.isHidden = true
        
        
        landingPageView.artistView = artistManagementView
        landingPageView.albumView = albumView
        landingPageView.songView = songsView
        landingPageView.genreView = genreView
        
        artistManagementView.landingPage = landingPageView
        albumView.landing = landingPageView
        songsView.landingPage = landingPageView
        genreView.landingPage = landingPageView
        
        let mainViewController = UIViewController()
        mainViewController.view.addSubview(artistManagementView)
        mainViewController.view.addSubview(albumView)
        mainViewController.view.addSubview(songsView)
        mainViewController.view.addSubview(genreView)
        mainViewController.view.addSubview(landingPageView)

        if let window = window {
            window.backgroundColor = UIColor.white
            window.rootViewController = mainViewController
            window.makeKeyAndVisible()
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

