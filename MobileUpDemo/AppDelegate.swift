//
//  AppDelegate.swift
//  MobileUpDemo
//
//  Created by Vladislav Grokhotov on 21.07.2021.
//

import UIKit
import CoreData
import Localizer

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Localizer.default = .en

        window = UIWindow.init(frame: UIScreen.main.bounds)
        if UsersInfoManager.shared.isAuthorized {
            let navigationController = UINavigationController()
            navigationController.setViewControllers([AlbumVC()], animated: false)
            window?.rootViewController = navigationController
        } else {
            window?.rootViewController = MainVC()
        }
        window?.makeKeyAndVisible()
        
        return true
    }
    
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MobileUpDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
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

