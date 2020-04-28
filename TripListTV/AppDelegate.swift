//
//  AppDelegate.swift
//  TripListTV
//
//  Created by Julien Vanheule on 21/04/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let tabBarController = self.window!.rootViewController as! UITabBarController
        
        tabBarController.viewControllers?.append(createSearch(storyboard: tabBarController.storyboard))
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }


    func createSearch(storyboard: UIStoryboard?) -> UIViewController {
        guard let searchResultVC = storyboard?.instantiateViewController(withIdentifier: "SearchResultViewController") as? SearchResultViewController else {
            fatalError("Unable to instantiate a SearchResultViewController")
        }
        
        let searchController = UISearchController(searchResultsController: searchResultVC)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = searchResultVC
        
        let searchContainer = UISearchContainerViewController(searchController: searchController)
        searchContainer.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        return searchContainer
    }
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "TripList")
        
        // Enable remote notifications
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("###\(#function): Failed to retrieve a persistent store description.")
        }
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
            
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.processUpdate(notification:)), name: .NSPersistentStoreRemoteChange, object: nil)
        
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("context saved")
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    @objc func processUpdate(notification: NSNotification) {
        operationQueue.addOperation {
            //process notification
            
            let context = self.persistentContainer.newBackgroundContext()
            context.performAndWait {
                let dreams: [Dream]
                do {
                    try dreams = context.fetch(Dream.getAllDreams())
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
                
                //reorder Dreams
                dreams.enumerated().forEach { index, item in
                    if item.order != index {
                        item.order = index
                    }
                }
                
                if context.hasChanges {
                    do {
                        try context.save()
                    } catch {
                        let nserror = error as NSError
                        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                    }
                }
            }
        }
    }
    
    lazy var operationQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}

