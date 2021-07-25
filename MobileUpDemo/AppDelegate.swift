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
    var isAuthorized = false {
        didSet {
            guard let window = window else { return }
            UserInfoManager.shared.getUserInfo()
            if isAuthorized {
                let navigationController = UINavigationController()
                navigationController.setViewControllers([AlbumVC()], animated: false)
                window.rootViewController = navigationController
            } else {
                window.rootViewController = MainVC()
            }
            window.makeKeyAndVisible()
            
            UIView.transition(with: window, duration: 0.7, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Localizer.default = .en

        window = UIWindow.init(frame: UIScreen.main.bounds)
        UserInfoManager.shared.getUserInfo()
        if let _ = UserInfoManager.shared.userInfo {
            isAuthorized = true
        } else {
            isAuthorized = false
        }
        
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

