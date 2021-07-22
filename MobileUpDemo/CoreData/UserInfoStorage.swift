//
//  UserInfoStorage.swift
//  MobileUpDemo
//
//  Created by Vladislav Grokhotov on 22.07.2021.
//

import UIKit
import CoreData

protocol UsersInfoDataManager {
    
    func save(user: UserInfo, completion: @escaping () -> ())
    
    func get() -> UserInfo?
    
    func delete(completion: @escaping () -> ())
    
}

class UserInfoStorage: UsersInfoDataManager {
    
    static let shared = UserInfoStorage()
    private init() {}
    
    private lazy var container: NSPersistentContainer = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if let appDelegate = appDelegate {
            return appDelegate.persistentContainer
        }
        return NSPersistentContainer()
    }()
    
    private var fetchRequest = NSFetchRequest<UserInfoObject>(entityName: "UserInfoObject")
    
    func save(user: UserInfo, completion: @escaping () -> ()) {

        container.performBackgroundTask { (context) in
            
            guard let allUsersInfo = try? context.fetch(self.fetchRequest) else { return }
            
            for userInfoInContext in allUsersInfo {
                context.delete(userInfoInContext)
            }
            
            let currentUserInfoObject = NSEntityDescription.insertNewObject(forEntityName: "UserInfoObject", into: context) as? UserInfoObject
            
            currentUserInfoObject?.token = user.token
            currentUserInfoObject?.expires = user.expires
            currentUserInfoObject?.id = user.id
            
            try? context.save()
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func get() -> UserInfo? {
        
        guard let allUsersInfo = try? container.viewContext.fetch(fetchRequest) else { return nil }
            
        return allUsersInfo.first?.toUserInfo()
    }
    
    func delete(completion: @escaping () -> ()) {
        
        container.performBackgroundTask { (context) in
            
            guard let allUsersInfo = try? context.fetch(self.fetchRequest) else { return }
            
            for userInfoInContext in allUsersInfo {
                context.delete(userInfoInContext)
            }
            
            try? context.save()
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
